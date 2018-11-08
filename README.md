# The Ultimate Guide to Ruby Timeouts

An unresponsive service can be worse than a down one. It can tie up your entire system if not handled properly. **All network requests should have a timeout.**

Here’s how to add timeouts for popular Ruby gems. **[All have been tested](test)**. You should [avoid Ruby’s `Timeout` module](https://www.mikeperham.com/2015/05/08/timeout-rubys-most-dangerous-api/). The default is no timeout, unless otherwise specified. Enjoy!

[![Build Status](https://travis-ci.org/ankane/the-ultimate-guide-to-ruby-timeouts.svg?branch=master)](https://travis-ci.org/ankane/the-ultimate-guide-to-ruby-timeouts)

## Timeout Types

- **connect (or open)** - time to open the connection
- **read (or receive)** - time to receive data after connected
- **write (or send)** - time to send data after connected
- **checkout** - time to checkout a connection from the pool
- **statement** - time to execute a database statement

## Statement Timeouts

For many apps, the *single most important thing* to do (if you use a relational database)

- [PostgreSQL](#postgresql)
- [MySQL](#mysql)
- [MariaDB](#mariadb)

## Gems

Data Stores

- [activerecord](#activerecord)
- [bunny](#bunny)
- [cassandra-driver](#cassandra-driver)
- [connection_pool](#connection_pool)
- [couchrest](#couchrest)
- [dalli](#dalli)
- [drill-sergeant](#drill-sergeant)
- [elasticsearch](#elasticsearch)
- [hiredis](#hiredis)
- [influxdb](#influxdb)
- [mongo](#mongo)
- [mongoid](#mongoid)
- [mysql2](#mysql2)
- [neo4j](#neo4j)
- [pg](#pg)
- [presto-client](#presto-client)
- [redis](#redis)
- [rsolr](#rsolr)
- [ruby-druid](#ruby-druid)
- [ruby-kafka](#ruby-kafka)
- [searchkick](#searchkick)
- [sequel](#sequel)

HTTP Clients

- [curb](#curb)
- [em-http-client](#em-http-client)
- [excon](#excon)
- [faraday](#faraday)
- [http](#http)
- [httparty](#httparty)
- [httpclient](#httpclient)
- [httpi](#httpi)
- [net/http](#nethttp)
- [open-uri](#open-uri)
- [patron](#patron)
- [rest-client](#rest-client)
- [typhoeus](#typhoeus)
- [unirest](#unirest)

Web Servers

- [puma](#puma)
- [unicorn](#unicorn)

Rack Middleware

- [rack-timeout](#rack-timeout)
- [slowpoke](#slowpoke)

3rd Party Services

- [aws-sdk](#aws-sdk)
- [azure](#azure)
- [bitly](#bitly)
- [checkr-official](#checkr-official)
- [coinbase](#coinbase)
- [dogapi](#dogapi)
- [droplet_kit](#droplet_kit)
- [fastly](#fastly)
- [firebase](#firebase)
- [flickraw](#flickraw)
- [gibbon](#gibbon)
- [github_api](#github_api)
- [google-cloud](#google-cloud)
- [hipchat](#hipchat)
- [koala](#koala)
- [octokit](#octokit)
- [pwned](#pwned)
- [restforce](#restforce)
- [shopify_api](#shopify_api)
- [slack-notifier](#slack-notifier)
- [slack-ruby-client](#slack-ruby-client)
- [sift](#sift)
- [smartystreets_ruby_sdk](#smartystreets_ruby_sdk)
- [soda-ruby](#soda-ruby)
- [stripe](#stripe)
- [tamber](#tamber)
- [twilio-ruby](#twilio-ruby)
- [twitter](#twitter)
- [yt](#yt)
- [zendesk_api](#zendesk_api)

Other

- [acme-client](#acme-client)
- [actionmailer](#actionmailer)
- [activemerchant](#activemerchant)
- [activeresource](#activeresource)
- [active_shipping](#active_shipping)
- [docker-api](#docker-api)
- [fastimage](#fastimage)
- [geocoder](#geocoder)
- [graphql-client](#graphql-client)
- [grpc](#grpc)
- [kubeclient](#kubeclient)
- [mail](#mail)
- [mechanize](#mechanize)
- [nats-pure](#nats-pure)
- [net-dns](#net-dns)
- [net/ftp](#netftp)
- [net-ldap](#net-ldap)
- [net-ntp](#net-ntp)
- [net-scp](#net-scp)
- [net-sftp](#net-sftp)
- [net/smtp](#netsmtp)
- [net-ssh](#net-ssh)
- [net-telnet](#net-telnet)
- [omniauth-oauth2](#omniauth-oauth2)
- [reversed](#reversed)
- [savon](#savon)
- [socket](#socket)
- [spidr](#spidr)
- [spyke](#spyke)
- [stomp](#stomp)
- [vault](#vault)
- [zk](#zk)
- [zookeeper](#zookeeper)

## Statement Timeouts

Prevent single queries from taking up all of your database’s resources.

### PostgreSQL

If you use Rails, add to your `config/database.yml`

```yml
production:
  variables:
    statement_timeout: 250 # ms
```

or set it on your database role

```sql
ALTER ROLE myuser SET statement_timeout = 250;
```

Test with

```sql
SELECT pg_sleep(5);
```

To set for a single transaction, use

```sql
BEGIN;
SET LOCAL statement_timeout = 250;
...
COMMIT;
```

### MySQL

**Note:** Requires MySQL 5.7.8 or higher

If you use Rails, add to your `config/database.yml`

```yml
production:
  variables:
    max_execution_time: 250 # ms
```

or set it directly on each connection

```sql
SET SESSION max_execution_time = 250;
```

Test with

```sql
SELECT 1 FROM information_schema.tables WHERE sleep(5);
```

To set for a single statement, use an [optimizer hint](https://dev.mysql.com/doc/refman/5.7/en/optimizer-hints.html#optimizer-hints-execution-time)

```sql
SELECT /*+ MAX_EXECUTION_TIME(250) */ ...
```

### MariaDB

**Note:** Requires MariaDB 10.1.1 or higher

If you use Rails, add to your `config/database.yml`

```yml
production:
  variables:
    max_statement_time: 1 # sec
```

or set it directly on each connection

```sql
SET SESSION max_statement_time = 1;
```

Test with

```sql
SELECT 1 FROM information_schema.tables WHERE sleep(5);
```

As of MariaDB 10.1.2, you can set single statement timeouts with

```sql
SET STATEMENT max_statement_time=1 FOR
  SELECT ...
```

[Official docs](https://mariadb.com/kb/en/mariadb/aborting-statements/)

## Data Stores

### activerecord

- #### postgres adapter

  ```ruby
  ActiveRecord::Base.establish_connection(connect_timeout: 1, checkout_timeout: 1, ...)
  ```

  or in `config/database.yml`

  ```yaml
  production:
    connect_timeout: 2
    checkout_timeout: 1
  ```

  Raises

  - `PG::ConnectionBad` on connect and read timeouts
  - `ActiveRecord::ConnectionTimeoutError` on checkout timeout

  See also [PostgreSQL statement timeouts](#postgresql)

- #### mysql2 adapter

  ```ruby
  ActiveRecord::Base.establish_connection(connect_timeout: 1, read_timeout: 1, write_timeout: 1, checkout_timeout: 1, ...)
  ```

  or in `config/database.yml`

  ```yaml
  production:
    connect_timeout: 1
    read_timeout: 1
    write_timeout: 1
    checkout_timeout: 1
  ```

  Raises

  - `Mysql2::Error` on connect and read timeouts
  - `ActiveRecord::ConnectionTimeoutError` on checkout timeout

  See also [MySQL statement timeouts](#mysql)

### bunny

```ruby
Bunny.new(connection_timeout: 1, read_timeout: 1, ...)
```

Raises

- `Bunny::TCPConnectionFailedForAllHosts` on connect timeout
- `Bunny::NetworkFailure` on read timeout

### cassandra-driver

```ruby
Cassandra.cluster(connect_timeout: 1, timeout: 1)
```

Default: 10s connect timeout, 12s read timeout

Raises

- `Cassandra::Errors::NoHostsAvailable` on connect timeout
- `Cassandra::Errors::TimeoutError` on read timeout

### connection_pool

```ruby
ConnectionPool.new(timeout: 1) { ... }
```

Raises `Timeout::Error`

### couchrest

```ruby
CouchRest.new(url, open_timeout: 1, read_timeout: 1, timeout: 1)
```

Raises

- `HTTPClient::ConnectTimeoutError` on connect timeout
- `HTTPClient::ReceiveTimeoutError` on read timeout

### dalli

```ruby
Dalli::Client.new(host, socket_timeout: 1, ...)
```

Default: 0.5s

Raises `Dalli::RingError`

### drill-sergeant

```ruby
Drill.new(url: url, open_timeout: 1, read_timeout: 1)
```

Default: 3s connect timeout, no read timeout

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### elasticsearch

```ruby
Elasticsearch::Client.new(transport_options: {request: {timeout: 1}}, ...)
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### hiredis

```ruby
conn = Hiredis::Connection.new
conn.timeout = 1_000_000 # microseconds
```

Raises

- `Errno::ETIMEDOUT` on connect timeout
- `Errno::EAGAIN` on read timeout

### influxdb

```ruby
InfluxDB::Client.new(open_timeout: 1, read_timeout: 1)
```

Raises `InfluxDB::ConnectionError`

### mongo

```ruby
Mongo::Client.new([host], connect_timeout: 1, socket_timeout: 1, server_selection_timeout: 1, ...)
```

Raises `Mongo::Error::NoServerAvailable`

### mongoid

```yml
production:
  clients:
    default:
      options:
        connect_timeout: 1
        socket_timeout: 1
        server_selection_timeout: 1
```

Raises `Mongo::Error::NoServerAvailable`

### mysql2

```ruby
Mysql2::Client.new(connect_timeout: 1, read_timeout: 1, write_timeout: 1, ...)
```

Raises `Mysql2::Error`

### neo4j

```ruby
config.neo4j.session.options = {
  faraday_configurator: lambda do |faraday|
    faraday.adapter :typhoeus
    faraday.options[:open_timeout] = 5
    faraday.options[:timeout] = 65
  end
}
```

Raises `Faraday::TimeoutError`

### pg

```ruby
PG.connect(connect_timeout: 1, ...)
```

Raises `PG::ConnectionBad`

### presto-client

```ruby
Presto::Client.new(http_open_timeout: 1, http_timeout: 1)
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### redis

```ruby
Redis.new(connect_timeout: 1, timeout: 1, ...)
```

Default: 5s

Raises

- `Redis::CannotConnectError` on connect timeout
- `Redis::TimeoutError` on read timeout

### rsolr

```ruby
RSolr.connect(open_timeout: 1, read_timeout: 1)
```

Raises

- `RSolr::Error::ConnectionRefused` on connect timeout
- `RSolr::Error::Http` on read timeout

### ruby-druid

Not configurable at the moment

Default: 10s connect timeout, no read timeout

### ruby-kafka

```ruby
Kafka.new(connect_timeout: 1, socket_timeout: 1)
```

Raises `Kafka::ConnectionError`

### searchkick

```ruby
Searchkick.timeout = 1
Searchkick.search_timeout = 1
```

Default: 10s

Raises same exceptions as [elasticsearch](#elasticsearch)

### sequel

- #### postgres adapter

  ```ruby
  Sequel.connect(connect_timeout: 1, pool_timeout: 1, ...)
  ```

  - `Sequel::DatabaseConnectionError` on connect and read timeouts
  - `Sequel::PoolTimeout` on checkout timeout

- #### mysql2 adapter

  ```ruby
  Sequel.connect(timeout: 1, read_timeout: 1, connect_timeout: 1, pool_timeout: 1, ...)
  ```

  Raises

  - `Sequel::DatabaseConnectionError` on connect and read timeouts
  - `Sequel::PoolTimeout` on checkout timeout

## HTTP Clients

### curb

```ruby
curl = Curl::Easy.new(url)
curl.connect_timeout = 1
curl.timeout = 1
curl.perform
```

Raises `Curl::Err::TimeoutError`

### em-http-client

```ruby
EventMachine.run do
  http = EventMachine::HttpRequest.new(url, connect_timeout: 1, inactivity_timeout: 1).get
  http.errback  { http.error }
end
```

No exception is raised, but `http.error` is set to `Errno::ETIMEDOUT` in `http.errback`.

### excon

```ruby
Excon.get(url, connect_timeout: 1, read_timeout: 1, write_timeout: 1)
```

Raises `Excon::Errors::Timeout`

### faraday

```ruby
Faraday.get(url) do |req|
  req.options.open_timeout = 1
  req.options.timeout = 1
end
```

or

```ruby
Faraday.new(url, request: {open_timeout: 1, timeout: 1}) do |faraday|
  # ...
end
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### http

```ruby
HTTP.timeout(connect: 1, read: 1, write: 1).get(url)
```

Raises `HTTP::TimeoutError`

### httparty

```ruby
HTTParty.get(url, timeout: 1)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### httpclient

```ruby
client = HTTPClient.new
client.connect_timeout = 1
client.receive_timeout = 1
client.send_timeout = 1
client.get(url)
```

Raises

- `HTTPClient::ConnectTimeoutError` on connect timeout
- `HTTPClient::ReceiveTimeoutError` on read timeout

### httpi

```ruby
HTTPI::Request.new(url: url, open_timeout: 1)
```

Raises same errors as underlying client

### net/http

```ruby
Net::HTTP.start(host, port, open_timeout: 1, read_timeout: 1) do
  # ...
end
```

or

```ruby
http = Net::HTTP.new(host, port)
http.open_timeout = 1
http.read_timeout = 1
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

Default: 60s connect timeout ([Ruby 2.3+](https://github.com/ruby/ruby/commit/52e1c3b0ab41041f7f51a7afc3fce3aab97bc010)), 60s read timeout

Write timeout is infinite, presently [can't be set](https://bugs.ruby-lang.org/issues/13396).

**Note:** Read timeouts are [retried automatically](https://github.com/ruby/ruby/blob/v2_2_4/lib/net/http.rb#L1436)

### open-uri

```ruby
open(url, open_timeout: 1, read_timeout: 1)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

Note that open-uri didn't support (and so didn't pass to underlying net/http) the `:open_timeout` argument [until Ruby 2.2](https://bugs.ruby-lang.org/issues/10361).

### patron

```ruby
sess = Patron::Session.new
sess.connect_timeout = 1
sess.timeout = 1
```

Raises `Patron::TimeoutError`

### rest-client

```ruby
RestClient::Request.execute(method: :get, url: url, open_timeout: 1, read_timeout: 1)

# shorthand to set open_timeout = read_timeout = 1
RestClient::Request.execute(method: :get, url: url, timeout: 1)
```

Same options also work with `RestClient::Resource`.

Raises

- `RestClient::Exceptions::OpenTimeout` on connect timeout
- `RestClient::Exceptions::ReadTimeout` on read timeout

Default: 60s connect timeout (Ruby 2.3+), 60s read timeout

### typhoeus

```ruby
response = Typhoeus.get(url, connecttimeout: 1, timeout: 1)
```

No exception is raised. Check for a timeout with

```ruby
response.timed_out?
```

### unirest

```ruby
Unirest.timeout(1)
```

Connect timeout is not configurable

Default: 10s read timeout, no connect timeout

Raises `RuntimeError`

## Web Servers

### puma

```ruby
# config/puma.rb
worker_timeout 15
```

Default: 30s

This kills and respawns the worker process. Note that this is for the worker and not threads. This isn’t a [request timeout](https://github.com/puma/puma/issues/160) either. Use [Rack middleware](#rack-middleware) for request timeouts.

```ruby
# config/puma.rb
worker_shutdown_timeout 8
```

Default: 60s

This causes Puma to send a SIGKILL signal to a worker if it hasn’t shutdown within the specified time period after having received a SIGTERM signal.

### unicorn

```ruby
# config/unicorn.rb
timeout 15
```

Default: 60s

This kills and respawns the worker process.

It’s recommended to use this in addition to [Rack middleware](#rack-middleware).

## Rack Middleware

### rack-timeout

```ruby
Rack::Timeout.timeout = 5
Rack::Timeout.wait_timeout = 5
```

Default: 15s service timeout, 30s wait timeout

Raises `Rack::Timeout::RequestTimeoutError` or `Rack::Timeout::RequestExpiryError`

[Read more here](https://github.com/heroku/rack-timeout#the-rabbit-hole)

**Note:** The approach used by Rack::Timeout can leave your application in an inconsistent state, [as described here](https://github.com/heroku/rack-timeout/blob/master/doc/risks.md)

### slowpoke

```ruby
Slowpoke.timeout = 5
```

Default: 15s

Raises same exceptions as [rack-timeout](#rack-timeout)

## 3rd Party Services

### aws-sdk

```ruby
Aws.config = {
  http_open_timeout: 1,
  http_read_timeout: 1
}
```

Or with a client

```ruby
Aws::S3::Client.new(
  http_open_timeout: 1,
  http_read_timeout: 1
)
```

Raises `Seahorse::Client::NetworkingError`

### azure

Not configurable at the moment, and no timeout by default

### bitly

```ruby
Bitly.new(username, api_key, timeout)
```

Raises `BitlyTimeout`

### checkr-official

Default: 30s connect timeout, 60s read timeout

Not configurable at the moment

### coinbase

Not configurable at the moment

### dogapi

```ruby
timeout = 1
Dogapi::Client.new(api_key, nil, nil, nil, false, timeout)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### droplet_kit

[Not configurable at the moment](https://github.com/digitalocean/droplet_kit/pull/144), and no timeout by default

### fastly

Not configurable at the moment, and no timeout by default

### firebase

```ruby
firebase = Firebase::Client.new(url)
firebase.request.connect_timeout = 1
firebase.request.receive_timeout = 1
firebase.request.send_timeout = 1
```

Raises

- `HTTPClient::ConnectTimeoutError` on connect timeout
- `HTTPClient::ReceiveTimeoutError` on read timeout

### flickraw

Not configurable at the moment

### gibbon

```ruby
Gibbon::Request.new(open_timeout: 1, timeout: 1, ...)
```

Raises `Gibbon::MailChimpError`

### github_api

```ruby
Github.new(connection_options: {request: {open_timeout: 1, timeout: 1}})
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### google-cloud

```ruby
Google::Cloud::Storage.new(timeout: 1)
```

Raises `Google::Cloud::Error`

### hipchat

```ruby
[HipChat::Client, HipChat::Room, HipChat::User].each { |c| c.default_timeout(1) }
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### koala

```ruby
Koala.http_service.http_options = {request: {open_timeout: 1, timeout: 1}}
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### octokit

```ruby
Octokit::Client.new(connection_options: {request: {open_timeout: 1, timeout: 1}})
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### pwned

```ruby
Pwned::Password.new("password", open_timeout: 1, read_timeout: 1)
```

Raises `Pwned::TimeoutError`

### restforce

```ruby
Restforce.new(timeout: 1)
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### shopify_api

```ruby
ShopifyAPI::Base.timeout = 1
```

Raises `ActiveResource::TimeoutError`

### slack-notifier

```ruby
Slack::Notifier.new(webhook_url, http_options: {open_timeout: 1, read_timeout: 1})
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### slack-ruby-client

```ruby
Slack::Web::Client.new(open_timeout: 1, timeout: 1)
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### sift

```ruby
Sift::Client.new(timeout: 1)
```

Default: 2s

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### smartystreets_ruby_sdk

```ruby
SmartyStreets::ClientBuilder.new(credentials).with_max_timeout(1)
```

Connect timeout is not configurable at the moment

Raises `Net::ReadTimeout` on read timeout

### soda-ruby

```ruby
SODA::Client.new(timeout: 1)
```

Connect timeout is not configurable at the moment

Raises `Net::ReadTimeout` on read timeout

### stripe

```ruby
Stripe.open_timeout = 1
Stripe.read_timeout = 1
```

Default: 30s connect timeout, 80s read timeout

Raises `Stripe::APIConnectionError`

### tamber

```ruby
Tamber.open_timeout = 1
Tamber.read_timeout = 1
```

Raises `Tamber::NetworkError`

### twilio-ruby

```ruby
http_client = Twilio::HTTP::Client.new(timeout: 1)
Twilio::REST::Client.new(account_sid, auth_token, nil, nil, http_client)
```

Default: 30s

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### twitter

```ruby
Twitter::REST::Client.new do |config|
  config.timeouts = {connect: 1, read: 1, write: 1}
end
```

Raises `HTTP::TimeoutError`

### yt

Not configurable at the moment, and no timeout by default

### zendesk_api

```ruby
ZendeskAPI::Client.new do |config|
  config.client_options = {request: {open_timeout: 1, timeout: 1}}
end
```

Default: 10s connect timeout, no read timeout

Raises `ZendeskAPI::Error::NetworkError`

## Other

### acme-client

```ruby
Acme::Client.new(connection_options: {request: {open_timeout: 1, timeout: 1}})
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### actionmailer

```ruby
ActionMailer::Base.smtp_settings = {
  open_timeout: 1,
  read_timeout: 1
}
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### activemerchant

```ruby
ActiveMerchant::Billing::Gateway.open_timeout = 1
ActiveMerchant::Billing::Gateway.read_timeout = 1
```

Default: 60s

Raises `ActiveMerchant::ConnectionError`

### activeresource

```ruby
class Person < ActiveResource::Base
  self.open_timeout = 1
  self.read_timeout = 1
end
```

Raises `ActiveResource::TimeoutError`

### active_shipping

```ruby
client = ActiveShipping::USPS.new(login: "developer-key")
client.open_timeout = 1
client.read_timeout = 1
```

Default: 2s connect timeout, 10s read timeout

Raises `ActiveUtils::ConnectionError`

### docker-api

```ruby
Docker.options = {
  read_timeout: 1
}
```

Connect timeout not configurable

Raises `Docker::Error::TimeoutError`

### fastimage

```ruby
FastImage.size(url, timeout: 1)
```

Returns `nil` on timeouts

If you pass `raise_on_failure: true`, raises `FastImage::ImageFetchFailure`

### geocoder

```ruby
Geocoder.configure(timeout: 1, ...)
```

No exception is raised by default. To raise exceptions, use

```ruby
Geocoder.configure(timeout: 1, always_raise: :all, ...)
```

Raises `Geocoder::LookupTimeout`

### graphql-client

```ruby
GraphQL::Client::HTTP.new(url) do
  def connection
    conn = super
    conn.open_timeout = 1
    conn.read_timeout = 1
    conn
  end
end
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### grpc

```ruby
RouteGuide::Stub.new(addr, :this_channel_is_insecure, timeout: 1)
```

Raises `GRPC::DeadlineExceeded`

### kubeclient

```ruby
Kubeclient::Client.new(url, timeouts: {open: 1, read: 1})
```

Raises `KubeException`

Default: 60s connect timeout (Ruby 2.3+), 60s read timeout

### mail

```ruby
Mail.defaults do
  delivery_method :smtp, open_timeout: 1, read_timeout: 1
end
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### mechanize

```ruby
agent = Mechanize.new
agent.open_timeout = 1
agent.read_timeout = 1
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::HTTP::Persistent::Error` on read timeout

### nats-pure

```ruby
nats = NATS::IO::Client.new
nats.connect(connect_timeout: 1)
```

Raises `NATS::IO::SocketTimeoutError`

### net-dns

```ruby
Net::DNS::Resolver.new(udp_timeout: 1)
```

Default: 5s

Raises `Net::DNS::Resolver::NoResponseError`

### net/ftp

```ruby
Net::FTP.new(host, open_timeout: 1, read_timeout: 1)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### net/ldap

```ruby
Net::LDAP.new(host: host, connect_timeout: 1)
```

Read timeout [not configurable at the moment](https://github.com/ruby-ldap/ruby-net-ldap/pull/167)

Default: 5s connect timeout, no read timeout

Raises `Net::LDAP::Error`

### net-ntp

```ruby
timeout = 1
Net::NTP.get(host, port, timeout)
```

Raises `Timeout::Error`

### net-scp

```ruby
Net::SCP.start(host, user, timeout: 1)
```

Raises `Net::SSH::ConnectionTimeout`

### net-sftp

```ruby
Net::SFTP.start(host, user, timeout: 1)
```

Raises `Net::SSH::ConnectionTimeout`

### net/smtp

```ruby
smtp = Net::SMTP.new(host, 25)
smtp.open_timeout = 1
smtp.read_timeout = 1
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### net-ssh

```ruby
Net::SSH.start(host, user, timeout: 1)
```

Raises `Net::SSH::ConnectionTimeout`

### net-telnet

```ruby
Net::Telnet::new("Host" => host, "Timeout" => 1)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### omniauth-oauth2

[Not configurable at the moment](https://github.com/intridea/omniauth-oauth2/issues/27), and no timeout by default

### reversed

```ruby
Reversed.lookup("8.8.8.8", timeout: 1)
```

Returns `nil` on timeouts

### savon

```ruby
Savon.client(wsdl: url, open_timeout: 1, read_timeout: 1)
```

Raises

- `HTTPClient::ConnectTimeoutError` on connect timeout
- `HTTPClient::ReceiveTimeoutError` on read timeout

### socket

```ruby
Socket.tcp(host, 80, connect_timeout: 1) do |sock|
  # ...
end
```

Raises `Errno::ETIMEDOUT`

### spydr

```ruby
Spidr.open_timeout = 1
Spidr.read_timeout = 1
```

No exception is raised. Check for failures with

```ruby
agent = Spidr.site(url)
agent.failures
```

### spyke

```ruby
Spyke::Base.connection = Faraday.new(url: url) do |c|
  c.adapter Faraday.default_adapter
  c.options[:open_timeout] = 1
  c.options[:timeout] = 1
end
```

Raises `Spyke::ConnectionError`

### stomp

```ruby
Stomp::Client.new(start_timeout: 1, connect_timeout: 1, connread_timeout: 1, parse_timeout: 1)
```

Raises

- `Stomp::Error::StartTimeoutException` on connect timeout
- `Stomp::Error::ReceiveTimeout` on read timeout

### vault

```ruby
Vault.configure do |config|
  config.timeout = 1

  # or more granular
  config.ssl_timeout  = 1
  config.open_timeout = 1
  config.read_timeout = 1
end
```

Raises `Vault::HTTPConnectionError`

### zk

[Not configurable at the moment](https://github.com/zk-ruby/zk/issues/87)

Default: 30s

Raises `Zookeeper::Exceptions::ContinuationTimeoutError`

### zookeeper

[Not configurable at the moment](https://github.com/zk-ruby/zookeeper/issues/38)

Default: 30s

Raises `Zookeeper::Exceptions::ContinuationTimeoutError`

## Don’t see a library you use?

[Let us know](https://github.com/ankane/ruby-timeouts/issues/new). Even better, [create a pull request](https://github.com/ankane/ruby-timeouts/pulls) for it.

## Rescuing Exceptions

Take advantage of inheritance. Instead of

```ruby
rescue Net::OpenTimeout, Net::ReadTimeout
```

you can do

```ruby
rescue Timeout::Error
```

Use

- `Timeout::Error` for both `Net::OpenTimeout` and `Net::ReadTimeout`
- `Faraday::ClientError` for both `Faraday::ConnectionFailed` and `Faraday::TimeoutError`
- `HTTPClient::TimeoutError` for both `HTTPClient::ConnectTimeoutError` and `HTTPClient::ReceiveTimeoutError`
- `Redis::BaseConnectionError` for both `Redis::CannotConnectError` and `Redis::TimeoutError`
- `Rack::Timeout::Error` for both `Rack::Timeout::RequestTimeoutError` and `Rack::Timeout::RequestExpiryError`
- `RestClient::Exceptions::Timeout` for both `RestClient::Exceptions::OpenTimeout` and `RestClient::Exceptions::ReadTimeout`


## Existing Services

Adding timeouts to existing services can be a daunting task, but there’s a low risk way to do it.

1. Select a timeout - say 5 seconds
2. Log instances exceeding the proposed timeout
3. Fix them
4. Add the timeout
5. Repeat this process with a lower timeout, until your target timeout is achieved

## Running the Tests

```sh
git clone https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts.git
cd the-ultimate-guide-to-ruby-timeouts
bundle install
node test/server.js
```

To run all tests, use:

```sh
bundle exec rake
```

To run individual tests, use:

```sh
ruby test/faraday_test.rb
```

## And lastly...

> Because time is not going to go backwards, I think I better stop now. - Stephen Hawking

:clock4:
