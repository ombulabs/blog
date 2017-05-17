Gem::Specification.new do |s|
  s.name        = "blog"
  s.version     = `git tag | tail -n 1`
  s.summary     = "Ombulabs Blog"
  s.email       = ["hello@ombulabs.com"]
  s.authors     = ["OmbuLabs"]
  s.files       = Dir["_site/**/*"]
  s.homepage    = "https://github.com/ombulabs/blog.ombulabs.com"
  s.license     = "MIT"
  s.required_ruby_version = '> 2.3'

  s.add_dependency('rake', '~> 12.0')
  s.add_dependency('jekyll', '~> 3.0')
  s.add_dependency('jekyll-categories')
  s.add_dependency('jekyll-authors')
  s.add_dependency('jekyll-titleize')
  s.add_dependency('jekyll-paginate')
  s.add_dependency('sitemap_generator')
  s.add_dependency('dotenv')

  s.add_dependency('pygments.rb')
  s.add_dependency('redcarpet')
end
