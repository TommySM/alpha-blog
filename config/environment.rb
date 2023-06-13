# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

ActiveStorage::Current.url_options = Rails.application.config.action_mailer.default_url_options


ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    html_tag.html_safe
end