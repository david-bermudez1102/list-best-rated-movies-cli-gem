require_relative "../concerns/memorable.rb"

class ListBestRatedMovies::Genre
    extend Memorable::ClassMethods

    attr_reader :name
    attr_accessor :movies

    @@all = []

    def initialize(name)
        @name = name
        @movies = []
        @@all << self
    end

    def self.all
        @@all
    end

    def self.find_by_movie_name(movie_name)
        genres = []
        self.all.each {|genre| 
            genre.movies.each{ |movie|
                if(movie.name==movie_name)
                    genres << movie.genre
                end
            }
        }
        genres
    end
end