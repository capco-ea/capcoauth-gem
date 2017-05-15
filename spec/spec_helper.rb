# $LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '../lib'))
# $LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '../app'))

require 'simplecov'
SimpleCov.start 'rails'

require 'rails'
require 'capcoauth'
