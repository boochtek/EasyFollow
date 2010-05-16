require 'spec_helper'

describe Bio do
  let(:bio) { Bio.new }
  subject { bio }

  it { should be_valid }

  it { should ensure_length_of(:location).is_at_most(50) }
  it { should allow_values_for(:location, nil, '', 'Saint Louis', 'St. Louis', 'St. Louis, MO', 'Minneapolis-St. Paul, MN, USA') }

  it { should ensure_length_of(:industry).is_at_most(50) }
  it { should allow_values_for(:industry, nil, '', 'STL') }

  it { should ensure_length_of(:title).is_at_most(75) }
  it { should allow_values_for(:title, nil, '', 'STL') }

  it { should ensure_length_of(:description).is_at_most(1000) }
  it { should allow_values_for(:description, nil, '', 'This is my bio. It might actually be really, really long!') }

end
