require 'minitest/autorun'
require 'minitest/pride'
require './lib/artist'

class ArtistTest < Minitest::Test

  def setup
    @attributes = {
      id: "2",
      name: "Ansel Adams",
      born: "1902",
      died: "1984",
      country: "United States"
    }
    @artist = Artist.new(@attributes)
  end

  def test_it_exists
    assert_instance_of Artist, @artist
  end

  def test_it_has_attributes
    assert_equal @attributes[:id], @artist.id
    assert_equal @attributes[:name], @artist.name
    assert_equal @attributes[:born], @artist.born
    assert_equal @attributes[:died], @artist.died
    assert_equal @attributes[:country], @artist.country
  end

end
