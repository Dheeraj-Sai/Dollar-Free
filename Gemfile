# frozen_string_literal: true

source "https://rubygems.org"

# Both gems are only needed while developing. The app itself runs on plain
# Ruby with no gems.
group :development, :test do
  # The test framework. It ships with Ruby, but it is listed here so everyone
  # runs the same version.
  gem "minitest", "~> 5.0"

  # Checks the code style. "require: false" means it is only used from the
  # command line, not loaded by the app.
  gem "rubocop", "~> 1.0", require: false
end
