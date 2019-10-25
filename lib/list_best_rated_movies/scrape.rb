require 'nokogiri'
require 'open-uri'
require 'colorize'

require_relative './version.rb'
require_relative './genre.rb'
require_relative './movie.rb'

class ListBestRatedMovies::Scrape
    attr_accessor :genre, :year

    def initialize
        @data = url("https://www.rottentomatoes.com/top/bestofrt/top_100_horror_movies/")
    end
    
    def genres
        genres = []
        @data.css("div.btn-group.btn-primary-border-dropdown ul.dropdown-menu li").each {|li|
            if(!genres.detect {|g| g.name.include?(li.css("a").text.strip.to_s.downcase)})
                genres << create_genre(li.css("a").text.strip.to_s.downcase)
            end     
        }
        genres
    end

    def url(url)
        url = open(url)
        data = Nokogiri::HTML(url)  
        data
    end

    
    def get_data
        rt_data = url("https://www.rottentomatoes.com/top/bestofrt/top_100_#{@genre}_movies/") # RottenTomatoes data
        genre = ListBestRatedMovies::Genre.all.detect {|g| !!g.name.match(/\b#{@genre}\b/)}

        rt_data.css("div.panel-body.content_body.allow-overflow table.table").each { |movie|
            movie.css("tr").each { |cell|
                name = cell.css("a.unstyled.articleLink").text.strip.split(" (")[0].to_s
                year = cell.css("a.unstyled.articleLink").text.strip.split(" (")[1].to_s.gsub(/[)]/, "").to_i
                rt_score = cell.css("span.tMeterIcon.tiny span.tMeterScore").text.gsub("\u00A0", "")
                
                if(cell.css("a.unstyled.articleLink").text != "")
                    if(@year=="all")
                        url_2 = url("https://www.rottentomatoes.com#{cell.css("a.unstyled.articleLink").attribute("href").value}")
                        description = url_2.css("#movieSynopsis.movie_synopsis.clamp.clamp-6.js-clamp").text.strip
                        create_movie(name,genre,year,rt_score,description)
                    elsif(year==@year)
                        url_2 = url("https://www.rottentomatoes.com#{cell.css("a.unstyled.articleLink").attribute("href").value}")
                        description = url_2.css("#movieSynopsis.movie_synopsis.clamp.clamp-6.js-clamp").text.strip
                        create_movie(name,genre,year,rt_score,description)
                    end
                end
            }   
        }
    
    end

    def create_genre(name)
        ListBestRatedMovies::Genre.new(name)
    end

    def create_movie(name,genre,year,rt_score,description)
        ListBestRatedMovies::Movie.new(name,genre,year,rt_score,description)
    end

end
