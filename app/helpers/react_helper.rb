# frozen_string_literal: true

# Helper methods for rendering React components in Rails views
module ReactHelper
  # Renders a React component with server-side props
  #
  # @param component_name [String] The name of the React component (matches directory name)
  # @param props [Hash] Props to pass to the React component (will be JSON serialized)
  # @param tag [String] The HTML tag to use for the mount point (default: 'div')
  # @param html_options [Hash] Additional HTML attributes
  #
  # @example Render a Dashboard component
  #   <%= react_component 'Dashboard', userId: current_user.id, class: "w-full" %>
  #
  # @example Render with custom tag
  #   <%= react_component 'AnalyticsChart', data: @stats, tag: 'section' %>
  def react_component(component_name, props: {}, tag: 'div', html_options: {})
    html_options = html_options.merge(
      data: {
        react_component: component_name,
        react_props: props.to_json
      }
    )

    content_tag(tag, '', html_options)
  end

  # Check if React should be used for the current request
  # This can be used for conditional rendering logic
  #
  # @return [Boolean] true if React should be used
  def use_react?
    # Logic to determine when to use React vs Turbo
    # Example: use React for specific controllers or actions
    false # Default to false, opt-in for specific pages
  end
end
