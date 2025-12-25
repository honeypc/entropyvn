import * as React from 'react'
import * as Select from '@radix-ui/react-select'

interface AdminSelectProps {
  value?: string
  onValueChange: (value: string) => void
  placeholder?: string
  children: React.ReactNode
  disabled?: boolean
}

export const AdminSelect: React.FC<AdminSelectProps> = ({
  value,
  onValueChange,
  placeholder = 'Select...',
  children,
  disabled = false
}) => {
  return (
    <Select.Root value={value} onValueChange={onValueChange} disabled={disabled}>
      <Select.Trigger className="admin-select-trigger">
        <Select.Value placeholder={placeholder} />
        <Select.Icon className="admin-select-icon">
          <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
            <path d="M2.5 4.5L6 8L9.5 4.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        </Select.Icon>
      </Select.Trigger>
      <Select.Portal>
        <Select.Content className="admin-select-content">
          <Select.ScrollUpButton className="admin-select-scroll-button">
            <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
              <path d="M6 8V4M6 4L3.5 6.5M6 4L8.5 6.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          </Select.ScrollUpButton>
          <Select.Viewport className="admin-select-viewport">
            {children}
          </Select.Viewport>
          <Select.ScrollDownButton className="admin-select-scroll-button">
            <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
              <path d="M6 4V8M6 8L3.5 5.5M6 8L8.5 5.5" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          </Select.ScrollDownButton>
        </Select.Content>
      </Select.Portal>
    </Select.Root>
  )
}

interface AdminSelectItemProps {
  value: string
  children: React.ReactNode
  disabled?: boolean
}

export const AdminSelectItem: React.FC<AdminSelectItemProps> = ({ value, children, disabled = false }) => {
  return (
    <Select.Item value={value} disabled={disabled} className="admin-select-item">
      <Select.ItemText>{children}</Select.ItemText>
      <Select.ItemIndicator className="admin-select-item-indicator">
        <svg width="12" height="12" viewBox="0 0 12 12" fill="none">
          <path d="M2.5 6L4.5 8L9.5 3" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
        </svg>
      </Select.ItemIndicator>
    </Select.Item>
  )
}

interface AdminSelectLabelProps {
  children: React.ReactNode
  htmlFor?: string
  className?: string
}

export const AdminSelectLabel: React.FC<AdminSelectLabelProps> = ({ children, className = '' }) => {
  return (
    <Select.Label className={`admin-select-label ${className}`}>
      {children}
    </Select.Label>
  )
}

interface AdminSelectSeparatorProps {
  className?: string
}

export const AdminSelectSeparator: React.FC<AdminSelectSeparatorProps> = ({ className = '' }) => {
  return (
    <Select.Separator className={`admin-select-separator ${className}`} />
  )
}
