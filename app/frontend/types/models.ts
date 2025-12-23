// Rails model type definitions

/**
 * User model
 */
export interface User {
  id: number
  email: string
  name: string
  avatar?: string
  api_token?: string
  created_at: string
  updated_at: string
}

/**
 * Project model
 */
export interface Project {
  id: number
  name: string
  description?: string
  user_id: number
  created_at: string
  updated_at: string
}

/**
 * Task model
 */
export interface Task {
  id: number
  title: string
  description?: string
  project_id: number
  completed: boolean
  due_date?: string
  created_at: string
  updated_at: string
}

/**
 * Dashboard stats model
 */
export interface DashboardStats {
  projects: number
  tasks: number
  completed: number
  pending: number
}

/**
 * Dashboard data model
 */
export interface DashboardData {
  user: User
  stats: DashboardStats
  recent_projects: Project[]
  recent_tasks: Task[]
}
