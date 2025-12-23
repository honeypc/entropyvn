/**
 * CSRF token utilities for Rails integration
 */

/**
 * Get the CSRF token from the meta tag
 */
export const getCsrfToken = (): string | null => {
  const metaTag = document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement
  return metaTag?.content || null
}

/**
 * Get the CSRF parameter name from the meta tag
 */
export const getCsrfParam = (): string | null => {
  const metaTag = document.querySelector('meta[name="csrf-param"]') as HTMLMetaElement
  return metaTag?.content || null
}

/**
 * Get the CSRF token and param as an object
 */
export const getCsrfPair = (): { token: string | null; param: string | null } => {
  return {
    token: getCsrfToken(),
    param: getCsrfParam()
  }
}
