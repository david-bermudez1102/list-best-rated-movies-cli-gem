require 'nokogiri'
require 'open-uri'

require_relative './version.rb'
require_relative './cli.rb'
require_relative './genre.rb'
require_relative './movie.rb'

class ListBestRatedMovies::Scrape
    attr_accessor :genre, :year

    def initialize(genre,year)
        @genre = genre
        @year = year
    end
    
    def url(url)
        url = open(url)
        data = Nokogiri::HTML(url)  
        data
    end

    def get_data
        genre = ListBestRatedMovies::Genre.new(@genre)
        rt_data = url("https://www.rottentomatoes.com/top/bestofrt/top_100_#{@genre}_movies/") # RottenTomatoes data

        movies = []

        rt_data.css("div.panel-body.content_body.allow-overflow table.table").each { |movie|
            movie.css("tr").each { |cell|
                name = cell.css("a.unstyled.articleLink").text.strip.split(" (")[0].to_s
                year = cell.css("a.unstyled.articleLink").text.strip.split(" (")[1].to_s.gsub(/[)]/, "").to_i
                possible_year = year - 1
                rt_score = cell.css("span.tMeterIcon.tiny span.tMeterScore").text.gsub("\u00A0", "")
                

                if(cell.css("a.unstyled.articleLink").text != "" && year==@year)
                    
                    url("https://www.imdb.com/find?q=#{name}&s=all").css("table.findList").each { |list|
                            imdb_url_2 = url("https://www.imdb.com#{list.css("tr.findResult td.result_text a")[0].attribute("href").value.to_s}")
                            if(imdb_url_2.css("div#title-overview-widget div.subtext a").text.include?@genre.capitalize)
                                @imdb_rating = imdb_url_2.css("[itemprop='ratingValue']").text
                                @description = imdb_url_2.css(".summary_text").text.strip
                            end
                    }
    
                    ListBestRatedMovies::Movie.new(name,genre,year,rt_score,@imdb_rating,@description)
                end
            }   
        }
        ListBestRatedMovies::Movie.all.each.with_index(1) { |movie,index|
            puts "#{index}. #{movie.name}".green
            puts "----------------------------------"
            puts "Genre:".red+" #{movie.genre.name.capitalize}"
            puts "Year:".red+" #{movie.year}"
            puts "Rotten Tomatoes Score:".red+" #{movie.rt_score}"
            puts "IMDB Score:".red+" #{movie.imdb_score}"
            puts "Description:".red+" #{movie.description}"
            puts "----------------------------------"
            puts ""
        }
    end

end
ListBestRatedMovies::Scrape.new("horror",2015).get_data