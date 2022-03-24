Gem::Specification.new do |s|
  s.name = 'brokjson'
  s.version = '1.0.0'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Hazimi Asyraf']
  s.email = 'hazimi@hazimiasyraf.com'
  s.summary = 'BrokJSON is a space-saving alternative to GeoJSON'
  s.description = 'BrokJSON is a space-saving alternative to GeoJSON. Convert GeoJSON to BrokJSON and vice versa'
  s.homepage = 'https://github.com/jimmyasyraf/brokJSON_rb'
  s.license = 'MIT'

  s.required_ruby_version = '>= 2.6'

  s.files = ['lib/brokjson.rb']
  s.test_files = ['test/test_brokjson.rb']
end
