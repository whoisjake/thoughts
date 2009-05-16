Gem::Specification.new do |s|
  s.name     = 'rack-openid'
  s.version  = '0.2'
  s.date     = '2009-05-10'
  s.summary  = 'Provides a more HTTPish API around the ruby-openid library'
  s.description = 'Rack::OpenID provides a more HTTPish API around the ruby-openid library.'
  s.email    = 'josh@joshpeek.com'
  s.homepage = 'http://github.com/josh/rack-openid'
  s.rubyforge_project = 'rack-openid'
  s.has_rdoc = true
  s.authors  = ["Joshua Peek"]
  s.files    = ["lib/rack/openid.rb"]
  s.extra_rdoc_files = %w[README.rdoc MIT-LICENSE]
  s.require_paths = %w[lib]
  s.add_dependency 'rack', '>= 0.4'
  s.add_dependency 'ruby-openid', '>=2.1.6'
end
