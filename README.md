# The Ultimate Guide to Ruby Timeouts

An unresponsive service can be worse than a down one. It can tie up your entire system if not handled properly. **All network requests should have a timeout.**

Here’s how to add timeouts for popular Ruby gems. **[All have been tested](test)**. You should [avoid Ruby’s `Timeout` module](https://www.mikeperham.com/2015/05/08/timeout-rubys-most-dangerous-api/). The default is no timeout, unless otherwise specified. Enjoy!

Also available for [Python](https://github.com/ankane/python-timeouts), [Node](https://github.com/ankane/node-timeouts), [Go](https://github.com/ankane/go-timeouts), [PHP](https://github.com/ankane/php-timeouts), and [Rust](https://github.com/ankane/rust-timeouts)

[![Build Status](https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts/actions/workflows/build.yml/badge.svg)](https://github.com/ankane/the-ultimate-guide-to-ruby-timeouts/actions)

## Timeout Types

- **connect (or open)** - time to open the connection
- **read (or receive)** - time to receive data after connected
- **write (or send)** - time to send data after connected
- **checkout** - time to checkout a connection from the pool
- **statement** - time to execute a database statement
- **lock (or acquisition)** - time to acquire a lock
- **request (or service)** - time to process a request
- **wait** - time to start processing a queued request
- **command** - time to run a command
- **solve** - time to solve an optimization problem

## Statement Timeouts

For many apps, the *single most important thing* to do (if you use a relational database)

- [PostgreSQL](#postgresql)
- [MySQL](#mysql)
- [MariaDB](#mariadb)

## Gems

Standard Library

- [io](#io)
- [net/ftp](#netftp)
- [net/http](#nethttp)
- [net/imap](#netimap)
- [net/pop](#netpop)
- [net/smtp](#netsmtp)
- [open-uri](#open-uri)
- [regexp](#regexp)

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
- [immudb](#immudb)
- [influxdb](#influxdb)
- [influxdb-client](#influxdb-client)
- [meilisearch](#meilisearch)
- [mongo](#mongo)
- [mongoid](#mongoid)
- [mysql2](#mysql2)
- [neo4j](#neo4j)
- [pg](#pg)
- [presto-client](#presto-client)
- [redis](#redis)
- [redis-client](#redis-client)
- [riddle](#riddle)
- [rsolr](#rsolr)
- [ruby-druid](#ruby-druid)
- [ruby-kafka](#ruby-kafka)
- [searchkick](#searchkick)
- [sequel](#sequel)
- [trino-client](#trino-client)
- [typesense](#typesense)

HTTP Clients

- [curb](#curb)
- [down](#down)
- [em-http-client](#em-http-client)
- [excon](#excon)
- [faraday](#faraday)
- [http](#http)
- [httparty](#httparty)
- [httpclient](#httpclient)
- [httpi](#httpi)
- [patron](#patron)
- [rest-client](#rest-client)
- [typhoeus](#typhoeus)
- [unirest](#unirest)

Commands

- [frontkick](#frontkick)
- [mixlib-shellout](#mixlib-shellout)
- [posix-spawn](#posix-spawn)
- [tty-command](#tty-command)

Web Servers

- [puma](#puma)
- [unicorn](#unicorn)

Rack Middleware

- [rack-timeout](#rack-timeout)
- [slowpoke](#slowpoke)

Solvers

- [or-tools](#or-tools)
- [osqp](#osqp)
- [ruby-cbc](#ruby-cbc)
- [scs](#scs)

Distributed Locks

- [activerecord](#activerecord-1)
- [mlanett-redis-lock](#mlanett-redis-lock)
- [redlock](#redlock)
- [suo](#suo)
- [with_advisory_lock](#with_advisory_lock)

3rd Party Services

- [airrecord](#airrecord)
- [airtable](#airtable)
- [algoliasearch](#algoliasearch)
- [aws-sdk](#aws-sdk)
- [azure](#azure)
- [bitly](#bitly)
- [boxr](#boxr)
- [checkr-official](#checkr-official)
- [clearbit](#clearbit)
- [dogapi](#dogapi)
- [dropbox-sdk](#dropbox-sdk)
- [droplet_kit](#droplet_kit)
- [fastly](#fastly)
- [firebase](#firebase)
- [flickraw](#flickraw)
- [gibbon](#gibbon)
- [github_api](#github_api)
- [gitlab](#gitlab)
- [google-api-client](#google-api-client)
- [google-cloud](#google-cloud)
- [hipchat](#hipchat)
- [intercom](#intercom)
- [jira-ruby](#jira-ruby)
- [koala](#koala)
- [linkedin](#linkedin)
- [octokit](#octokit)
- [pinterest-api](#pinterest-api)
- [pusher](#pusher)
- [pwned](#pwned)
- [restforce](#restforce)
- [rspotify](#rspotify)
- [ruby-trello](#ruby-trello)
- [sentry-ruby](#sentry-ruby)
- [shopify_api](#shopify_api)
- [sift](#sift)
- [slack-notifier](#slack-notifier)
- [slack-ruby-client](#slack-ruby-client)
- [smartystreets_ruby_sdk](#smartystreets_ruby_sdk)
- [soda-ruby](#soda-ruby)
- [soundcloud](#soundcloud)
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
- [carrot2](#carrot2)
- [docker-api](#docker-api)
- [etcd](#etcd)
- [etcdv3](#etcdv3)
- [fastimage](#fastimage)
- [geocoder](#geocoder)
- [graphql-client](#graphql-client)
- [grpc](#grpc)
- [hexspace](#hexspace)
- [ignite-client](#ignite-client)
- [kubeclient](#kubeclient)
- [mail](#mail)
- [mechanize](#mechanize)
- [nats-pure](#nats-pure)
- [nestful](#nestful)
- [net-dns](#net-dns)
- [net-ldap](#net-ldap)
- [net-ntp](#net-ntp)
- [net-scp](#net-scp)
- [net-sftp](#net-sftp)
- [net-ssh](#net-ssh)
- [net-telnet](#net-telnet)
- [omniauth-oauth2](#omniauth-oauth2)
- [rbhive](#rbhive)
- [reversed](#reversed)
- [savon](#savon)
- [socket](#socket)
- [spidr](#spidr)
- [spyke](#spyke)
- [stomp](#stomp)
- [thrift](#thrift)
- [thrift_client](#thrift_client)
- [vault](#vault)
- [whois](#whois)
- [zk](#zk)
- [zookeeper](#zookeeper)

## Statement Timeouts

Prevent single queries from taking up all of your database’s resources.

### PostgreSQL

If you use Rails, add to your `config/database.yml`

```yml
production:
  variables:
    statement_timeout: 5s # or ms, min, etc
```

or set it on your database role

```sql
ALTER ROLE myuser SET statement_timeout = '5s';
```

Test with

```sql
SELECT pg_sleep(6);
```

To set for a single transaction, use

```sql
BEGIN;
SET LOCAL statement_timeout = '5s';
...
COMMIT;
```

For migrations, you likely want to set a longer statement timeout. You can do this with

```yml
production:
  variables:
    statement_timeout: <%= ENV["STATEMENT_TIMEOUT"] || "5s" %>
```

And use

```sh
STATEMENT_TIMEOUT=90s rails db:migrate
```

### MySQL

**Note:** Only applies to read-only `SELECT` statements ([more info](https://dev.mysql.com/doc/refman/8.4/en/server-system-variables.html#sysvar_max_execution_time))

If you use Rails, add to your `config/database.yml`

```yml
production:
  variables:
    max_execution_time: 5000 # ms
```

or set it directly on each connection

```sql
SET SESSION max_execution_time = 5000;
```

Test with

```sql
SELECT 1 FROM information_schema.tables WHERE sleep(6);
```

To set for a single statement, use an [optimizer hint](https://dev.mysql.com/doc/refman/5.7/en/optimizer-hints.html#optimizer-hints-execution-time)

```sql
SELECT /*+ MAX_EXECUTION_TIME(5000) */ ...
```

### MariaDB

If you use Rails, add to your `config/database.yml`

```yml
production:
  variables:
    max_statement_time: 5 # sec
```

or set it directly on each connection

```sql
SET SESSION max_statement_time = 5;
```

Test with

```sql
SELECT 1 FROM information_schema.tables WHERE sleep(6);
```

To set for a single statement, use

```sql
SET STATEMENT max_statement_time=5 FOR
  SELECT ...
```

For migrations, you likely want to set a longer statement timeout. You can do this with

```yml
production:
  variables:
    max_statement_time: <%= ENV['MAX_STATEMENT_TIME'] || 5 %>
```

And use

```sh
MAX_STATEMENT_TIME=90 rails db:migrate
```

[Official docs](https://mariadb.com/kb/en/mariadb/aborting-statements/)

## Standard Library

### io

**Note:** Requires Ruby 3.2+

```ruby
STDIN.timeout = 1
```

Raises `IO::TimeoutError`

### net/ftp

```ruby
Net::FTP.new(host, open_timeout: 1, read_timeout: 1)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### net/http

```ruby
Net::HTTP.start(host, port, open_timeout: 1, read_timeout: 1, write_timeout: 1) do
  # ...
end
```

or

```ruby
http = Net::HTTP.new(host, port)
http.open_timeout = 1
http.read_timeout = 1
http.write_timeout = 1
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout
- `Net::WriteTimeout` on write timeout

Default: 60s connect timeout, 60s read timeout, 60s write timeout

Read timeouts are retried once automatically for idempotent methods like `GET`. You can set the max number of retries with `http.max_retries = 1`.

### net/imap

```ruby
Net::IMAP.new(host, open_timeout: 1)
```

Read timeout is not configurable at the moment

Raises `Net::OpenTimeout` on connect timeout

### net/pop

```ruby
pop = Net::POP.new(host)
pop.open_timeout = 1
pop.read_timeout = 1
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### net/smtp

```ruby
smtp = Net::SMTP.new(host, 25)
smtp.open_timeout = 1
smtp.read_timeout = 1
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### open-uri

```ruby
URI.parse(url).open(open_timeout: 1, read_timeout: 1)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### regexp

**Note:** Requires Ruby 3.2+

```ruby
Regexp.timeout = 1
# or
Regexp.new(regexp, timeout: 1)
```

Raises `Regexp::TimeoutError`

## Data Stores

### activerecord

- #### postgres adapter

  ```ruby
  ActiveRecord::Base.establish_connection(connect_timeout: 1, checkout_timeout: 1, ...)
  ```

  or in `config/database.yml`

  ```yaml
  production:
    connect_timeout: 1
    checkout_timeout: 1
  ```

  Raises

  - `ActiveRecord::ConnectionNotEstablished` on connect and read timeouts
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

  - `ActiveRecord::ConnectionNotEstablished` on connect and read timeouts
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

Raises `ConnectionPool::TimeoutError`

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

Default: 1s

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

Raises `Elastic::Transport::Transport::Error`

### hiredis

```ruby
conn = Hiredis::Connection.new
conn.timeout = 1_000_000 # microseconds
```

Raises

- `Errno::ETIMEDOUT` on connect timeout
- `Errno::EAGAIN` on read timeout

### immudb

```ruby
Immudb::Client.new(host, timeout: 1)
```

Raises `GRPC::DeadlineExceeded`

### influxdb

```ruby
InfluxDB::Client.new(open_timeout: 1, read_timeout: 1)
```

Raises `InfluxDB::ConnectionError`

### influxdb-client

```ruby
InfluxDB2::Client.new(url, token, open_timeout: 1, read_timeout: 1)
```

Raises `InfluxDB2::InfluxError`

### meilisearch

```ruby
MeiliSearch::Client.new(url, api_key, timeout: 1)
```

Raises `MeiliSearch::TimeoutError`

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

Default: 1s after 5.0, 5s before

Raises

- `Redis::CannotConnectError` on connect timeout
- `Redis::TimeoutError` on read timeout

### redis-client

```ruby
RedisClient.config(timeout: 1, ...)
# or
RedisClient.config(connect_timeout: 1, read_timeout: 1, write_timeout: 1, ...)
```

Default: 1s

Raises `RedisClient::CannotConnectError`

### riddle

```ruby
client = Riddle::Client.new
client.timeout = 1
```

Raises `Riddle::ResponseError`

### rsolr

```ruby
RSolr.connect(open_timeout: 1, timeout: 1)
```

Raises

- `RSolr::Error::ConnectionRefused` on connect timeout
- `RSolr::Error::Timeout` on read timeout

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

  Raises

  - `Sequel::DatabaseConnectionError` on connect and read timeouts
  - `Sequel::PoolTimeout` on checkout timeout

- #### mysql2 adapter

  ```ruby
  Sequel.connect(timeout: 1, read_timeout: 1, connect_timeout: 1, pool_timeout: 1, ...)
  ```

  Raises

  - `Sequel::DatabaseConnectionError` on connect and read timeouts
  - `Sequel::PoolTimeout` on checkout timeout

### trino-client

```ruby
Trino::Client.new(http_open_timeout: 1, http_timeout: 1)
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### typesense

```ruby
Typesense::Client.new(connection_timeout_seconds: 1)
```

Raises `Typesense::Error::TimeoutError`

## HTTP Clients

### curb

```ruby
curl = Curl::Easy.new(url)
curl.connect_timeout = 1
curl.timeout = 1
curl.perform
```

Raises `Curl::Err::TimeoutError`

### down

```ruby
Down::NetHttp.download(connect_url, open_timeout: 1, read_timeout: 1)
```

Raises `Down::TimeoutError`

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

Raises

- `HTTP::ConnectTimeoutError` on connect timeout
- `HTTP::TimeoutError` on read timeout

### httparty

```ruby
HTTParty.get(url, timeout: 1)
```

or

```ruby
class Resource
  include HTTParty

  default_timeout 1
  # or
  open_timeout 1
  read_timeout 1
  write_timeout 1
end
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

Default: 60s connect timeout, 60s read timeout

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

## Commands

### frontkick

```ruby
Frontkick.exec(command, timeout: 1)
```

Raises `Frontkick::Timeout`

### mixlib-shellout

```ruby
Mixlib::ShellOut.new(command, timeout: 1)
```

Raises `Mixlib::ShellOut::CommandTimeout`

### posix-spawn

```ruby
POSIX::Spawn::Child.new(command, timeout: 1)
```

Raises `POSIX::Spawn::TimeoutExceeded`

### tty-command

```ruby
TTY::Command.new(timeout: 1)
```

or

```ruby
cmd.run(command, timeout: 1)
```

Raises `TTY::Command::TimeoutExceeded`

## Web Servers

### puma

```ruby
# config/puma.rb
worker_timeout 15
```

Default: 60s

This kills and respawns the worker process. Note that this is for the worker and not threads. This isn’t a [request timeout](https://github.com/puma/puma/issues/160) either. Use [Rack middleware](#rack-middleware) for request timeouts.

```ruby
# config/puma.rb
worker_shutdown_timeout 8
```

Default: 30s

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
use Rack::Timeout,
  service_timeout:   15,     # ENV["RACK_TIMEOUT_SERVICE_TIMEOUT"]
  wait_timeout:      30,     # ENV["RACK_TIMEOUT_WAIT_TIMEOUT"]
  wait_overtime:     60,     # ENV["RACK_TIMEOUT_WAIT_OVERTIME"]
  service_past_wait: false,  # ENV["RACK_TIMEOUT_SERVICE_PAST_WAIT"]
  term_on_timeout:   false   # ENV["RACK_TIMEOUT_TERM_ON_TIMEOUT"]
```

Default: 15s service timeout, 30s wait timeout

Raises `Rack::Timeout::RequestTimeoutError` or `Rack::Timeout::RequestExpiryError`

[Read more here](https://github.com/heroku/rack-timeout/blob/master/doc/settings.md)

**Note:** The approach used by Rack::Timeout can leave your application in an inconsistent state, [as described here](https://github.com/heroku/rack-timeout/blob/master/doc/risks.md). You can use [term on timeout](https://github.com/sharpstone/rack-timeout/blob/master/doc/settings.md#term-on-timeout) to avoid this.

### slowpoke

```ruby
Slowpoke.timeout = 5
```

Default: 15s

Raises same exceptions as [rack-timeout](#rack-timeout)

## Solvers

### or-tools

```ruby
routing.solve(time_limit: 1)
```

### osqp

```ruby
solver.solve(p, q, a, l, u, time_limit: 1)
```

Check for a `status` of `run time limit reached` for a timeout

### ruby-cbc

```ruby
problem.set_time_limit(1)
```

or

```ruby
problem.solve(sec: 1)
```

Check for a timeout with

```ruby
problem.time_limit_reached?
```

### scs

```ruby
solver.solve(data, cone, time_limit_secs: 1)
```

Check for a `status` of `solved (inaccurate - reached time_limit_secs)` for a timeout

## Distributed Locks

### activerecord

```ruby
ActiveRecord::Base.connection.get_advisory_lock(123)
```

Returns `false` if lock cannot be immediately acquired

### mlanett-redis-lock

```ruby
redis.lock(key, life: 1, acquire: 1) do |lock|
  # ...
end
```

Default: 10s acquisition timeout

Raises `Redis::Lock::LockNotAcquired`

### redlock

```ruby
lock_manager.lock!(key, 1000) do
  # ...
end
```

Default: 200ms acquisition timeout with 3 retries

Raises `Redlock::LockError`

### suo

```ruby
Suo::Client::Memcached.new(key, acquisition_timeout: 1)
```

or

```ruby
Suo::Client::Redis.new(key, acquisition_timeout: 1)
```

Default: 0.1s acquisition timeout with 10 retries

The `lock` method returns `nil` on timeout

### with_advisory_lock

```ruby
ActiveRecord::Base.with_advisory_lock("123", timeout_seconds: 1) do
  # ...
end
```

Returns `false` on acquisition timeout

## 3rd Party Services

### airrecord

Not configurable at the moment, and no timeout by default

### airtable

```ruby
Airtable::Resource.default_timeout 1
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### algoliasearch

```ruby
Algolia.init(
  connect_timeout: 1,
  send_timeout: 1,
  receive_timeout: 1,
  batch_timeout: 1,
  search_timeout: 1
)
```

Raises `Algolia::AlgoliaProtocolError`

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
adapter = Bitly::HTTP::Adapters::NetHTTP.new(request_opts: {
  open_timeout: 1,
  read_timeout: 1
})
http_client = Bitly::HTTP::Client.new(adapter)
client = Bitly::API::Client.new(token: token, http: http_client)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### boxr

```ruby
Boxr::BOX_CLIENT.connect_timeout = 1
Boxr::BOX_CLIENT.receive_timeout = 1
Boxr::BOX_CLIENT.send_timeout = 1
```

Raises

- `HTTPClient::ConnectTimeoutError` on connect timeout
- `HTTPClient::ReceiveTimeoutError` on read timeout

### checkr-official

Default: 30s connect timeout, 60s read timeout

Not configurable at the moment

### clearbit

```ruby
Clearbit::Resource.options = {timeout: 1}
```

Raises `Nestful::TimeoutError`

### dogapi

```ruby
timeout = 1
Dogapi::Client.new(api_key, nil, nil, nil, false, timeout)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### dropbox-sdk

Not configurable at the moment

Default: No connect timeout, 600s read timeout

### droplet_kit

```ruby
DropletKit::Client.new(open_timeout: 1, timeout: 1)
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

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

### gitlab

```ruby
Gitlab.client(httparty: {timeout: 1})
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### google-api-client

```ruby
client = Google::Apis::DriveV2::DriveService.new
client.client_options.open_timeout_sec = 1
client.client_options.read_timeout_sec = 1
```

Raise `Google::Apis::TransmissionError`

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

### intercom

```ruby
client = Intercom::Client.new(token: token)
client.options(Intercom::Client.set_timeouts(open_timeout: 1, read_timeout: 1))
```

Raises

- `Intercom::ServiceConnectionError` on connect timeout (inherits from `Intercom::IntercomError`)
- `Intercom::ServiceUnavailableError` on read timeout (inherits from `Intercom::IntercomError`)

### jira-ruby

```ruby
JIRA::Client.new(read_timeout: 1)
```

Connect timeout is not configurable at the moment

Raises `Net::ReadTimeout` on read timeout

### koala

```ruby
Koala.http_service.http_options = {request: {open_timeout: 1, timeout: 1}}
```

Raises `Faraday::ConnectionFailed`

### linkedin

Not configurable at the moment, and no timeout by default.

### octokit

```ruby
Octokit::Client.new(connection_options: {request: {open_timeout: 1, timeout: 1}})
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### pinterest-api

```ruby
Pinterest::Client.new(access_token, request: {open_timeout: 1, timeout: 1})
```

Raises

- `Faraday::ConnectionFailed` on connect timeout
- `Faraday::TimeoutError` on read timeout

### pusher

```ruby
client.timeout = 1
# or
client.connect_timeout = 1
client.send_timeout = 1
client.receive_timeout = 1
client.keep_alive_timeout = 1
```

Raises `Pusher::HTTPError`

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

### rspotify

Not configurable at the moment, and no timeout by default

### ruby-trello

Not configurable at the moment, and no timeout by default

### shopify_api

Not configurable at the moment, and no timeout by default

### sift

```ruby
Sift::Client.new(timeout: 1)
```

Default: 2s

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout
### sentry-ruby

```ruby
Sentry.init do |config|
  config.transport.timeout = 2 # Read and write timeout when waiting for the server to return data in seconds
  config.transport.open_timeout = 1 # Timeout waiting for the Sentry server connection to open in seconds
end
```

Default: 2s read/write timeout, 1s open timeout

Raises

- the timeout error happens in a background worker. The actual error is not reported to Sentry.

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

Raises `Slack::Web::Api::Errors::TimeoutError`

### smartystreets_ruby_sdk

```ruby
SmartyStreets::ClientBuilder.new(credentials).with_max_timeout(1)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### soda-ruby

```ruby
SODA::Client.new(timeout: 1)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### soundcloud

Not configurable at the moment, and no timeout by default

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

Raises `Twilio::REST::TwilioError`

### twitter

```ruby
Twitter::REST::Client.new do |config|
  config.timeouts = {connect: 1, read: 1, write: 1}
end
```

Raises `HTTP::TimeoutError`

**Note:** All three timeouts must be set for any to take effect.

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

Raises `Acme::Client::Error::Timeout`

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

### carrot2

```ruby
Carrot2.new(open_timeout: 1, read_timeout: 1)
```

Raises

- `Net::OpenTimeout` on connect timeout
- `Net::ReadTimeout` on read timeout

### docker-api

```ruby
Docker.options = {
  connect_timeout: 1,
  read_timeout: 1
}
```

Raises `Docker::Error::TimeoutError`

### etcd

```ruby
client = Etcd.client(read_timeout: 1)
```

Connect timeout not configurable

Default: 60s read timeout

Raises

- `Net::ReadTimeout` on read timeout

### etcdv3

```ruby
Etcdv3.new(command_timeout: 1)
```

or

```ruby
conn.get(key, timeout: 1)
```

Raises `GRPC::DeadlineExceeded`

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

### hexspace

```ruby
Hexspace::Client.new(timeout: 1)
```

Raises `Thrift::TransportException`

### ignite-client

```ruby
Ignite::Client.new(connect_timeout: 1)
```

Read timeout is not configurable at the moment

Raises `Ignite::TimeoutError` on connect timeout

### kubeclient

```ruby
Kubeclient::Client.new(url, timeouts: {open: 1, read: 1})
```

Raises `KubeException`

Default: 60s connect timeout, 60s read timeout

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
- `Net::ReadTimeout` on read timeout

### nats-pure

```ruby
nats = NATS::IO::Client.new
nats.connect(connect_timeout: 1)
```

Raises `NATS::IO::SocketTimeoutError`

### nestful

```ruby
Nestful::Request.new(url, timeout: 1)
```

or

```ruby
class Resource < Nestful::Resource
  options timeout: 1
end
```

Raises `Nestful::TimeoutError`

### net-dns

```ruby
Net::DNS::Resolver.new(udp_timeout: 1)
```

Default: 5s

Raises `Net::DNS::Resolver::NoResponseError`

### net-ldap

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

### rbhive

```ruby
RBHive.tcli_connect(host, port, timeout: 1) do |connection|
  # ...
end
```

Raises `Thrift::TransportException`

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

### thrift

```ruby
Thrift::Socket.new(host, port, 1)
```

Raises `Thrift::TransportException`

### thrift_client

```ruby
ThriftClient.new(client_class, servers, connect_timeout: 1, timeout: 1)
```

Raises

- `ThriftClient::NoServersAvailable` on connect timeout
- TODO: read timeout

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

### whois

```ruby
Whois::Client.new(timeout: 1)
```

Default: 10s

Raises `Timeout::Error`

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
```

To run all tests, use:

```sh
bundle exec appraisal rake test
```

To run individual tests, use:

```sh
bundle exec appraisal faraday rake test
```

To add a new gem:

1. Add it to `Appraisals` and run `bundle exec appraisal generate`
2. Run `bundle exec appraisal new_gem bundle`
3. Create `test/new_gem_test.rb` and run `bundle exec appraisal new_gem rake test`
4. Add it to the appropriate section of the readme

## And lastly...

> Because time is not going to go backwards, I think I better stop now. - Stephen Hawking

:clock4:
