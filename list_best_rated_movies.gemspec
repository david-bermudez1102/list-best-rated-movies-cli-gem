lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "list_best_rated_movies/version"

Gem::Specification.new do |spec|
  spec.name          = "list_best_rated_movies"
  spec.version       = ListBestRatedMovies::VERSION
  spec.authors       = ["Juan D. Bermudez"]
  spec.email         = ["juan.bermudez1102@outlook.com"]

  spec.summary       = %q{CLI will help user to check the best top rated movies of all times with their full description, rating score and link, organized by genre/year of the movie they pick.}
  spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/david-bermudez1102/list-best-rated-movies-cli-gem"
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
