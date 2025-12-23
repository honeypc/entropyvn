// Stimulus controller to bridge React and Turbo
// This controller allows React components to work seamlessly with Turbo navigation

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    component: String,
    props: Object
  }

  connect() {
    this.renderReactComponent()
  }

  disconnect() {
    // Unmount React component when controller is disconnected
    if (this.root) {
      this.root.unmount()
    }
  }

  async renderReactComponent() {
    const componentName = this.componentValue

    try {
      // Dynamically import the React component
      // Components should be in app/frontend/components/features/{ComponentName}/{ComponentName}.tsx
      const module = await import(`@/components/features/${componentName}/${componentName}`)

      // Get the component from the module
      const Component = module.default || module[componentName]

      if (Component) {
        // Create React root and render the component
        this.root = ReactDOM.createRoot(this.element)
        this.root.render(React.createElement(Component, this.propsValue))
      } else {
        console.error(`React component "${componentName}" not found in module`, module)
      }
    } catch (error) {
      console.error(`Failed to load React component: ${componentName}`, error)
    }
  }

  // Re-render component when props change
  propsValueChanged() {
    if (this.root) {
      this.renderReactComponent()
    }
  }
}
