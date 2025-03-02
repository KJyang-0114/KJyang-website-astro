import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://kjyang-portfolio.vercel.app',
  base: '/',
  trailingSlash: 'ignore', // 修改為 'ignore' 以避免重定向提示
  compressHTML: true,
  build: {
    assets: '_assets'
  },
  server: {
    host: true, // 允許從網絡訪問
    port: 3000, // 指定端口為3000
    open: false, // 不自動打開瀏覽器
    allowedHosts: ['kjyang0114.site', 'localhost', '127.0.0.1'] // 允許這些主機訪問
  },
  preview: {
    host: true, // 允許從網絡訪問
    port: 3000, // 指定端口為3000
    open: false, // 不自動打開瀏覽器
    allowedHosts: ['kjyang0114.site', 'localhost', '127.0.0.1'] // 允許這些主機訪問
  },
  vite: {
    build: {
      cssCodeSplit: true
    },
    css: {
      devSourcemap: true
    },
    ssr: {
      noExternal: ['@fontsource/*']
    },
    preview: {
      host: true, // 監聽所有可用網絡接口
      port: 3000,
      allowedHosts: ['kjyang0114.site', 'localhost', '127.0.0.1']
    },
    server: {
      host: true, // 監聽所有可用網絡接口
      cors: true,
      // 確保開發服務器也允許該主機
      fs: {
        allow: ['..']
      }
    }
  }
});
