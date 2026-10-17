// Serves build/web like Firebase Hosting: gzip for text and wasm files, and
// index.html for app routes so deep links and refreshes work.
//
// Usage: node tools/web/serve.mjs [dir=build/web] [port=8090]
import fs from 'node:fs';
import http from 'node:http';
import path from 'node:path';
import zlib from 'node:zlib';

const root = path.resolve(process.argv[2] ?? 'build/web');
const port = Number(process.argv[3] ?? 8090);
const types = {
  '.html': 'text/html; charset=utf-8', '.js': 'text/javascript', '.mjs': 'text/javascript', '.json': 'application/json',
  '.wasm': 'application/wasm', '.css': 'text/css', '.png': 'image/png', '.jpg': 'image/jpeg', '.webp': 'image/webp',
  '.svg': 'image/svg+xml', '.ttf': 'font/ttf', '.otf': 'font/otf', '.ico': 'image/x-icon', '.bin': 'application/octet-stream',
};
const compressible = new Set(['.html', '.js', '.mjs', '.json', '.wasm', '.css', '.svg', '.ttf', '.otf', '.bin']);
const gzipped = new Map();

http.createServer((req, res) => {
  const requested = path.normalize(decodeURIComponent(new URL(req.url, 'http://local').pathname));
  let file = path.join(root, requested);
  if (!file.startsWith(root) || !fs.existsSync(file) || fs.statSync(file).isDirectory()) file = path.join(root, 'index.html');
  const ext = path.extname(file);
  const headers = { 'Content-Type': types[ext] ?? 'application/octet-stream', 'Cache-Control': 'no-cache' };
  let body = fs.readFileSync(file);
  if (compressible.has(ext) && /\bgzip\b/.test(req.headers['accept-encoding'] ?? '')) {
    if (!gzipped.has(file)) gzipped.set(file, zlib.gzipSync(body, { level: 9 }));
    body = gzipped.get(file);
    headers['Content-Encoding'] = 'gzip';
  }
  headers['Content-Length'] = body.length;
  res.writeHead(200, headers);
  res.end(body);
}).listen(port, '127.0.0.1', () => console.log(`Serving ${root} at http://127.0.0.1:${port}`));
