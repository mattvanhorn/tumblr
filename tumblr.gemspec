Gem::Specification.new do |s|
  s.name = "tumblr"
  s.version = "0.0.1"
  s.date = "2008-12-15"
  s.rubyforge_project = 'tumblr'
  s.summary = "Allows your Ruby-powered site to use the Tumblr API"
  s.email = 'mattvanhorn@gmail.com'
  s.homepage = ''
  s.description = 'Allows your Ruby-powered site to use the Tumblr API'
  s.has_rdoc = true
  s.authors = ['Matt Van Horn']
  s.files = [
    "init.rb",
    "lib/tumblr/api.rb",
    "lib/tumblr/post.rb",
    "lib/tumblr.rb",
    "README.rdoc",
    "Rakefile"
  ]
  s.test_files = [
    "spec/spec_helper.rb",
    "spec/api_spec.rb",
    "spec/responses/read.xml"
  ]
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--line-numbers"]
end

