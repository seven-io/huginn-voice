lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "huginn_agent", "~> 0.6.1"
  spec.authors       = ["sms77 e.K."]
  spec.description   = %q{Send Text2Voice messages from Huginn via https://sms77.io.}
  spec.email         = ["support@sms77.io"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.files         = Dir['LICENSE', 'lib/**/*']
  spec.homepage      = "https://github.com/sms77io/huginn-voice"
  spec.license       = "MIT"
  spec.name          = "huginn_sms77_voice_agent"
  spec.require_paths = ["lib"]
  spec.summary       = %q{Send Text2Voice messages from Huginn via https://sms77.io.}
  spec.test_files    = Dir['spec/**/*.rb'].reject { |f| f[%r{^spec/huginn}] }
  spec.version       = '0.1.0'
end