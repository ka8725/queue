# encoding: UTF-8
require 'rake/testtask'

desc 'Default: run unit tests'
task :default => :test

desc 'Test the application'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
