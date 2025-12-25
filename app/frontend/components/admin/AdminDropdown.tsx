import * as React from 'react'
import * as DropdownMenu from '@radix-ui/react-dropdown-menu'

interface AdminDropdownProps {
  trigger: React.ReactNode
  children: React.ReactNode
  align?: 'start' | 'center' | 'end'
}

export const AdminDropdown: React.FC<AdminDropdownProps> = ({
  trigger,
  children,
  align = 'end'
}) => {
  return (
    <DropdownMenu.Root>
      <DropdownMenu.Trigger asChild>
        {trigger}
      </DropdownMenu.Trigger>
      <DropdownMenu.Portal>
        <DropdownMenu.Content
          align={align}
          className="z-50 min-w-[8rem] overflow-hidden rounded-md border border-gray-200 bg-white p-1 shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2"
        >
          {children}
        </DropdownMenu.Content>
      </DropdownMenu.Portal>
    </DropdownMenu.Root>
  )
}

interface AdminDropdownItemProps {
  children: React.ReactNode
  onClick?: () => void
  variant?: 'default' | 'danger'
  disabled?: boolean
}

export const AdminDropdownItem: React.FC<AdminDropdownItemProps> = ({
  children,
  onClick,
  variant = 'default',
  disabled = false
}) => {
  const baseClasses = "relative flex cursor-pointer select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-gray-100 focus:text-gray-900 data-[disabled]:pointer-events-none data-[disabled]:opacity-50"

  const variantClasses = variant === 'danger'
    ? "text-red-600 focus:text-red-600 focus:bg-red-50"
    : "text-gray-700"

  return (
    <DropdownMenu.Item
      className={`${baseClasses} ${variantClasses}`}
      onClick={onClick}
      disabled={disabled}
    >
      {children}
    </DropdownMenu.Item>
  )
}

interface AdminDropdownSeparatorProps {
  className?: string
}

export const AdminDropdownSeparator: React.FC<AdminDropdownSeparatorProps> = ({ className = '' }) => {
  return (
    <DropdownMenu.Separator className={`h-px bg-gray-200 my-1 ${className}`} />
  )
}
