const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 3002;
const FILE_PATH = path.join(__dirname, 'index.html');

const server = http.createServer((req, res) => {
    let filePath;
    let contentType = 'text/html';

    // Log da requisição
    console.log(`[${new Date().toLocaleTimeString()}] ${req.method} ${req.url}`);

    // Determinar o arquivo solicitado
    if (req.url === '/' || req.url === '/index.html') {
        filePath = FILE_PATH;
        contentType = 'text/html; charset=utf-8';
    } else if (req.url === '/checkout.html' || req.url === '/checkout.html/') {
        filePath = path.join(__dirname, 'checkout.html');
        contentType = 'text/html; charset=utf-8';
    } else if (req.url === '/thankyou.html' || req.url === '/thankyou.html/') {
        filePath = path.join(__dirname, 'thankyou.html');
        contentType = 'text/html; charset=utf-8';
    } else if (req.url === '/access.html' || req.url === '/access.html/') {
        filePath = path.join(__dirname, 'access.html');
        contentType = 'text/html; charset=utf-8';
    } else if (req.url.startsWith('/images/')) {
        // Servir imagens da pasta images
        filePath = path.join(__dirname, req.url);

        // Determinar tipo de conteúdo baseado na extensão
        const ext = path.extname(filePath).toLowerCase();
        const contentTypes = {
            '.png': 'image/png',
            '.jpg': 'image/jpeg',
            '.jpeg': 'image/jpeg',
            '.gif': 'image/gif',
            '.svg': 'image/svg+xml',
            '.webp': 'image/webp'
        };
        contentType = contentTypes[ext] || 'application/octet-stream';
    } else {
        console.log(`❌ 404: ${req.url} não encontrado`);
        res.writeHead(404, { 'Content-Type': 'text/html; charset=utf-8' });
        res.end(`<html><body><h1>404 - Página não encontrada</h1><p>URL solicitada: ${req.url}</p><p><a href="/">Voltar para home</a></p></body></html>`);
        return;
    }

    // Ler e servir o arquivo
    // Para HTML, ler como UTF-8; para imagens, ler como binário
    const encoding = contentType.startsWith('text/html') ? 'utf8' : null;

    // Verificar se o arquivo existe antes de tentar ler
    fs.access(filePath, fs.constants.F_OK, (err) => {
        if (err) {
            console.log(`❌ Arquivo não encontrado: ${filePath}`);
            res.writeHead(404, { 'Content-Type': 'text/html; charset=utf-8' });
            res.end(`<html><body><h1>404 - Arquivo não encontrado</h1><p>Caminho: ${filePath}</p><p><a href="/">Voltar para home</a></p></body></html>`);
            return;
        }

        // Ler e servir o arquivo
        fs.readFile(filePath, encoding, (err, data) => {
            if (err) {
                console.log(`❌ Erro ao ler arquivo: ${err.message}`);
                res.writeHead(500, { 'Content-Type': 'text/html; charset=utf-8' });
                res.end(`<html><body><h1>500 - Erro interno</h1><p>Erro: ${err.message}</p></body></html>`);
                return;
            }

            console.log(`✅ Servindo: ${filePath}`);
            res.writeHead(200, {
                'Content-Type': contentType,
                'Cache-Control': 'no-cache'
            });
            res.end(data);
        });
    });
});

server.listen(PORT, () => {
    console.log('\n╔══════════════════════════════════════════════════════════╗');
    console.log('║  🚀 Servidor da Landing Page rodando!                    ║');
    console.log('╚══════════════════════════════════════════════════════════╝');
    console.log(`\n📍 URL Base: http://localhost:${PORT}`);
    console.log(`\n📄 Páginas disponíveis:`);
    console.log(`   • http://localhost:${PORT}/ (index.html)`);
    console.log(`   • http://localhost:${PORT}/checkout.html`);
    console.log(`   • http://localhost:${PORT}/access.html`);
    console.log(`   • http://localhost:${PORT}/thankyou.html`);
    console.log(`\n💡 COMO ABRIR NO CURSOR:`);
    console.log('   1. Pressione Ctrl+Click na URL acima');
    console.log('   2. Ou use: Ctrl+Shift+P → "Simple Browser: Show"');
    console.log('   3. Ou: View → Open View... → Simple Browser');
    console.log('\n🛑 Para parar: Ctrl+C\n');
});
