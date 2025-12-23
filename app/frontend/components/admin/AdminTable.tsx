import * as React from 'react'

interface AdminTableProps {
  headers: string[]
  children: React.ReactNode
  className?: string
}

export const AdminTable: React.FC<AdminTableProps> = ({ headers, children, className = '' }) => {
  return (
    <div className={`overflow-x-auto rounded-lg border border-gray-200 ${className}`}>
      <table className="min-w-full divide-y divide-gray-200 bg-white">
        <thead className="bg-gray-50">
          <tr>
            {headers.map((header, index) => (
              <th
                key={index}
                className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                {header}
              </th>
            ))}
          </tr>
        </thead>
        <tbody className="divide-y divide-gray-200">
          {children}
        </tbody>
      </table>
    </div>
  )
}

interface AdminTableRowProps {
  children: React.ReactNode
  onClick?: () => void
  className?: string
}

export const AdminTableRow: React.FC<AdminTableRowProps> = ({ children, onClick, className = '' }) => {
  return (
    <tr
      className={onClick ? 'hover:bg-gray-50 cursor-pointer' : ''}
      onClick={onClick}
    >
      {children}
    </tr>
  )
}

interface AdminTableCellProps {
  children: React.ReactNode
  className?: string
}

export const AdminTableCell: React.FC<AdminTableCellProps> = ({ children, className = '' }) => {
  return (
    <td className={`px-6 py-4 whitespace-nowrap text-sm text-gray-900 ${className}`}>
      {children}
    </td>
  )
}
