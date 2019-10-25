class ListBestRatedMovies::Movie
    attr_reader :name, :genre, :year, :rt_score, :description

    @@all = []

    def initialize(name,genre=nil,year,rt_score,description)
        @name = name
        self.genre = genre if(genre!=nil)
        @year = year
        @rt_score = rt_score
        @description = description
        @@all << self
    end

    def self.all
        @@all
    end

    def self.count
        self.all.count
    end

    def genre=(genre)
        @genre = genre
        if(!genre.movies.include?self)
            genre.movies << self
        end
      end

    def self.save
        self.all << self
    end

    def self.reset_all
       self.all.clear
    end

    def self.find_all_by_genre(genre)
        self.all.select {|o| o.genre == genre}
    end

    def self.find_by_genre_and_year(genre,year)
        self.all.select {|o| o.genre == genre && o.year == year}
    end
end