require 'minitest/autorun'
require 'minitest/pride'
require './lib/photograph'

class PhotographTest < Minitest::Test

  def setup
    @photograph = Photograph.new
  end

  def test_it_exists
    assert_instance_of Photograph, @photograph
  end

end