import {fileURLToPath} from 'node:url';
import {defineConfig} from 'vite';

const frontendRoot = fileURLToPath(new URL('.', import.meta.url));

export default defineConfig({
  root: frontendRoot,
  base: './',
  define: {
    'process.env.NODE_ENV': JSON.stringify('production'),
  },
  esbuild: {
    jsx: 'automatic',
  },
  build: {
    outDir: 'build',
    emptyOutDir: true,
    lib: {
      entry: {
        login: fileURLToPath(new URL('./src/login.jsx', import.meta.url)),
        register: fileURLToPath(new URL('./src/register.jsx', import.meta.url)),
        superadminLogin: fileURLToPath(new URL('./src/superadmin-login.jsx', import.meta.url)),
      },
      name: 'AlbaStockLogin',
      formats: ['es'],
      fileName: (_format, entryName) => `${entryName}.js`,
      cssFileName: 'login',
    },
    rollupOptions: {
      output: {
        chunkFileNames: 'chunks/[name]-[hash].js',
        assetFileNames: 'assets/[name]-[hash][extname]',
      },
    },
  },
});
