require_relative "../concerns/memorable.rb"

class ListBestRatedMovies::Movie
    extend Memorable::ClassMethods

    attr_reader :name, :genre, :year, :score, :description, :director, :link, :latest

    @@all = []

    def initialize(name,genre=nil,year,score,description,director,link,latest)
        @name = name
        self.genre = genre if(genre!=nil)
        @year = year
        @score = score
        @description = description
        @director = director
        @link = link
        @latest = latest
        @@all << self
    end

    def self.all
        @@all
    end

    def genre=(genre)
        @genre = genre
        if(!genre.movies.include?self)
            genre.movies << self
        end
      end

    def self.find_all_by_genre(genre)
        self.all.select {|o| o.genre == genre}
    end

    def self.find_by_genre_and_year(genre,year)
        self.all.select {|o| o.genre == genre && o.year == year}
    end

    def self.find_by_latest_and_name
        movies = []
        self.all.each{ |movie|
            movies << movie if movie.latest    
        }
        movies.uniq { |movie| movie.name }
    end
    
end