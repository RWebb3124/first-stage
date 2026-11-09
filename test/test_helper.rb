ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    # Number of SQL queries the block runs (ignoring schema lookups).
    # Rails 7.2 adds assert_queries_count; this is the 7.1 equivalent.
    # Cached queries are counted too: in tests the query cache carries over
    # between requests, so skipping them would hide every repeated query.
    def count_queries(&block)
      count = 0
      counter = lambda { |*, payload| count += 1 unless payload[:name] == "SCHEMA" }
      ActiveSupport::Notifications.subscribed(counter, "sql.active_record", &block)
      count
    end
  end
end

module ActionDispatch
  class IntegrationTest
    # Gives request tests `sign_in users(:bob)` and `sign_out :user`.
    include Devise::Test::IntegrationHelpers
  end
end
