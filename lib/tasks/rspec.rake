task :rspec do
  system "bundle exec rspec spec/controllers/* spec/controllers/api/*"
end
