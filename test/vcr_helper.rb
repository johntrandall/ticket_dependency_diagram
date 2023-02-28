# frozen_string_literal: true

module VcrHelper
  require "vcr"

  VCR.configure do |c|
    c.cassette_library_dir = "test/cassettes"
    c.hook_into(:webmock)
    c.default_cassette_options = { record: :once }
  end
end

def cassette_location
  [self.class.name.gsub(" ", "_"), name.gsub(" ", "_")].join("/")
end