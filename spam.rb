require 'yaml'
require "net/http"
require "uri"
require "csv"

@user = ''
@password = ''

def send_an_email( from, to, subject, body, bcc = '' )
  data = <<-eos
From: #{from}
To: #{to}
Bcc: #{bcc}
Reply-to: #{from}
Subject: #{subject}
#{body}
eos
  
  uri = URI.parse("http://www.wikiposit.org/05/dev/sendmail.pl?tammer")
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.basic_auth(@user, @password)
  request.body = data
  response = http.request(request)
  response.body

end

def load_list( file )
  rv = []
  CSV.foreach(file) do |row|
    row.map! { |item| item.strip }
    next if row[0] =~ /^#/
    row << '' if row.size == 1
    rv << row
  end
  rv
end

file_name = ARGV[0]
spec = YAML::load( File.open( file_name ) )

required = %w[subject from body file]

required.each do |r|
  if spec[r].nil?
    puts "Error.  Spec file (#{ARGV[0]}) is missing '#{r}' field"
    exit
  end
end

@user = spec['user']
@password = spec['password']

list = load_list( spec['file'] )

puts "Type in the email address to send a test message to:"

test_address = STDIN.gets.chomp

send_an_email(spec['from'], test_address, spec['subject'], spec['body'].gsub("$name",list[0][1]), spec['bcc'])

puts "Test email sent to #{test_address}, using the name of the first person in #{spec['file']}.\nType 'YES' to proceed to send to #{list.size} email addresses."

answer = STDIN.gets.chomp

exit if answer != "YES"

list.each do |row|
  send_an_email(spec['from'], row[0], spec['subject'], spec['body'].gsub("$name",row[1]))
  puts row[0]
end


