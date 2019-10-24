# ListBestRatedMovies

CLI will help user to check the best top rated movies by genre/year and see the full description of the movie they pick


Program will scrape data from https://www.rottentomatoes.com/top/bestofrt/top_100_#{genre}_movies/ and 
https://www.imdb.com/search/title/?genres=#{genre}&explore=title_type,genres to get the best movies by genre/ year and get their 
title, description, scores, etc

Program will prompt user what genre they want to check the best movies with
If user inputs comedy, We'll scrape into https://www.rottentomatoes.com/top/bestofrt/top_100_comedy_movies/
If user inputs all, We'll scrape into all genre links available at https://www.rottentomatoes.com/top/bestofrt/top_100_#{genre}_movies/

Program will prompt user what year they want to check the best movies with
If user inputs 2018, We'll only show the movies of that year based on the genre user inputs above
If user inputs all, We'll show all the movies of that year based on the genre user inputs above

The full list will show grouped by score as follows
	Title: movie_title
	Genre: movie_genre
	Year: movie_year
	Score: rotten_tomatoes, IMDB, number of reviews in rotten tomatoes
	Description: movie_description
	movie_link

CLI will prompt user new options
	- If user wants to check one of the listed movies in more detail, input the name
	- If user wants to organize by Alphabet asc/desc
	- If user wants to organize by Rotten Tomatoes score input rt of RT
	- If user wants to organize by IMDB score input rt of RT
	- If user wants to start over

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'list_best_rated_movies'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install list_best_rated_movies

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[david-bermudez1102]/list_best_rated_movies.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
