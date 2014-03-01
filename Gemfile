source 'https://rubygems.org'

gemspec

# Not yet a build time dependency
gem 'net-ssh-multi'
gem 'net-scp', "~> 1.1.2"

gem 'pry' if ENV['PRY']

gem 'simplecov', :require => false, :group => :test
gem 'format', :require => false, :group => :test

# Fedora 17 splits bigdecimal out into its own gem.  No other platform has bigdecimal as a gem.
if Gem::Specification.respond_to?(:find_all_by_name) and not Gem::Specification::find_all_by_name('bigdecimal').empty?
  gem 'bigdecimal', :require => false, :group => :test
end

# Fedora 19 splits psych out into its own gem.
if Gem::Specification.respond_to?(:find_all_by_name) and not Gem::Specification::find_all_by_name('psych').empty?
  gem 'psych'
end
