require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/artist'
require './lib/photograph'
require './lib/curator'

class CuratorTest < Minitest::Test

  def setup
    @photo_1 = Photograph.new({
      id: "1",      
      name: "Rue Mouffetard, Paris (Boy with Bottles)",      
      artist_id: "1",      
      year: "1954"      
    })  
    @photo_2 = Photograph.new({
      id: "2",      
      name: "Moonrise, Hernandez",      
      artist_id: "2",      
      year: "1941"      
    })
    @photo_3 = Photograph.new({    
      id: "3",      
      name: "Identical Twins, Roselle, New Jersey",      
      artist_id: "3",      
      year: "1967"      
    })
    @photo_4 = Photograph.new({    
      id: "4",      
      name: "Monolith, The Face of Half Dome",      
      artist_id: "3",      
      year: "1927"      
    })
    @artist_1 = Artist.new({
      id: "1",      
      name: "Henri Cartier-Bresson",      
      born: "1908",      
      died: "2004",      
      country: "France"      
    })    
    @artist_2 = Artist.new({
      id: "2",      
      name: "Ansel Adams",      
      born: "1902",      
      died: "1984",      
      country: "United States"      
    }) 
    @artist_3 = Artist.new({    
      id: "3",      
      name: "Diane Arbus",      
      born: "1923",      
      died: "1971",      
      country: "United States"      
    }) 
    @curator = Curator.new
  end

  def test_it_exists
    assert_instance_of Curator, @curator
  end

  def test_it_has_attributes
    assert_equal [], @curator.photographs
    assert_equal [], @curator.artists
  end

  def test_it_can_add_photographs
    @curator.add_photograph(@photo_1)
    assert_equal [@photo_1], @curator.photographs

    @curator.add_photograph(@photo_2)
    assert_equal [@photo_1, @photo_2], @curator.photographs
  end

  def test_it_can_add_artists
    @curator.add_artist(@artist_1)
    assert_equal [@artist_1], @curator.artists

    @curator.add_artist(@artist_2)
    assert_equal [@artist_1, @artist_2], @curator.artists
  end

  def test_it_can_find_artists_by_id
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    assert_equal @artist_1, @curator.find_artist_by_id("1")
    assert_equal @artist_2, @curator.find_artist_by_id("2")
  end
  
  def test_can_find_photo_by_id
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    assert_equal @photo_1, @curator.find_photograph_by_id("1")
    assert_equal @photo_2, @curator.find_photograph_by_id("2")
  end

  def test_it_can_find_all_photographs_by_artist
    @curator.add_artist(@artist_1)  
    @curator.add_artist(@artist_2)    
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)

    assert_equal [@photo_1], @curator.find_photographs_by_artist(@artist_1)
    assert_equal [@photo_2], @curator.find_photographs_by_artist(@artist_2)
    assert_equal [@photo_3, @photo_4], @curator.find_photographs_by_artist(@artist_3)
  end

  def test_it_can_give_all_artists_with_multiple_photographs
    @curator.add_artist(@artist_1)  
    @curator.add_artist(@artist_2)    
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    assert_equal [@artist_3], @curator.artists_with_multiple_photographs

    new_photo = mock()
    new_photo.stubs(:artist_id).returns("1")
    @curator.add_photograph(new_photo)
    assert_equal [@artist_1, @artist_3], @curator.artists_with_multiple_photographs
  end

  def test_it_can_give_photos_taken_by_artists_from_a_specified_country
    @curator.add_artist(@artist_1)  
    @curator.add_artist(@artist_2)    
    @curator.add_artist(@artist_3)
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    assert_equal [@photo_2, @photo_3, @photo_4], @curator.photographs_taken_by_artist_from("United States")
    assert_equal [], @curator.photographs_taken_by_artist_from("Argentina")
  end

  def test_can_create_artist_data_from_csv_line
    line = {
      "id" => "1",
      "name" => "Henri Cartier-Bresson",
      "born" => "1908",
      "died" => "2004",
      "country" => "France"
    }
    expected_hash = {
      :id => "1",
      :name => "Henri Cartier-Bresson",
      :born => "1908",
      :died => "2004",
      :country => "France"
    }

    assert_equal expected_hash, @curator.line_to_artist_hash(line)
  end

  def test_can_create_photo_data_from_csv_line
    line = {
      "id" => "1",
      "name" => "Rue Mouffetard, Paris (Boy with Bottles)",
      "artist_id" => "1",
      "year" => "1954"
    }
    expected_hash = {
      :id => "1",
      :name => "Rue Mouffetard, Paris (Boy with Bottles)",
      :artist_id => "1",
      :year => "1954"
    }
    assert_equal expected_hash, @curator.line_to_photograph_hash(line)
  end

  def test_can_load_artists_from_csv
    @curator.load_artists("./data/artists.csv")

    assert_equal 6, @curator.artists.length

    @curator.artists.each do |artist|
      assert_instance_of Artist, artist
      assert artist.id
      assert artist.name
      assert artist.born
      assert artist.died
      assert artist.country
    end
  end

  def test_can_load_photographs_from_csv
    @curator.load_photographs("./data/photographs.csv")

    assert_equal 4, @curator.photographs.length

    @curator.photographs.each do |photo|
      assert_instance_of Photograph, photo
      assert photo.id
      assert photo.name
      assert photo.artist_id
      assert photo.year
    end
  end

  def test_can_find_photographs_taken_in_a_specified_time_range
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')

    expected_photos = []
    expected_photos.push(@curator.find_photograph_by_id("1"))
    expected_photos.push(@curator.find_photograph_by_id("4"))
    assert_equal expected_photos, @curator.photographs_taken_between(1950..1965)
  end

  def test_can_find_the_artists_age_when_a_photograph_was_taken
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')
    diane_arbus = @curator.find_artist_by_id("3")
    expected_hash = {
      44 =>"Identical Twins, Roselle, New Jersey", 
      39 =>"Child with Toy Hand Grenade in Central Park"
    }
    @curator.artists_photographs_by_age(diane_arbus)
  end

end