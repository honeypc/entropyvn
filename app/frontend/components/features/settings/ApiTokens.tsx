import React, { useState, useEffect } from 'react'
import { Card, Button, Modal } from '../../../components/common'
import { useRailsFetch } from '../../../hooks/useRailsFetch'

export const ApiTokens: React.FC = () => {
  const [hasToken, setHasToken] = useState(false)
  const [maskedToken, setMaskedToken] = useState<string | null>(null)
  const [newToken, setNewToken] = useState<string | null>(null)
  const [showGenerateModal, setShowGenerateModal] = useState(false)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [copied, setCopied] = useState(false)
  const { get, post, del } = useRailsFetch()

  useEffect(() => {
    fetchTokenStatus()
  }, [])

  const fetchTokenStatus = async () => {
    try {
      const response = await get('/settings/api_tokens')
      const data = await response.json()
      setHasToken(data.has_token)
      setMaskedToken(data.api_token)
    } catch (err) {
      setError('Failed to load token status')
    }
  }

  const handleGenerateToken = async () => {
    try {
      setLoading(true)
      setError(null)

      const response = await post('/settings/api_tokens', {})
      const data = await response.json()
      setNewToken(data.api_token)
      setHasToken(true)
      setShowGenerateModal(false)
    } catch (err) {
      setError('Failed to generate token')
    } finally {
      setLoading(false)
    }
  }

  const handleDeleteToken = async () => {
    try {
      setLoading(true)
      setError(null)

      await del('/settings/api_tokens')
      setHasToken(false)
      setMaskedToken(null)
      setNewToken(null)
    } catch (err) {
      setError('Failed to delete token')
    } finally {
      setLoading(false)
    }
  }

  const copyToClipboard = () => {
    if (newToken) {
      navigator.clipboard.writeText(newToken)
      setCopied(true)
      setTimeout(() => setCopied(false), 2000)
    }
  }

  return (
    <div>
      <h2 className="text-2xl font-bold text-gray-900 mb-6">API Tokens</h2>

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-md mb-4">
          {error}
        </div>
      )}

      {/* Current Token Status */}
      <Card title="Your API Token" className="mb-6">
        {hasToken ? (
          <div className="space-y-4">
            <div className="p-4 bg-gray-50 rounded-md">
              <code className="text-lg">{maskedToken}</code>
            </div>
            <p className="text-sm text-gray-600">
              Keep your token secret. Anyone with your token can access your account.
            </p>
            <div className="flex space-x-3">
              <Button onClick={() => setShowGenerateModal(true)}>
                Regenerate Token
              </Button>
              <Button
                variant="danger"
                onClick={handleDeleteToken}
                disabled={loading}
              >
                {loading ? 'Deleting...' : 'Delete Token'}
              </Button>
            </div>
          </div>
        ) : (
          <div className="text-center py-6">
            <svg
              className="mx-auto h-12 w-12 text-gray-400"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11.536 19H10a2 2 0 01-2-2v-2.172a2 2 0 00-.586-1.414L5.172 12.586A2 2 0 014.758 11H6a2 2 0 002-2V7a2 2 0 012-2h12a2 2 0 012 2zm0 0V6a2 2 0 00-2-2H8a2 2 0 00-2 2v1"
              />
            </svg>
            <h3 className="mt-2 text-sm font-medium text-gray-900">No API token</h3>
            <p className="mt-1 text-sm text-gray-500">
              Get started by generating a new API token.
            </p>
            <div className="mt-6">
              <Button onClick={() => setShowGenerateModal(true)}>
                Generate Token
              </Button>
            </div>
          </div>
        )}
      </Card>

      {/* How to Use */}
      <Card title="How to Use Your API Token">
        <div className="space-y-4">
          <div>
            <h4 className="font-medium text-gray-900">Authentication Header</h4>
            <div className="mt-2 p-3 bg-gray-900 rounded-md">
              <code className="text-green-400 text-sm">
                Authorization: Bearer YOUR_API_TOKEN
              </code>
            </div>
          </div>

          <div>
            <h4 className="font-medium text-gray-900">Example cURL Request</h4>
            <div className="mt-2 p-3 bg-gray-900 rounded-md overflow-x-auto">
              <code className="text-green-400 text-sm">
                curl -H "Authorization: Bearer YOUR_API_TOKEN" \<br />
                &nbsp;&nbsp;http://localhost:3000/api/v1/dashboard
              </code>
            </div>
          </div>

          <div className="bg-yellow-50 border border-yellow-200 rounded-md p-4">
            <div className="flex">
              <svg
                className="h-5 w-5 text-yellow-400"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  fillRule="evenodd"
                  d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
                  clipRule="evenodd"
                />
              </svg>
              <div className="ml-3">
                <h3 className="text-sm font-medium text-yellow-800">
                  Important
                </h3>
                <div className="mt-2 text-sm text-yellow-700">
                  <p>
                    Store your API token securely. Never share it with others or expose it in client-side code.
                    If you lose your token, you'll need to generate a new one.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </Card>

      {/* Generate Token Modal */}
      <Modal
        isOpen={showGenerateModal}
        onClose={() => setShowGenerateModal(false)}
        title="Generate New API Token"
      >
        <div className="space-y-4">
          <p className="text-gray-700">
            Generating a new token will invalidate your existing token. Are you sure?
          </p>
          <div className="flex justify-end space-x-3">
            <Button
              variant="secondary"
              onClick={() => setShowGenerateModal(false)}
              disabled={loading}
            >
              Cancel
            </Button>
            <Button
              onClick={handleGenerateToken}
              disabled={loading}
            >
              {loading ? 'Generating...' : 'Generate'}
            </Button>
          </div>
        </div>
      </Modal>

      {/* New Token Modal */}
      <Modal
        isOpen={newToken !== null}
        onClose={() => setNewToken(null)}
        title="Your New API Token"
      >
        <div className="space-y-4">
          <div className="p-4 bg-yellow-50 border border-yellow-200 rounded-md">
            <div className="flex">
              <svg
                className="h-5 w-5 text-yellow-400 shrink-0"
                fill="currentColor"
                viewBox="0 0 20 20"
              >
                <path
                  fillRule="evenodd"
                  d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z"
                  clipRule="evenodd"
                />
              </svg>
              <div className="ml-3">
                <h3 className="text-sm font-medium text-yellow-800">
                  Save your token now!
                </h3>
                <div className="mt-2 text-sm text-yellow-700">
                  <p>
                    You won't be able to see this token again. Make sure to copy it and store it securely.
                  </p>
                </div>
              </div>
            </div>
          </div>

          <div className="p-4 bg-gray-900 rounded-md">
            <code className="text-green-400 text-sm break-all">{newToken}</code>
          </div>

          <Button
            onClick={copyToClipboard}
            className="w-full"
            variant={copied ? "success" : "primary"}
          >
            {copied ? 'Copied!' : 'Copy to Clipboard'}
          </Button>

          <Button
            variant="secondary"
            onClick={() => setNewToken(null)}
            className="w-full"
          >
            I've saved my token
          </Button>
        </div>
      </Modal>
    </div>
  )
}

export default ApiTokens
