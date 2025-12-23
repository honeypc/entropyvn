// Global type definitions for Rails integration

declare global {
  interface Window {
    Rails?: {
      // @rails/ujs types
      csrfToken: () => string
      csrfParam: () => string
    }
    Turbo?: {
      // Turbo types
      visit: (url: string, options?: any) => void
      connect: (channel: string, options?: any) => any
    }
    Stimulus?: {
      // Stimulus types
      Application: any
    }
  }

  // Data attributes for React mounting
  interface HTMLElement {
    dataset: DOMStringMap & {
      controller?: string
      reactComponent?: string
      reactProps?: string
      props?: string
    }
  }

  // Extend Turbo types
  namespace Turbo {
    interface BeforeRenderEvent {
      preventDefault: () => void
    }
  }
}

export {}
