import React from 'react'

export interface CardProps {
  children: React.ReactNode
  className?: string
  title?: string
  footer?: React.ReactNode
}

export const Card: React.FC<CardProps> = ({
  children,
  className = '',
  title,
  footer
}) => {
  return (
    <div className={`bg-white rounded-lg shadow-md p-6 ${className}`}>
      {title && (
        <h3 className="text-lg font-semibold text-gray-900 mb-4">{title}</h3>
      )}
      <div className="text-gray-700">
        {children}
      </div>
      {footer && (
        <div className="mt-4 pt-4 border-t border-gray-200">
          {footer}
        </div>
      )}
    </div>
  )
}

export default Card
