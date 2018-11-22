lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'carrierwave/base64/version'

Gem::Specification.new do |spec|
  spec.name          = 'carrierwave-base64'
  spec.version       = Carrierwave::Base64::VERSION
  spec.authors       = ['Yury Lebedev']
  spec.email         = ['lebedev.yurii@gmail.com']
  spec.summary       = 'Upload images encoded as base64 to carrierwave.'
  spec.description   = 'This gem can be useful, if you need to upload files '\
                       'to your API from mobile devises.'
  spec.homepage      = 'https://github.com/lebedev-yury/carrierwave-base64'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'carrierwave', '>= 0.8.0'
  spec.add_dependency 'mime-types', '~> 3.0'
  spec.add_dependency 'mimemagic', '~> 0.3.2'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'carrierwave-mongoid'
  spec.add_development_dependency 'mongoid'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rails', '~> 5'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'sham_rack'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'yard'
end
