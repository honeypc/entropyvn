import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],

  // Vite entry point for React
  root: process.cwd(),

  // Build configuration
  build: {
    outDir: 'public/vite-build',
    emptyOutDir: true,
    manifest: true,
    rollupOptions: {
      input: {
        application: 'app/frontend/entrypoints/application.ts',
        admin: 'app/frontend/entrypoints/admin.ts',
      },
      output: {
        entryFileNames: 'assets/[name].[hash].js',
        chunkFileNames: 'assets/[name].[hash].js',
        assetFileNames: 'assets/[name].[hash].[ext]'
      }
    }
  },

  // Development server configuration
  server: {
    // Proxy Rails backend in development
    proxy: {
      '/rails': {
        target: 'http://localhost:3000',
        changeOrigin: true,
        ws: true
      }
    },
    // Vite dev server port
    port: 3036,
    strictPort: true,
    host: true
  },

  // Resolve configuration
  resolve: {
    alias: {
      '@': '/app/frontend',
      '@components': '/app/frontend/components',
      '@hooks': '/app/frontend/hooks',
      '@utils': '/app/frontend/utils',
      '@types': '/app/frontend/types'
    }
  },

  // CSS configuration - PostCSS is configured via postcss.config.js
  // Vite automatically uses postcss.config.js

  // Optimize dependencies
  optimizeDeps: {
    include: ['react', 'react-dom', '@hotwired/turbo-rails', '@hotwired/stimulus']
  }
})
