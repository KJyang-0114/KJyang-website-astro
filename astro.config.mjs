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
    }
  }
});
