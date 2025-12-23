// Main React application entry point
import React from 'react'
import ReactDOM from 'react-dom/client'
import './application.css'

// Import Hotwire for hybrid approach
import '@hotwired/turbo-rails'

// Type declarations for React components
interface ReactComponentType extends React.FC<any> {
  // Any additional properties can be added here
}

// Store mounted roots to unmount on Turbo navigation
const mountedRoots = new Map<Element, ReactDOM.Root>()

// Unmount all React components before Turbo navigation
const unmountReactComponents = () => {
  mountedRoots.forEach((root) => {
    try {
      root.unmount()
    } catch (e) {
      // Ignore errors during unmount
    }
  })
  mountedRoots.clear()
}

// Mount React components on specific mounting points
const initializeReactComponents = () => {
  // Find all elements with data-react-component attribute
  const reactElements = document.querySelectorAll('[data-react-component]')

  reactElements.forEach((element) => {
    const componentName = element.getAttribute('data-react-component')
    const propsData = element.getAttribute('data-props')

    if (!componentName) return

    // Parse props from JSON
    let props = {}
    if (propsData) {
      try {
        props = JSON.parse(propsData)
      } catch (e) {
        console.error(`Failed to parse props for ${componentName}:`, e)
      }
    }

    // Dynamically import and mount the React component
    import(`../components/features/${componentName}/${componentName}`)
      .then((module) => {
        const Component: ReactComponentType = module.default || module[componentName]

        if (Component) {
          // Unmount existing root if any
          if (mountedRoots.has(element)) {
            mountedRoots.get(element)?.unmount()
          }

          // Create new root and mount component
          const root = ReactDOM.createRoot(element)
          root.render(React.createElement(Component, props))
          mountedRoots.set(element, root)
        }
      })
      .catch((error) => {
        console.error(`Failed to load React component: ${componentName}`, error)
      })
  })
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initializeReactComponents)
} else {
  initializeReactComponents()
}

// Re-initialize on Turbo navigation (for hybrid approach)
// Unmount before navigation, then mount after render
document.addEventListener('turbo:before-visit', unmountReactComponents)
document.addEventListener('turbo:render', initializeReactComponents)

// Re-initialize on Turbo Stream updates
document.addEventListener('turbo:before-stream-render', unmountReactComponents)
document.addEventListener('turbo:after-stream-render', initializeReactComponents)
