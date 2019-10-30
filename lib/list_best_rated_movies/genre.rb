require_relative "../concerns/memorable.rb"

class ListBestRatedMovies::Genre
    extend Memorable::ClassMethods

    attr_reader :name

    @@all = []

    def initialize(name)
        @name = name
        @@all << self
    end

    def self.all
        @@all
    end

    def movies
        movie_genres = ListBestRatedMovies::MovieGenre.all.select {|movie_genre| movie_genre.genre == self}
        movie_genres.map do |movie_genre| 
           movie_genre.movie
        end
    end

    def self.find_or_create_by_name(genre_name)
        if self.all.detect {|genre| genre.name == genre_name}
            self.all.detect {|genre| genre.name == genre_name}
        else
            self.new(genre_name)
        end
    end
end