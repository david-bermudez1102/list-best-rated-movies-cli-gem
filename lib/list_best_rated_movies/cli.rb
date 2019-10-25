require_relative './scrape.rb'



class ListBestRatedMovies::CLI

    def initialize
        @scrape = ListBestRatedMovies::Scrape.new
        @genres = @scrape.genres
    end

    def call
        puts ""
        puts "Welcome! We'll help you to get the list of the best movies based on ratings by RottenTomatoes.com and you can filter by Genre and Year!".green
        puts ""
        puts "Which of the following genres would you like to choose? Input the genre you want".green
        list_genres
    end

    def list_genres
        puts ""
        @genres.each.with_index(1){|genre,index|
            puts "#{index}.".red+" #{genre.name}"
        }
        set_genre
    end

    def set_genre
        puts ""
        genre = gets.chomp
        if(ListBestRatedMovies::Genre.all.detect {|g| g.name.match(/\b#{genre}\b/)})
            genre = ListBestRatedMovies::Genre.all.detect {|g| g.name.match(/\b#{genre}\b/)}
            puts ""
            puts "Enter the year. (For all the years, enter all):"
            set_year(genre)
        else
            puts ""
            puts "The genre doesn't exist. Please enter one of the genres that match with one of the genres above"
            set_genre
        end
    end

    def set_year(genre)
        puts ""
        year = gets.chomp
        if(year.to_i>1800 || year=="all")
            @scrape.genre = genre.name
            @scrape.year = year
            if(year=="all")
                puts ""
                puts "Loading all years. It might take a while....".blue
            end
            @scrape.get_data
            show_results
        else
            puts ""
            puts "The year is not valid. Please enter a valid year"
            set_year(genre)
        end
    end

    def show_results
        puts ""
        puts "Here are few of the best movies we found:".red
        puts ""
        ListBestRatedMovies::Movie.all.each.with_index(1) { |movie,index|
            puts "#{index}. #{movie.name}".green
            puts "-------------------------------------------------------------------------------------------------"
            puts "Genre:".red+" #{movie.genre.name.capitalize}"
            puts "Year:".red+" #{movie.year}"
            puts "Rotten Tomatoes Score:".red+" #{movie.rt_score}"
            desc_red = "Description:".red
            puts <<~HEREDOC
            #{desc_red} #{movie.description}
            HEREDOC
            puts "-------------------------------------------------------------------------------------------------"
            puts ""
        }
    end
end
ListBestRatedMovies::CLI.new.call