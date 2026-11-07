// Starts the Chrome DevTools MCP server (see .mcp.json).
// On your own computer it runs exactly as before. In Claude Code cloud sessions
// there is no screen and no Google Chrome, and Chrome refuses its sandbox when
// run as root, so there it uses the preinstalled Chromium, headless, without
// the sandbox.
import { spawn } from 'node:child_process';
import { existsSync } from 'node:fs';

const chromium = '/opt/pw-browsers/chromium';
const args = ['chrome-devtools-mcp@latest', '--no-usage-statistics', '--no-performance-crux'];
if (process.env.CLAUDE_CODE_REMOTE === 'true' && existsSync(chromium)) {
  args.push('--headless', '--isolated', `--executablePath=${chromium}`,
    '--chromeArg=--no-sandbox', '--chromeArg=--disable-setuid-sandbox');
}
const child = spawn('npx', args, { stdio: 'inherit', shell: process.platform === 'win32' });
child.on('exit', (code) => process.exit(code ?? 1));
for (const signal of ['SIGINT', 'SIGTERM']) process.on(signal, () => child.kill(signal));
