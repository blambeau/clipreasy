require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require "rubygems"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "clipreasy.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

task :default => [:test]

desc "Lauches all tests"
Rake::TestTask.new do |test|
  test.libs       << [ "lib", "test/unit" ]
  test.test_files = ['test/unit/test_all.rb']
  test.verbose    =  true
end

gemspec = Gem::Specification.new do |s|
  s.name = 'clipreasy'
  s.version = version
  s.summary = "CliPrEasy - Clinical Processes Made Easy"
  s.description = %{A workflow engine for clinical processes}
  s.files = Dir['lib/**/*'] + Dir['test/**/*'] + Dir['bin/*']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "LICENCE.rdoc"]
  s.rdoc_options << '--title' << 'CliPrEasy - Clinical Processes Made Easy' <<
                    '--main' << 'README.rdoc' <<
                    '--line-numbers'  
  s.bindir = "bin"
  s.executables = []
  s.author = "Bernard Lambeau"
  s.email = "blambeau@gmail.com"
  s.homepage = "http://github.com/blambeau/clipreasy"
end
Rake::GemPackageTask.new(gemspec) do |pkg|
	pkg.need_tar = true
end
