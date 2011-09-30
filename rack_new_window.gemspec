Gem::Specification.new do |s|

  s.name        = "rack_new_window"
  s.version     = '0.0.2'
  s.authors     = ['Eric Anderson']
  s.email       = ['eric@pixelwareinc.com']

  s.add_dependency 'rack'
  s.add_dependency 'rack_replace'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'ruby-debug'

  s.files = Dir['lib/**/*.rb']
  s.extra_rdoc_files << 'README.rdoc'
  s.rdoc_options << '--main' << 'README.rdoc'

  s.summary     = 'All external and non-HTML links open in a new window'
  s.description = <<DESCRIPTION
Will make all external and non-HTML links open in a new window. Options
allow you define sites that should be considered internal.
DESCRIPTION

end
