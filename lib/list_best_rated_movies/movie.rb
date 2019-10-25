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
    def find_by_name(name)
        self.all.find {|o| o.name == name}
    end
end