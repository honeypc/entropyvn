import React from 'react'
import { Link, useLocation } from 'react-router-dom'

interface SettingsLayoutProps {
  children: React.ReactNode
}

interface NavItem {
  name: string
  href: string
  icon: string
}

const navItems: NavItem[] = [
  { name: 'Profile', href: '/settings/profile', icon: 'user' },
  { name: 'Account', href: '/settings/account', icon: 'lock' },
  { name: 'API Tokens', href: '/settings/api_tokens', icon: 'key' },
]

const icons: Record<string, string> = {
  user: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />',
  lock: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />',
  key: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11.536 19H10a2 2 0 01-2-2v-2.172a2 2 0 00-.586-1.414L5.172 12.586A2 2 0 014.758 11H6a2 2 0 002-2V7a2 2 0 012-2h12a2 2 0 012 2zm0 0V6a2 2 0 00-2-2H8a2 2 0 00-2 2v1" />',
}

export const SettingsLayout: React.FC<SettingsLayoutProps> = ({ children }) => {
  const location = useLocation()

  return (
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="md:flex md:gap-8">
          {/* Sidebar */}
          <aside className="md:w-64 mb-8 md:mb-0">
            <div className="bg-white rounded-lg shadow p-4">
              <h1 className="text-xl font-bold text-gray-900 mb-4">Settings</h1>
              <nav className="space-y-1">
                {navItems.map((item) => {
                  const isActive = location.pathname === item.href
                  return (
                    <Link
                      key={item.name}
                      to={item.href}
                      className={`${
                        isActive
                          ? 'bg-blue-50 text-blue-700'
                          : 'text-gray-700 hover:bg-gray-50'
                      } group flex items-center px-3 py-2 text-sm font-medium rounded-md`}
                    >
                      <svg
                        className="mr-3 h-5 w-5"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                        dangerouslySetInnerHTML={{ __html: icons[item.icon] || icons.user }}
                      />
                      {item.name}
                    </Link>
                  )
                })}
              </nav>
            </div>
          </aside>

          {/* Main content */}
          <main className="flex-1">
            <div className="bg-white rounded-lg shadow p-6">{children}</div>
          </main>
        </div>
      </div>
    </div>
  )
}

export default SettingsLayout
