# frozen_string_literal: true

require "rake/clean"
require "rake/manifest/task"
require "bundler/gem_tasks"

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new do |spec|
  spec.ruby_opts = ["-w"]
  spec.rspec_opts = "-c --format d"
end

Rake::Manifest::Task.new do |t|
  t.patterns = ["{lib}/**/*", "License", "*.md"]
end

task build: ["manifest:check"]
task default: [:spec, "manifest:check"]
