import { defineConfig } from 'vite';

export default defineConfig({
  server: {
    host: true,
    port: 3000,
    strictPort: true,
    cors: true
  },
  preview: {
    host: true,
    port: 3000,
    strictPort: true,
    cors: true,
    allowedHosts: ['kjyang0114.site', 'localhost', '127.0.0.1']
  },
  // 禁用緩存以確保內容總是最新的
  optimizeDeps: {
    force: true
  },
  // 永遠清除緩存
  cacheDir: '.vite-cache',
  clearScreen: false
});
