# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
JosephStalin::Application.initialize!

Haml::Template.options[:format] = :xhtml
ActionController::Base.asset_host = Project::ADDRESS

# Remove error divs from form
ActionView::Base.field_error_proc = proc { |input, instance| input }

# if you don't want to see delta logs
# ThinkingSphinx.suppress_delta_output = true
