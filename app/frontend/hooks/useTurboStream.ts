import { useEffect, useRef } from 'react'

interface TurboStreamCallbacks {
  received?: (data: any) => void
  connected?: () => void
  disconnected?: () => void
  rejected?: () => void
}

/**
 * Custom hook for subscribing to Turbo Streams
 * Note: This works with Action Cable backend which Turbo Streams uses
 */
export const useTurboStream = (channel: string, callbacks: TurboStreamCallbacks) => {
  const subscription = useRef<any>(null)

  useEffect(() => {
    // Check if Turbo and consumer are available
    if (typeof window === 'undefined') return

    // @ts-ignore - Turbo may not have complete TypeScript definitions
    const turbo = window.Turbo || window.Turbo
    if (!turbo) {
      console.warn('Turbo not available for stream subscription')
      return
    }

    // Turbo Streams work through Action Cable subscriptions
    // This is a simplified hook that listens for turbo:before-stream-render events
    const handleStreamRender = (event: any) => {
      const { target, detail } = event
      if (callbacks.received && detail?.newStream) {
        callbacks.received(detail.newStream)
      }
    }

    document.addEventListener('turbo:before-stream-render', handleStreamRender)
    document.addEventListener('turbo:submit-start', handleStreamRender)

    return () => {
      document.removeEventListener('turbo:before-stream-render', handleStreamRender)
      document.removeEventListener('turbo:submit-start', handleStreamRender)

      // Unsubscribe from Action Cable if subscription exists
      if (subscription.current) {
        // @ts-ignore
        if (typeof subscription.current.unsubscribe === 'function') {
          subscription.current.unsubscribe()
        }
      }
    }
  }, [channel, callbacks])

  return subscription
}

/**
 * Hook for Turbo Stream source subscriptions
 * This connects to a Turbo Stream source and receives updates
 */
export const useTurboStreamSource = (channel: string, onMessage: (data: any) => void) => {
  useEffect(() => {
    // Create a new EventSource for server-sent events
    // This is commonly used with Turbo Streams
    const eventSource = new EventSource(channel)

    eventSource.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data)
        onMessage(data)
      } catch (e) {
        console.error('Failed to parse stream data:', e)
      }
    }

    eventSource.onerror = (error) => {
      console.error('Turbo Stream error:', error)
      eventSource.close()
    }

    return () => {
      eventSource.close()
    }
  }, [channel, onMessage])
}
