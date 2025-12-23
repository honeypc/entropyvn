// API response type definitions

/**
 * Standard API response wrapper
 */
export interface ApiResponse<T> {
  data: T
  meta?: {
    current_page: number
    total_pages: number
    total_count: number
  }
}

/**
 * API error response
 */
export interface ApiError {
  error: string
  message: string
  details?: Record<string, string[]>
}

/**
 * Paginated response
 */
export interface PaginatedResponse<T> {
  data: T[]
  meta: {
    current_page: number
    next_page: number | null
    prev_page: number | null
    total_pages: number
    total_count: number
  }
}

/**
 * Success response
 */
export interface SuccessResponse {
  success: boolean
  message?: string
}

/**
 * Validation error response
 */
export interface ValidationErrorResponse {
  success: false
  errors: Record<string, string[]>
}
