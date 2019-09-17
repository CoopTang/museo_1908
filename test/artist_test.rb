require 'minitest/autorun'
require 'minitest/pride'
require './lib/artist'

class ArtistTest < Minitest::Test

  def setup
    @artist = Artist.new
  end

  def test_it_exists
    assert_instance_of Artist, @artist
  end

end