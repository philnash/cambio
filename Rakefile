#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList['spec/*_spec.rb','spec/cambio/*_spec.rb']
  t.verbose = true
end
task :spec => :test
task :default => :test