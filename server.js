const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 3002;
const FILE_PATH = path.join(__dirname, 'index.html');

const server = http.createServer((req, res) => {
    let filePath;
    let contentType = 'text/html';

    // Determinar o arquivo solicitado
    if (req.url === '/' || req.url === '/index.html') {
        filePath = FILE_PATH;
        contentType = 'text/html; charset=utf-8';
    } else if (req.url === '/checkout.html') {
        filePath = path.join(__dirname, 'checkout.html');
        contentType = 'text/html; charset=utf-8';
    } else if (req.url === '/thankyou.html') {
        filePath = path.join(__dirname, 'thankyou.html');
        contentType = 'text/html; charset=utf-8';
    } else if (req.url === '/access.html') {
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
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('404 - Página não encontrada');
        return;
    }

    // Ler e servir o arquivo
    // Para HTML, ler como UTF-8; para imagens, ler como binário
    const encoding = contentType.startsWith('text/html') ? 'utf8' : null;
    
    fs.readFile(filePath, encoding, (err, data) => {
        if (err) {
            if (err.code === 'ENOENT') {
                res.writeHead(404, { 'Content-Type': 'text/plain' });
                res.end('404 - Arquivo não encontrado');
            } else {
                res.writeHead(500, { 'Content-Type': 'text/plain' });
                res.end('Erro ao ler o arquivo: ' + err.message);
            }
            return;
        }

        res.writeHead(200, {
            'Content-Type': contentType,
            'Cache-Control': 'no-cache'
        });
        res.end(data);
    });
});

server.listen(PORT, () => {
    console.log('\n╔══════════════════════════════════════════════════════════╗');
    console.log('║  🚀 Servidor da Landing Page rodando!                    ║');
    console.log('╚══════════════════════════════════════════════════════════╝');
    console.log(`\n📍 URL: http://localhost:${PORT}`);
    console.log(`📄 Arquivo: ${FILE_PATH}\n`);
    console.log('💡 COMO ABRIR NO CURSOR:');
    console.log('   1. Pressione Ctrl+Click (ou Cmd+Click no Mac) na URL acima');
    console.log('   2. Ou copie a URL e use: Ctrl+Shift+P → "Simple Browser: Show"');
    console.log('   3. Ou abra: View → Open View... → Simple Browser\n');
    console.log('🛑 Para parar o servidor, pressione Ctrl+C\n');
});
