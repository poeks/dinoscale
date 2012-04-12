RUBY_VERSION[0..2] == '1.9' ? Encoding.default_internal = 'UTF-8' : $KCODE = "u"
require "rubygems"
require "bundler"
Bundler.setup
Bundler.require :default

root = File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..')