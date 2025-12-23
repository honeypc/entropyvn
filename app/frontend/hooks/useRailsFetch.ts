import { useCallback } from 'react'
import { getCsrfToken } from '../utils/csrf'

interface FetchOptions extends RequestInit {
  csrf?: boolean
}

/**
 * Custom hook for making Rails API calls with CSRF protection
 */
export const useRailsFetch = () => {
  const fetchWithCsrf = useCallback(async (url: string, options: FetchOptions = {}) => {
    const {
      csrf = true,
      headers = {},
      ...restOptions
    } = options

    const defaultHeaders: HeadersInit = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...headers,
    }

    // Add CSRF token if needed
    if (csrf) {
      const token = getCsrfToken()
      if (token) {
        defaultHeaders['X-CSRF-Token'] = token
      }
    }

    const response = await fetch(url, {
      ...restOptions,
      headers: defaultHeaders,
      credentials: 'same-origin',
    })

    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }

    return response
  }, [])

  /**
   * GET request helper
   */
  const get = useCallback((url: string, options?: FetchOptions) => {
    return fetchWithCsrf(url, { ...options, method: 'GET' })
  }, [fetchWithCsrf])

  /**
   * POST request helper
   */
  const post = useCallback((url: string, data?: any, options?: FetchOptions) => {
    return fetchWithCsrf(url, {
      ...options,
      method: 'POST',
      body: data ? JSON.stringify(data) : undefined,
    })
  }, [fetchWithCsrf])

  /**
   * PUT request helper
   */
  const put = useCallback((url: string, data?: any, options?: FetchOptions) => {
    return fetchWithCsrf(url, {
      ...options,
      method: 'PUT',
      body: data ? JSON.stringify(data) : undefined,
    })
  }, [fetchWithCsrf])

  /**
   * PATCH request helper
   */
  const patch = useCallback((url: string, data?: any, options?: FetchOptions) => {
    return fetchWithCsrf(url, {
      ...options,
      method: 'PATCH',
      body: data ? JSON.stringify(data) : undefined,
    })
  }, [fetchWithCsrf])

  /**
   * DELETE request helper
   */
  const del = useCallback((url: string, options?: FetchOptions) => {
    return fetchWithCsrf(url, { ...options, method: 'DELETE' })
  }, [fetchWithCsrf])

  return { fetchWithCsrf, get, post, put, patch, delete: del }
}
