// Admin entrypoint with Radix UI components
// Note: Radix UI v1+ uses Tailwind CSS classes directly - no separate CSS imports needed
import './admin.css'

// Export admin components for use in views
export * from '../components/admin'

// Initialize admin-specific functionality
document.addEventListener('DOMContentLoaded', () => {
  // Admin confirm dialogs
  window.AdminConfirmDialog = {
    show: (options: {
      title: string
      description: string
      onConfirm: () => void
      confirmLabel?: string
      cancelLabel?: string
      variant?: 'danger' | 'default'
    }) => {
      // Create a simple confirmation dialog
      const confirmed = confirm(`${options.title}\n\n${options.description}`)
      if (confirmed) {
        options.onConfirm()
      }
    }
  }

  // Admin toast notifications
  window.AdminToast = {
    show: (message: string, type: 'success' | 'error' | 'info' = 'info') => {
      const toast = document.createElement('div')
      toast.className = `admin-toast admin-toast--${type}`
      toast.textContent = message
      document.body.appendChild(toast)

      setTimeout(() => {
        toast.classList.add('admin-toast--visible')
      }, 10)

      setTimeout(() => {
        toast.classList.remove('admin-toast--visible')
        setTimeout(() => toast.remove(), 300)
      }, 3000)
    }
  }
})

// TypeScript declarations for global window object
declare global {
  interface Window {
    AdminConfirmDialog: {
      show: (options: {
        title: string
        description: string
        onConfirm: () => void
        confirmLabel?: string
        cancelLabel?: string
        variant?: 'danger' | 'default'
      }) => void
    }
    AdminToast: {
      show: (message: string, type?: 'success' | 'error' | 'info') => void
    }
  }
}
