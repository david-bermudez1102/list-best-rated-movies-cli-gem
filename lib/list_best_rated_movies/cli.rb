require_relative '../list_best_rated_movies.rb'
require 'colorize'

class ListBestRatedMovies::CLI

    def initialize
        @scraper = ListBestRatedMovies::Scraper.new
        @genres = @scraper.scrape_genres
    end

    def call
        puts ""
        puts "Welcome! We'll help you to get the list of the best movies based on ratings by RottenTomatoes.com. You can filter by Genre and Year!".green
        puts ""
        puts "Which of the following genres would you like to choose? Input the genre you want".green
        list_genres
    end

    def list_genres
        puts ""
        @genres.each.with_index(1){|genre,index|
            puts "#{index}.".red+" #{genre.name.capitalize}"
        }
        set_genre
    end

    def set_genre
        puts ""
        puts "If you'd rather see Today'S Top Rated Movies, enter today"
        puts ""
        genre = gets.chomp
        if(genre.downcase=="today") #If user prefer to see today's best rated movies, we'll skip the rest and go directly to results
            show_results(genre)
        elsif(ListBestRatedMovies::Genre.all.detect {|g| g.name.match(/\b#{genre}\b/)})
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
        if(year.to_i>1800 || year.to_s.downcase=="all")
            @scraper.genre = genre.name.downcase
            year=="all" ? @scraper.year = year : @scraper.year = year.to_i
            if(year=="all")
                puts ""
                puts "Loading all years. It might take a while....".blue
            end
            @scraper.scrape
            show_results(genre,year)
        else
            puts ""
            puts "The year is not valid. Please enter a valid year"
            set_year(genre)
        end
    end

    def show_results(genre,year=nil)
        puts ""
        puts "Here are few of the best movies we found:".red
        puts ""

        movie_by_genre = ListBestRatedMovies::Movie.find_by_genre_and_year(genre,year.to_i) #If user chooses a specific year, will only choose those results
        if year=="all"
            movie_by_genre = ListBestRatedMovies::Movie.find_all_by_genre(genre) #Otherwise, all results of that genre will be listed
        end

        if(genre.downcase=="today") 
            ListBestRatedMovies::CertifiedFresh.new.scrape
            movie_by_genre = ListBestRatedMovies::Movie.find_by_latest_and_year.uniq
        end

        movie_by_genre.each.with_index(1) { |movie,i|

        genres = ListBestRatedMovies::Genre.find_by_movie_name(movie.name)

            genre = ""
            genres.each.with_index {|g,index|
                if (index==0)
                    genre << g.name.capitalize
                else
                    genre << ", #{g.name.capitalize}"
                end
            }

            puts "#{i}. #{movie.name}".green
            puts "-------------------------------------------------------------------------------------------------"
            puts "Genre:".red+" #{genre}"
            puts "Year:".red+" #{movie.year}"
            puts "Rotten Tomatoes Score:".red+" #{movie.score}"
            desc_red = "Description:".red
            puts <<~HEREDOC
            #{desc_red} #{movie.description}
            HEREDOC
            puts "Directed By:".red+" #{movie.director}"
            puts "Link:".red+" #{movie.link}"
            puts "-------------------------------------------------------------------------------------------------"
            puts ""
        }
        go_again
    end

    def go_again
        puts "Do you want to select another genre? Enter Yes or No"
        puts ""
        input = gets.chomp
        if(input=="yes") 
            call
        elsif(input=="no" || input=="exit")
            ListBestRatedMovies::Movie.reset_all
            ListBestRatedMovies::Genre.reset_all
            exit
        else
            puts ""
            puts "Please enter a vaild response".red
            puts ""
            go_again
        end
    end
    
end