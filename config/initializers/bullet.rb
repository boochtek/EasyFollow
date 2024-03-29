if ['development', 'test'].include? Rails.env && !defined?(Rails::Generator)
  Bullet.enable = true
  # Log to the standard Rails log as well as log/bullet.log and the browser's console log.
  Bullet.bullet_logger = true
  Bullet.rails_logger = true
  Bullet.console = true
  # Disable browser cache, which could cause problems, according to Bullet README.
  Bullet.disable_browser_cache = true
  begin
    # Use Growl if we have it.
    require 'ruby-growl'
    Bullet.growl = true
  rescue MissingSourceFile
    # If we don't have Growl, use a JavaScript alert.
    Bullet.alert = true
  end
end
