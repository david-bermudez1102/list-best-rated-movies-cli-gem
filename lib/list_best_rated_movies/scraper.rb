require 'nokogiri'
require 'open-uri'

class ListBestRatedMovies::Scraper
    attr_accessor :genre, :year
    
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
        url = open(url,"User-Agent" => "MyCrawlerName (http://mycrawler-url.com)")
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
        genre = self.get_genre(@genre)
        data.css("div.panel-body.content_body.allow-overflow table.table").each { |movie|
            movie.css("tr").each { |cell|
                name = scrape_name(cell)
                year = scrape_year(cell)
                score = scrape_score(cell) 
                link = scrape_link(cell)
                save_movie(cell,name,genre,year,score,link)
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
        if(year==0)
            year = data.css("a.unstyled.articleLink").text.strip.split(" (")[2].to_s.gsub(/[)]/, "").to_i
        end
        year
    end

    def scrape_score(data)
        score = data.css("span.tMeterIcon.tiny span.tMeterScore").text.gsub("\u00A0", "")
        score
    end

    def get_genre(name)
        genre = ListBestRatedMovies::Genre.all.detect {|g| !!g.name.match(/\b#{name}\b/)}
        genre
    end

    def scrape_description(data)
        description = data.css("#movieSynopsis.movie_synopsis.clamp.clamp-6.js-clamp").text.strip
        description
    end

    def scrape_director(data)
        if(data.css("ul.content-meta.info li:contains('Director:')"))
            director = data.css("ul.content-meta.info li:contains('Directed By:') div.meta-value a").text
        else
            director = "No director found"
        end
        director
    end

    def scrape_link(data)
        link = data.css("a.unstyled.articleLink").attribute("href")
        link = "https://www.rottentomatoes.com#{link}"
        link
    end

    def movie_link(data)
        movie_link = data.css("a.unstyled.articleLink").attribute("href").value
        url = url("https://www.rottentomatoes.com#{movie_link}")
        url
    end

    def save_movie(data,name,genre,year,score,link)
        # This will prevent page to get reloaded if object already exists 
        if(!ListBestRatedMovies::Movie.all.detect{|movie| movie.name==name && movie.genre==genre && movie.year==year})
            if(data.css("a.unstyled.articleLink").text != "")
                if(@year=="all")
                    description = scrape_description(movie_link(data))
                    director = scrape_director(movie_link(data))
                    ListBestRatedMovies::Movie.new(name,genre,year,score,description,director,link,false)
                elsif(year==@year)
                    description = scrape_description(movie_link(data))
                    director = scrape_director(movie_link(data))
                    ListBestRatedMovies::Movie.new(name,genre,year,score,description,director,link,false)
                end
            end
        end
    end

end