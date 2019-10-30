class ListBestRatedMovies::MovieGenre
    attr_reader :movie, :genre

    @@all = []
    
    def initialize(movie,genre)
        @movie = movie
        @genre = genre
        @@all << self
    end
    
    def self.all
        @@all
    end
end