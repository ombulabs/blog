task :find_dead_links do
  cmd = 'htmlproofer ./_site --only-4xx --url-ignore "/blog/,/#content/"'
  system("bundle exec #{cmd}")
end
