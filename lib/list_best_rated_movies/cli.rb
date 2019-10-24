class ListBestRatedMovies::CLI
    def call
        puts <<-DOC.gsub /^\s*/, ''
            What genre would you like to look for? Input the genre you want to choose:
        DOC
        list_genres
    end

    def list_genres
        puts <<-DOC.gsub /^\s*/, ''
        Available Genres:

            1. Comedy
            2. Horror
        DOC
        input = gets.chomp
        choose_genre(input)
    end

    def choose_genre(input)
        
    end

end