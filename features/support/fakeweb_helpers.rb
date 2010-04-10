# Use FakeWeb to simulate requests to external web sites.

require 'fakeweb'

module FakeWebHelpers  
  # Make sure we don't allow access to any external web pages besides the ones we fake.
  FakeWeb.allow_net_connect = false

  # Turns a fixture file name into a full path
  def fixture_file(filename)
    return '' if filename == ''
    File.expand_path(RAILS_ROOT + '/features/fakeweb/' + filename)
  end

  # Convenience methods for stubbing URLs to fixtures
  def stub_get(url, filename)
    FakeWeb.register_uri(:get, url, :response => fixture_file(filename))
  end

  def stub_post(url, filename)
    FakeWeb.register_uri(:post, url, :response => fixture_file(filename))
  end

  def stub_any(url, filename)
    FakeWeb.register_uri(:any, url, :response => fixture_file(filename))
  end
end

World(FakeWebHelpers)
