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

    def get_data
        genre = ListBestRatedMovies::Genre.new(@genre)
        rt_url = open("https://www.rottentomatoes.com/top/bestofrt/top_100_#{@genre}_movies/")
        rt_data = Nokogiri::HTML(rt_url)

        movies = []
        rt_data.css("div.panel-body.content_body.allow-overflow table.table").each { |movie|
            movie.css("tr").each { |cell|
                movies << {
                    :name => cell.css("a.unstyled.articleLink").text.strip,
                    :year => cell.css("a.unstyled.articleLink").text.strip,
                    :rt_score => cell.css("span.tMeterIcon.tiny span.tMeterScore").text.chomp
                }
            }   
        }
        
        puts movies
    end

end
ListBestRatedMovies::Scrape.new("horror",2010).get_data