source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'highline'
gem 'mysql2'
gem 'rails', '~> 5.1.6'
gem 'rainbow'

group :development, :test do
  gem 'byebug'
  gem 'factory_girl_rails'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-byebug'
  gem 'rspec'
  gem 'rubocop', require: false
end
