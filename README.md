# Domainshare

Gem for .tk DomainShare API. Basically the (pretty messy) sample code.
You can find the original code at http://www.nic.tk/en/domainsharelibs.html

## Installation

Add this line to your application's Gemfile:

    gem 'domainshare'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install domainshare

## Usage

Test connection

``
conn = DSCLIENT::API.new(username, password)
puts conn.ping()
``

Register a domain:

``
puts conn.register({"domainname" => "sld",
                    "enduseremail" => "user-email@example.com", 
                     "nameserver" => ["ns1.example.com", "ns2.example.com"] })
``

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
