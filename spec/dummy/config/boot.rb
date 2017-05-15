require 'rubygems'
require 'bundler/setup'

orm = ENV['BUNDLE_GEMFILE'].match(/Gemfile\.(.+)\.rb/)

$LOAD_PATH.unshift File.expand_path('../../../../lib', __FILE__)
