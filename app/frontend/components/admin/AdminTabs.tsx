import * as React from 'react'
import * as Tabs from '@radix-ui/react-tabs'

interface AdminTabsProps {
  defaultValue: string
  children: React.ReactNode
  className?: string
}

export const AdminTabs: React.FC<AdminTabsProps> = ({ defaultValue, children, className = '' }) => {
  return (
    <Tabs.Root defaultValue={defaultValue} className={`admin-tabs ${className}`}>
      {children}
    </Tabs.Root>
  )
}

interface AdminTabsListProps {
  children: React.ReactNode
  className?: string
}

export const AdminTabsList: React.FC<AdminTabsListProps> = ({ children, className = '' }) => {
  return (
    <Tabs.List className="admin-tabs-list">
      {children}
    </Tabs.List>
  )
}

interface AdminTabsTriggerProps {
  value: string
  children: React.ReactNode
  className?: string
}

export const AdminTabsTrigger: React.FC<AdminTabsTriggerProps> = ({ value, children, className = '' }) => {
  return (
    <Tabs.Trigger
      value={value}
      className={`admin-tabs-trigger ${className}`}
    >
      {children}
    </Tabs.Trigger>
  )
}

interface AdminTabsContentProps {
  value: string
  children: React.ReactNode
  className?: string
}

export const AdminTabsContent: React.FC<AdminTabsContentProps> = ({ value, children, className = '' }) => {
  return (
    <Tabs.Content
      value={value}
      className={`admin-tabs-content ${className}`}
    >
      {children}
    </Tabs.Content>
  )
}
