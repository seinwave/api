Rails.application.configure do
  # Generate a folder for each component for
  # Template, CSS, JS...
  config.view_component.generate.sidecar = true

  # Serve previews stored in this folder
  config.view_component.preview_paths << "#{Rails.root}/spec/components/previews"

  # Configure a component all other components inherit from
  config.view_component.component_parent_class = "ApplicationComponent"
end”
