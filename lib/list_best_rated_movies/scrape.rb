require 'nokogiri'
require 'open-uri'
require 'colorize'

require_relative './version.rb'
require_relative './genre.rb'
require_relative './movie.rb'

class ListBestRatedMovies::Scraper
    attr_accessor :genre, :year

    def initialize
        
    end
    
    def scrape_genres
        genres = []
        genres_data = url("https://www.rottentomatoes.com/top/bestofrt/top_100_horror_movies/") #Where we are obtaining our genres from
        genres_data.css("div.btn-group.btn-primary-border-dropdown ul.dropdown-menu li").each {|li|
            genre = scrape_genre(li)

            if !genres.detect {|g| g.name.include?(genre)}
                genres << ListBestRatedMovies::Genre.new(genre)
            end     
        }
        genres
    end

    def url(url)
        url = open(url)
        data = Nokogiri::HTML(url)  
        data
    end

    def data
        if(@genre.include?("&"))
            genre_2 = @genre.split(" & ")
            genre_2 = "#{genre_2[0]}__#{genre_2[1]}"
            data = url("https://www.rottentomatoes.com/top/bestofrt/top_100_#{genre_2}_movies/") # RottenTomatoes data
        else
            data = url("https://www.rottentomatoes.com/top/bestofrt/top_100_#{@genre}_movies/")  # RottenTomatoes data
        end

        data
    end
    
    def scrape
        data = self.data
        genre = self.get_genre
        data.css("div.panel-body.content_body.allow-overflow table.table").each { |movie|
            movie.css("tr").each { |cell|
                name = scrape_name(cell)
                year = scrape_year(cell)
                score = scrape_score(cell)
                save_movie(cell,name,genre,year,score)
            }   
        }
    end
    
    def scrape_name(data)
        name = data.css("a.unstyled.articleLink").text.strip.split(" (")[0].to_s
        name
    end

    def scrape_genre(data)
        genre = data.css("a").text.strip.to_s.downcase
        genre
    end

    def scrape_year(data)
        year = data.css("a.unstyled.articleLink").text.strip.split(" (")[1].to_s.gsub(/[)]/, "").to_i
        year
    end

    def scrape_score(data)
        score = data.css("span.tMeterIcon.tiny span.tMeterScore").text.gsub("\u00A0", "")
        score
    end

    def get_genre
        genre = ListBestRatedMovies::Genre.all.detect {|g| !!g.name.match(/\b#{@genre}\b/)}
        genre
    end

    def scrape_description(data)
        movie_link = data.css("a.unstyled.articleLink").attribute("href").value
        url = url("https://www.rottentomatoes.com#{movie_link}")
        description = url.css("#movieSynopsis.movie_synopsis.clamp.clamp-6.js-clamp").text.strip
        description
    end

    def save_movie(data,name,genre,year,score)
        # This will prevent page to get reloaded if object already exists 
        if(!ListBestRatedMovies::Movie.all.detect{|movie| movie.name==name && movie.genre==genre && movie.year==year})              
            if(data.css("a.unstyled.articleLink").text != "")
                if(@year=="all")
                    description = scrape_description(data)
                    ListBestRatedMovies::Movie.new(name,genre,year,score,description)
                elsif(year==@year)
                    description = scrape_description(data)
                    ListBestRatedMovies::Movie.new(name,genre,year,score,description)
                end
            end
        end
    end

end
