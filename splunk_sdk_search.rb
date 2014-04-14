#!/usr/bin/ruby
require 'rubygems'
require 'splunk-sdk-ruby'
require 'highline/import'
 
user = ask("Enter your username:  ") { |q| q.echo = true }
pass = ask("Enter your password:  ") { |q| q.echo = false }
app = ask("Using XXXX or YYYY (XXXX|YYY)(XXXX)") {|q| q.echo = true}
 
config = {
:host=>"10.0.0.1", 
:port=>"8089", 
:username=>user, 
:password=>pass, 
:app =>app
}
 
service = Splunk::connect(config)
service.connect
connections_ok = service.server_accepting_connections?
puts "Digite sua pesquisa"
search_query = gets.to_s
first_search = service.create_search(search_query)
while !first_search.is_done?()
  sleep(0.20)
end
stream = first_search.results
results = Splunk::ResultsReader.new(stream)
results.each do |result|
  puts result["_raw"]
end

