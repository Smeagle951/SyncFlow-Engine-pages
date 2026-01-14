const express = require('express');
const db = require('../database/db');
const authenticate = require('../middleware/auth');

const router = express.Router();

// Todas as rotas de sync requerem autenticação
router.use(authenticate);

// POST /sync/push - Recebe dados do cliente para sincronizar
router.post('/push', (req, res) => {
  const { records } = req.body;
  const userId = req.user.userId;

  if (!Array.isArray(records)) {
    return res.status(400).json({ error: 'records deve ser um array' });
  }

  const conflicts = [];
  const synced = [];
  const errors = [];
  let processed = 0;

  if (records.length === 0) {
    return res.json({ synced, conflicts, errors: undefined });
  }

  // Processar cada record
  records.forEach((record) => {
    const { uuid, data, version } = record;

    if (!uuid || data === undefined || !version) {
      errors.push({ uuid: uuid || 'unknown', error: 'Campos obrigatórios faltando' });
      processed++;
      if (processed === records.length) {
        res.json({
          synced,
          conflicts,
          errors: errors.length > 0 ? errors : undefined
        });
      }
      return;
    }

    // Verificar se o record existe no servidor
    db.get(
      'SELECT * FROM records WHERE uuid = ? AND user_id = ?',
      [uuid, userId],
      (err, existing) => {
        if (err) {
          errors.push({ uuid, error: 'Erro ao buscar record' });
          processed++;
          if (processed === records.length) {
            res.json({
              synced,
              conflicts,
              errors: errors.length > 0 ? errors : undefined
            });
          }
          return;
        }

        if (existing) {
          // Verificar conflito de versão
          if (existing.version >= version) {
            conflicts.push({
              uuid,
              serverVersion: existing.version,
              clientVersion: version,
              serverData: JSON.parse(existing.data)
            });
            processed++;
            if (processed === records.length) {
              res.json({
                synced,
                conflicts,
                errors: errors.length > 0 ? errors : undefined
              });
            }
            return;
          }
        }

        // Atualizar ou inserir
        const now = new Date().toISOString();
        const dataJson = JSON.stringify(data);

        if (existing) {
          db.run(
            'UPDATE records SET data = ?, version = ?, updated_at = ?, deleted_at = ? WHERE uuid = ? AND user_id = ?',
            [dataJson, version, now, record.deleted_at || null, uuid, userId],
            (err) => {
              if (err) {
                errors.push({ uuid, error: 'Erro ao atualizar' });
              } else {
                synced.push({ uuid, version });
              }
              processed++;
              if (processed === records.length) {
                res.json({
                  synced,
                  conflicts,
                  errors: errors.length > 0 ? errors : undefined
                });
              }
            }
          );
        } else {
          db.run(
            'INSERT INTO records (uuid, data, version, updated_at, deleted_at, user_id) VALUES (?, ?, ?, ?, ?, ?)',
            [uuid, dataJson, version, now, record.deleted_at || null, userId],
            (err) => {
              if (err) {
                errors.push({ uuid, error: 'Erro ao inserir' });
              } else {
                synced.push({ uuid, version });
              }
              processed++;
              if (processed === records.length) {
                res.json({
                  synced,
                  conflicts,
                  errors: errors.length > 0 ? errors : undefined
                });
              }
            }
          );
        }
      }
    );
  });
});

// GET /sync/pull - Busca dados atualizados desde um timestamp
router.get('/pull', (req, res) => {
  const userId = req.user.userId;
  const since = req.query.since || '1970-01-01T00:00:00.000Z';

  db.all(
    `SELECT uuid, data, version, updated_at, deleted_at 
     FROM records 
     WHERE user_id = ? AND updated_at > ? 
     ORDER BY updated_at ASC`,
    [userId, since],
    (err, rows) => {
      if (err) {
        return res.status(500).json({ error: 'Erro ao buscar records' });
      }

      const records = rows.map(row => ({
        uuid: row.uuid,
        data: JSON.parse(row.data),
        version: row.version,
        updated_at: row.updated_at,
        deleted_at: row.deleted_at
      }));

      res.json({
        records,
        timestamp: new Date().toISOString()
      });
    }
  );
});

module.exports = router;
