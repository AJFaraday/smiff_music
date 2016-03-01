require 'rubygems'
require 'active_support'
require 'active_support/core_ext'
require 'active_model'
require 'ostruct'
require 'yaml'
require 'logger'
require 'pathname'

require 'readline'

directory = File.dirname(__FILE__)
Dir["#{directory}/../app/helpers/*.rb"].each { |file| require file }
Dir["#{directory}/../lib/export/**/*.rb"].each { |file| require file }
Dir["#{directory}/../lib/in_memory*.rb"].each { |file| require file }
Dir["#{directory}/../app/models/*.rb"].each { |file| require file }
Dir["#{directory}/../lib/context_help/*.rb"].each { |file| require file }
Dir["#{directory}/../lib/messages/actions/*.rb"].each { |file| require file }
Dir["#{directory}/../lib/messages/*.rb"].each { |file| require file }
Dir["#{directory}/../lib/*.rb"].each { |file| require file }

I18n.load_path = Dir["#{directory}/../config/locales/**/*.yml"]
I18n.load_path += Dir["#{directory}/../config/locales/*.yml"]
I18n.backend.load_translations

# Just for CLI
require "#{directory}/../lib/command_line/readline.rb"
require "#{directory}/../lib/command_line/autocomplete.rb"
Dir["#{directory}/../lib/command_line/*.rb"].each { |file| require file }
