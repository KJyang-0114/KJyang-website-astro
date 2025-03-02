import { defineConfig } from 'astro/config';

export default defineConfig({
  site: 'https://kjyang-portfolio.vercel.app',
  base: '/',
  trailingSlash: 'ignore', // 修改為 'ignore' 以避免重定向提示
  compressHTML: true,
  build: {
    assets: '_assets'
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
    // 添加以下配置以允許 kjyang0114.site 主機
    preview: {
      host: true, // 監聽所有可用網絡接口
      port: 3000,
      allowedHosts: ['kjyang0114.site']
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
