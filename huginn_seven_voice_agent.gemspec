lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "huginn_agent", "~> 0.6.1"
  spec.authors       = ["seven communications GmbH & Co. KG"]
  spec.description   = %q{Send Text2Voice messages from Huginn via https://www.seven.io.}
  spec.email         = ["support@seven.io"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.files         = Dir['LICENSE', 'lib/**/*']
  spec.homepage      = "https://github.com/seven-io/huginn-voice"
  spec.license       = "MIT"
  spec.name          = "huginn_seven_voice_agent"
  spec.require_paths = ["lib"]
  spec.summary       = %q{Send Text2Voice messages from Huginn via https://www.seven.io.}
  spec.test_files    = Dir['spec/**/*.rb'].reject { |f| f[%r{^spec/huginn}] }
  spec.version       = '0.1.0'
end