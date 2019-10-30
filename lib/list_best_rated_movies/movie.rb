require_relative "../concerns/memorable.rb"

class ListBestRatedMovies::Movie
    extend Memorable::ClassMethods

    attr_reader :name, :year, :score, :description, :director, :link, :latest

    @@all = []

    def initialize(name,genres,year,score,description,director,link,latest)
        @name = name
        genres.each do |genre|
            ListBestRatedMovies::MovieGenre.new(self,genre)
        end
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

    def genres
        movie_genres = ListBestRatedMovies::MovieGenre.all.select {|movie_genre| movie_genre.movie == self}
        movie_genres.map do |movie_genre| 
           movie_genre.genre
        end
    end

    def self.find_all_by_genre(genre)
        self.all.select {|o| o.genre == genre}
    end

    def self.find_by_genre_and_year(genre,year)
        self.all.select {|o| o.genres.include?(genre) && o.year == year}
    end

    def self.find_by_latest
        self.all.select{ |movie| movie if movie.latest }
    end

    def genre_list
        genres.map { |genre| genre.name.capitalize }.join(", ")
    end
end