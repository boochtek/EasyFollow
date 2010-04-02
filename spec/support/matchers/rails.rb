
# Allow ability to say @record.should_not be_saved or @record.should be_saved (by Craig Buchek)
module ActiveRecord #:nodoc:
  class Base
    def saved?
      !new_record?
    end
  end
end


# Override ApplicationController#current_user, since we cannot set session[:user_id] from RSpec's before.
class ApplicationController
  def current_user
    @current_user ||= User.find(1)
  end
end



# Got this one from http://opensoul.org/2007/4/18/rspec-model-should-be_valid
# This should already be supported as a predicate, but this will give more info on failures.
Spec::Matchers.define :be_valid do |nothing_expected|
  description { "be a valid model object" }
  failure_message_for_should { |actual| "#{actual.class} expected to be valid but had errors:\n  #{actual.errors.full_messages.join("\n  ")}" }
  failure_message_for_should_not { |actual| "expected that #{actual.class} would be invalid, but it was valid" }
  match do |actual|
    actual.valid?
  end
end

# I wrote this one myself, to combine be_a and be_valid. (Craig Buchek)
Spec::Matchers.define :be_a_valid do |expected|
  description { "be a valid model object" }
  failure_message_for_should do |actual|
    message = ''
    message += "object expected to be a(n) #{expected.name} but was a(n) #{actual.class.name}\n" unless actual.is_a?(expected)
    message += "#{actual.class.name} expected to be valid but had errors:\n  #{actual.errors.full_messages.join("\n  ")}" unless actual.valid?
  end
  failure_message_for_should_not do |actual|
    message = ''
    message += "object expected to NOT be a(n) #{expected.name} but was a(n) #{expected.name} (#{actual.class.name})\n" if actual.is_a?(expected)
    message += "#{actual.class} expected to be invalid but was valid.\n" if actual.valid?
  end
  match do |actual|
    actual.valid? and actual.is_a?(expected)
  end
end



module Spec
  module Rails
    module Matchers

      # Got this one from http://www.elevatedrails.com/articles/2007/05/09/custom-expectation-matchers-in-rspec/
      class HaveErrorOn
        def initialize(field)
          @field=field
        end
        def matches?(model)
          @model=model
          @model.valid?
          !@model.errors.on(@field).nil?
        end
        def description
          "have error(s) on #{@field}"
        end
        def failure_message_for_should
          "expected to have error(s) on #{@field} but doesn't"
        end
        def failure_message_for_should_not
          "expected NOT to have errors on #{@field} but does have an error: #{@model.errors.on(@field)}"
        end
      end
      def have_error_on(field)
        HaveErrorOn.new(field)
      end
      def have_errors_on(field)
        HaveErrorOn.new(field)
      end
    end
  end
end
