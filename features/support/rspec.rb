# Allow use RSpec customer matchers from Cucumber.
Dir[File.expand_path(File.join("#{Rails.root}/spec/support","**","*.rb"))].each {|f| require f}
