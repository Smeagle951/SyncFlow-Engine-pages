import 'package:flutter/material.dart';
import 'package:offline_sync_pro/domain/models/record.dart';

class RecordCard extends StatelessWidget {
  final Record record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecordCard({
    super.key,
    required this.record,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getStatusColor(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return Colors.green;
      case SyncStatus.pending:
        return Colors.orange;
      case SyncStatus.conflict:
        return Colors.red;
      case SyncStatus.error:
        return Colors.red.shade900;
    }
  }

  String _getStatusText(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return 'Sincronizado';
      case SyncStatus.pending:
        return 'Pendente';
      case SyncStatus.conflict:
        return 'Conflito';
      case SyncStatus.error:
        return 'Erro';
    }
  }

  IconData _getStatusIcon(SyncStatus status) {
    switch (status) {
      case SyncStatus.synced:
        return Icons.check_circle;
      case SyncStatus.pending:
        return Icons.pending;
      case SyncStatus.conflict:
        return Icons.warning;
      case SyncStatus.error:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        title: Text(
          record.data,
          style: TextStyle(
            decoration: record.isDeleted ? TextDecoration.lineThrough : null,
            color: record.isDeleted ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  _getStatusIcon(record.syncStatus),
                  size: 16,
                  color: _getStatusColor(record.syncStatus),
                ),
                const SizedBox(width: 4),
                Text(
                  _getStatusText(record.syncStatus),
                  style: TextStyle(
                    color: _getStatusColor(record.syncStatus),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'v${record.version}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Atualizado: ${_formatDate(record.updatedAt)}',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Excluir', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }
}
