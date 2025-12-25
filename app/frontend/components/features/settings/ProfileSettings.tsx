import React, { useState, useEffect, useRef } from 'react'
import { useRailsFetch } from '../../../hooks/useRailsFetch'
import { Card, Button, Modal } from '../../../components/common'
import type { User } from '../../../types/models'

export const ProfileSettings: React.FC = () => {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [success, setSuccess] = useState<string | null>(null)
  const [showAvatarModal, setShowAvatarModal] = useState(false)
  const { get, put } = useRailsFetch()
  const fileInputRef = useRef<HTMLInputElement>(null)

  const [formData, setFormData] = useState({
    name: '',
    email: '',
  })

  useEffect(() => {
    fetchProfile()
  }, [])

  const fetchProfile = async () => {
    try {
      setLoading(true)
      const response = await get('/settings/profile')
      const data = await response.json()
      setUser(data.user)
      setFormData({
        name: data.user.name || '',
        email: data.user.email || '',
      })
    } catch (err) {
      setError('Failed to load profile')
    } finally {
      setLoading(false)
    }
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    try {
      setSaving(true)
      setError(null)
      setSuccess(null)

      const response = await put('/settings/profile', { user: formData })
      const data = await response.json()
      setUser(data.user)
      setSuccess('Profile updated successfully')
    } catch (err) {
      setError('Failed to update profile')
    } finally {
      setSaving(false)
    }
  }

  const handleAvatarUpload = async (file: File) => {
    try {
      setSaving(true)
      const formData = new FormData()
      formData.append('user[avatar]', file)

      const response = await fetch('/settings/profile', {
        method: 'PUT',
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '',
        },
        body: formData,
        credentials: 'same-origin',
      })

      const data = await response.json()
      setUser(data.user)
      setSuccess('Avatar updated successfully')
      setShowAvatarModal(false)
    } catch (err) {
      setError('Failed to upload avatar')
    } finally {
      setSaving(false)
    }
  }

  if (loading) {
    return (
      <div className="flex justify-center py-8">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
      </div>
    )
  }

  return (
    <div>
      <h2 className="text-2xl font-bold text-gray-900 mb-6">Profile Settings</h2>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-md mb-4">
          {error}
        </div>
      )}

      {success && (
        <div className="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-md mb-4">
          {success}
        </div>
      )}

      {/* Avatar Section */}
      <Card title="Avatar" className="mb-6">
        <div className="flex items-center space-x-6">
          <div className="shrink-0">
            {user?.avatar ? (
              <img
                className="h-24 w-24 rounded-full object-cover"
                src={user.avatar}
                alt="User avatar"
              />
            ) : (
              <div className="h-24 w-24 rounded-full bg-blue-100 flex items-center justify-center">
                <span className="text-3xl font-bold text-blue-600">
                  {user?.name?.charAt(0).toUpperCase() || user?.email?.charAt(0).toUpperCase()}
                </span>
              </div>
            )}
          </div>
          <div>
            <Button onClick={() => setShowAvatarModal(true)}>Change Avatar</Button>
            <p className="text-sm text-gray-500 mt-2">
              JPG, GIF or PNG. Max size of 2MB.
            </p>
          </div>
        </div>
      </Card>

      {/* Profile Information */}
      <Card title="Profile Information">
        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label htmlFor="name" className="block text-sm font-medium text-gray-700">
              Name
            </label>
            <input
              type="text"
              id="name"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
            />
          </div>

          <div>
            <label htmlFor="email" className="block text-sm font-medium text-gray-700">
              Email
            </label>
            <input
              type="email"
              id="email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              className="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm"
            />
            <p className="mt-2 text-sm text-gray-500">
              Changing your email will send a confirmation email to the new address.
            </p>
          </div>

          <div className="flex justify-end">
            <Button type="submit" disabled={saving}>
              {saving ? 'Saving...' : 'Save Changes'}
            </Button>
          </div>
        </form>
      </Card>

      {/* Avatar Upload Modal */}
      <Modal
        isOpen={showAvatarModal}
        onClose={() => setShowAvatarModal(false)}
        title="Upload Avatar"
      >
        <div className="space-y-4">
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            className="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:text-sm file:font-semibold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
            onChange={(e) => {
              const file = e.target.files?.[0]
              if (file) {
                handleAvatarUpload(file)
              }
            }}
          />
          <div className="flex justify-end space-x-3">
            <Button
              variant="secondary"
              onClick={() => setShowAvatarModal(false)}
            >
              Cancel
            </Button>
          </div>
        </div>
      </Modal>
    </div>
  )
}

export default ProfileSettings
