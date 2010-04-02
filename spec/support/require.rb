# Allows the following syntax for models:
#   it { should require :title }
# Equivalent to:
#   its(:title) { should_not allow_values(nil, '') }

# TODO: Test this.
# TODO: Also make aliases require_a/require_an.

# Adapted from code at http://chrisconley.posterous.com/using-rspec-custom-matchers-to-test-validatio
Spec::Matchers.define :require do |attribute|

  description { "require an attribute named #{attribute}" }
  failure_message_for_should     { |klass| "expected that #{klass} would require a(n) #{attribute} attribute" }
  failure_message_for_should_not { |klass| "expected that #{klass} would not require a(n) #{attribute} attribute" }

  match do |klass|
    object = klass.new
    attribute = (attribute.to_s + '=').to_sym
    object.send(attribute, nil)
    !object.valid?
  end

end