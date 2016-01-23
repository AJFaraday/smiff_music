require 'rubygems'
require 'active_support'
require 'active_model'
require 'ostruct'

directory = File.dirname(__FILE__)
Dir["#{directory}/../lib/in_memory*.rb"].each { |file| require file }
Dir["#{directory}/../app/models/*.rb"].each { |file| require file }
Dir["#{directory}/../app/helpers/*.rb"].each { |file| require file }
Dir["#{directory}/../lib/context_help/*.rb"].each { |file| require file }
Dir["#{directory}/../lib/messages/actions/*.rb"].each { |file| require file }
Dir["#{directory}/../lib/messages/*.rb"].each { |file| require file }
Dir["#{directory}/../lib/*.rb"].each { |file| require file }

