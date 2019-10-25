class ListBestRatedMovies::Genre
    attr_reader :name, :movies

    @@all = []

    def initialize(name)
        @name = name
        @movies = []
        self.class.save
    end

    def self.all
        @@all
    end

    def self.save
        self.all << self
    end

    def self.reset_all
        self.all.clear
    end

    def self.count
        self.all.count
    end

end