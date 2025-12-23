import React, { useEffect, useState } from 'react'
import { useRailsFetch } from '../../../hooks/useRailsFetch'
import { Card } from '../../../components/common'
import type { DashboardData } from '../../../types/models'

export interface DashboardProps {
  userId?: number
}

export const Dashboard: React.FC<DashboardProps> = ({ userId = 1 }) => {
  const [data, setData] = useState<DashboardData | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const { get } = useRailsFetch()

  useEffect(() => {
    const fetchDashboard = async () => {
      try {
        setLoading(true)
        setError(null)

        // Example API call - adjust endpoint as needed
        const response = await get(`/api/v1/dashboard?user_id=${userId}`)
        const jsonData = await response.json()
        setData(jsonData)
      } catch (err) {
        console.error('Failed to fetch dashboard:', err)
        setError('Failed to load dashboard data')
      } finally {
        setLoading(false)
      }
    }

    fetchDashboard()
  }, [userId, get])

  if (loading) {
    return (
      <div className="flex justify-center items-center p-8">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    )
  }

  if (error) {
    return (
      <Card className="bg-red-50 border border-red-200">
        <p className="text-red-600">{error}</p>
      </Card>
    )
  }

  return (
    <div className="space-y-6">
      {/* Welcome Message */}
      <div className="bg-white rounded-lg shadow-md p-6">
        <h1 className="text-2xl font-bold text-gray-900">
          Welcome back, {data?.user?.name || 'User'}!
        </h1>
        <p className="text-gray-600 mt-2">Here's what's happening with your projects today.</p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <DashboardWidget
          title="Projects"
          value={data?.stats?.projects || 0}
          icon="folder"
          color="blue"
        />
        <DashboardWidget
          title="Tasks"
          value={data?.stats?.tasks || 0}
          icon="list"
          color="green"
        />
        <DashboardWidget
          title="Completed"
          value={data?.stats?.completed || 0}
          icon="check"
          color="purple"
        />
      </div>

      {/* Recent Projects */}
      <Card title="Recent Projects">
        {data?.recent_projects && data.recent_projects.length > 0 ? (
          <ul className="space-y-3">
            {data.recent_projects.map((project) => (
              <li key={project.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div>
                  <h3 className="font-medium text-gray-900">{project.name}</h3>
                  {project.description && (
                    <p className="text-sm text-gray-600 mt-1">{project.description}</p>
                  )}
                </div>
                <span className="text-xs text-gray-500">
                  {new Date(project.created_at).toLocaleDateString()}
                </span>
              </li>
            ))}
          </ul>
        ) : (
          <p className="text-gray-500 text-center py-4">No recent projects</p>
        )}
      </Card>
    </div>
  )
}

interface DashboardWidgetProps {
  title: string
  value: number
  icon: string
  color: 'blue' | 'green' | 'purple' | 'orange' | 'red'
}

const DashboardWidget: React.FC<DashboardWidgetProps> = ({ title, value, icon, color }) => {
  const colorClasses = {
    blue: 'bg-blue-500',
    green: 'bg-green-500',
    purple: 'bg-purple-500',
    orange: 'bg-orange-500',
    red: 'bg-red-500'
  }

  const iconSvg: Record<string, string> = {
    folder: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />',
    list: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01" />',
    check: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />'
  }

  return (
    <Card className="hover:shadow-lg transition-shadow">
      <div className="flex items-center">
        <div className={`p-3 rounded-lg ${colorClasses[color]} text-white mr-4`}>
          <svg className="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" dangerouslySetInnerHTML={{ __html: iconSvg[icon] || iconSvg.folder }} />
        </div>
        <div>
          <p className="text-sm text-gray-600">{title}</p>
          <p className="text-2xl font-bold text-gray-900">{value}</p>
        </div>
      </div>
    </Card>
  )
}

export default Dashboard
