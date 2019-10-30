require 'json'

class ListBestRatedMovies::CertifiedFresh < ListBestRatedMovies::Scraper

    def data
        data = url("https://www.rottentomatoes.com/browse/cf-in-theaters/")
        data
    end

    def scrape
        data = self.data
        movies = JSON[data.css("#jsonLdSchema").text]

        movies["itemListElement"].each{ |movie|
            link = "https://www.rottentomatoes.com#{movie["url"]}"

            if(!ListBestRatedMovies::Movie.all.detect{|movie| movie.link==link }) 
                url = url("https://www.rottentomatoes.com#{movie["url"]}")
                
                name = scrape_name(url)
                year = scrape_year(url)
                score = scrape_score(url)
                description = scrape_description(url)
                director = scrape_director(url)
                genres = scrape_genre(url).map { |genre_name|
                    get_genre(genre_name)  
                }
                ListBestRatedMovies::Movie.new(name,genres,year,score,description,director,link,true)
            end
            
        }
    end

    def scrape_name(data)
        name = data.css("h1.mop-ratings-wrap__title.mop-ratings-wrap__title--top").text.strip.to_s
        name
    end

    def scrape_year(data)
        year = data.css("ul.content-meta.info li:contains('In Theaters:') div.meta-value time").text.strip
        year = year.split(", ")[1].to_i
        year
    end

    def scrape_score(data)
        score = data.css(".mop-ratings-wrap__percentage")[0].text.gsub(/\s+/, "")
        score
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
end

