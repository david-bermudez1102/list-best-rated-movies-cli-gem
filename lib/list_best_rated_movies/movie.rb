class ListBestRatedMovies::Movie
    attr_reader :name, :genre, :year, :rt_score, :imdb_score

    @@all = []

    def initialize(name,genre=nil,year,rt_score,imdb_score)
        @name = name
        @genre = genre
        @year = year
        @rt_score = rt_score
        @imdb_score = imdb_score
       self.save
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

    def genres
        Genre.all.select {|genre| genre.movies == self} # A movie can have many genres
    end
    
    def genre=(genre)
        @genre = genre
        if(!genre.movies.include?self)
            genre.movies << self
        end
      end

    def find_by_name(name)
        self.all.find {|o| o.name == name}
    end
end