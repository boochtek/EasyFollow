# Shoulda gives us this:
#   it { should_not allow_value('bad').for(:isbn) }
#   it { should allow_value("isbn 1 2345 6789 0").for(:isbn) }
# We want to allow these:
#   its(:isbn) { should_not allow_values('bad', 'another_bad_isbn', nil)
#   its(:isbn) { should allow_values("isbn 1 2345 6789 0", "1 2345 6789 0", "1234567890") }
# We're currently here:
#   it { should_not allow_values_for(:isbn, 'bad', 'another_bad_isbn', nil)
#   it { should allow_values_for(:isbn, "isbn 1 2345 6789 0", "1 2345 6789 0", "1234567890") }
# I don't think we can get to its(:isbn), because we no longer have access to SET the isbn.
#   We might be able to get at it from description, description_args, or send(:description_parts).reverse.find {|part| part.is_a?(Symbol)}.
#     Or perhaps override its() to record the attribute name, like Remarkable does for describe: http://github.com/carlosbrando/remarkable/blob/master/remarkable_activerecord/lib/remarkable_activerecord/describe.rb.
# BTW, I'm pretty sure that I developed this independently from http://remarkable.rubyforge.org/activerecord/classes/Remarkable/ActiveRecord/Matchers.html#M000020
#   But I may just use his version instead.


# I wrote these to make it easy to specify invalid and valid attributes in a list, to "declare" good and bad attribute values to test. (Craig Buchek)

# Examples:
#       @quote_section.should allow_values_for(:name, 'Craig', 'Bob', 'a' * 64, 'John Johnson')
#       @quote_section.should_not allow_values_for(:name, nil, '', 'a' * 65, 12.2)
#       describe User do
#          it { should allow_values_for(:name, 'Jim', 'Bob Jefferson', 'Dale Earnhardt, Jr.') }
#          it { should_not allow_values_for(:name, nil, '', 12.2, 145, 'A-B') }
#       end


module AllowValuesForMatchers

  # :call-seq:
  # it { should     allow_values_for(attribute, *array) }
  # it { should_not allow_values_for(attribute, *array) }
  #
  # Passes if the receiving object would be valid with the specified attribute set to each and every one of the items in the array.
  def allow_values_for(attrib, *array_of_expected_values)
    AllowValuesFor.new(attrib, *array_of_expected_values)
  end

  alias :be_valid_with :allow_values_for

  # Note that we cannot use Spec::Matchers.define, because that doesn't handle does_not_match?.
  # We need does_not_match? because the should_not case is not the exact opposite of the should case.
  # For example, if an attribute is only valid set to either 'A' or 'B', then both of these should fail:
  #   should     allow_values_for(:a_or_b, 'A', 'C') # fails because it's not valid with C
  #   should_not allow_values_for(:a_or_b, 'A', 'C') # fails because it's valid with A
  class AllowValuesFor  #:nodoc:

    def description
      "be valid with '#{@attrib}' attribute set to each/any of the given values"
    end

    def failure_message_for_should
      "#{@actual.class} was not valid when #{@attrib} attribute was set to the following values:\n  #{@invalid_values.each{|v| v.inspect}.join("\n  ")}"
    end

    def failure_message_for_should_not
      "#{@actual.class} was valid when #{@attrib} attribute was set to the following values:\n  #{@valid_values.each{|v| v.inspect}.join("\n  ")}"
    end

    def initialize(attrib, *array_of_expected_values)
      @attrib = attrib
      @expected = array_of_expected_values
    end

    def matches?(actual)
      @actual = actual
      @invalid_values = []
      attrib_setter = (@attrib.to_s + '=').to_sym
      @expected.each do |value|
        @actual.send(attrib_setter, value)
        if !@actual.valid?
          @invalid_values << value
        end
      end
      return @invalid_values.empty?
    end

    def does_not_match?(actual)
      @actual = actual
      @valid_values = []
      attrib_setter = (@attrib.to_s + '=').to_sym
      @expected.each do |value|
        @actual.send(attrib_setter, value)
        if @actual.valid?
          @valid_values << value
        end
      end
      return @valid_values.empty?
    end

  end

end

Spec::Runner.configure do |config|
  config.include(AllowValuesForMatchers)
end
