require 'sitemap_generator'

Jekyll::Hooks.register :site, :post_write do |site|
  unless site.config["watch"]
    puts "Generating sitemap.xml.gz"

    files = []
    Dir['_site/**/*.html'].each do |page|
      files << File.new(page)
    end

    SitemapGenerator::Sitemap.default_host = site.config['url']
    SitemapGenerator::Sitemap.public_path = File.join(Dir.pwd, "_site")
    SitemapGenerator::Sitemap.create compress: false do
      files.each do |file|
        add file.path.sub(/^_site/,''), changefreq: 'weekly'
      end
    end

    puts "Generated sitemap.xml.gz"
  end
end
