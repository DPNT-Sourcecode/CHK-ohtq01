# hlo_test.rb

require_relative '../test_helper'
require 'logging'

Logging.logger.root.appenders = Logging.appenders.stdout

require_solution 'HLO'

class ClientTest < Minitest::Test

  def test_hlo
    assert_equal "Hello, John!", Hello.new.hello("John"), "hello to fraser should be hello john"
    assert_equal "Hello, john!", Hello.new.hello("john"), "hello to fraser should be hello john (with lowercase j)"
  end

end
