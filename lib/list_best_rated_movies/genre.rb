class ListBestRatedMovies::Genre
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

    def self.save
        @@all << self
    end

    def self.reset_all
        @@all.clear
    end

    def self.count
        self.all.count
    end

    def new_movie(movie)
        if(!movie.genre)
            movie.genre = self
        end
      
        if(!self.movies.include?movie)
            self.movies << movie
        end
    end

    def movies
        Movie.all.select {|movie| movie.genre == self}
    end
end