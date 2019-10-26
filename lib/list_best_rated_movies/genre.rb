require_relative "../concerns/memorable.rb"
class ListBestRatedMovies::Genre
    extend Memorable::ClassMethods

    attr_reader :name, :movies

    @@all = []

    def initialize(name)
        @name = name
        @movies = []
        @@all << self
    end

    def self.all
        @@all
    end
end