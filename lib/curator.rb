require 'csv'

class Curator
  attr_reader :photographs,
              :artists

  def initialize
    @photographs = []
    @artists     = []
  end

  def add_photograph(photo)
    @photographs.push(photo)
  end

  def add_artist(artist)
    @artists.push(artist)
  end

  def find_artist_by_id(id)
    @artists.find { |artist| artist.id == id }
  end

  def find_photograph_by_id(id)
    @photographs.find { |photo| photo.id == id }
  end

  def find_photographs_by_artist(artist)
    @photographs.find_all { |photo| photo.artist_id == artist.id }
  end

  def artists_with_multiple_photographs
    @artists.find_all do |artist| 
      find_photographs_by_artist(artist).length > 1
    end
  end

  def photographs_taken_by_artist_from(country)
    @photographs.find_all do |photo| 
      find_artist_by_id(photo.artist_id).country == country 
    end
  end

  def line_to_artist_hash(line)
    {
      :id => line["id"],
      :name => line["name"],
      :born => line["born"],
      :died => line["died"],
      :country => line["country"]
    }
  end

  def line_to_photograph_hash(line)
    {
      :id => line["id"],
      :name => line["name"],
      :artist_id => line["artist_id"],
      :year => line["year"]
    }
  end

  def load_artists(file)
    CSV.foreach(file, headers: true) do |line|
      add_artist(Artist.new(line_to_artist_hash(line)))
    end
  end

  def load_photographs(file)
    CSV.foreach(file, headers: true) do |line|
      add_photograph(Photograph.new(line_to_photograph_hash(line)))
    end
  end

  def photographs_taken_between(range)
    @photographs.find_all { |photo| range.include?(photo.year.to_i) }
  end

  def artists_photographs_by_age(artist)
  end

end