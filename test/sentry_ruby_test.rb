require_relative "test_helper"

class SentryRubyTest < Minitest::Test
  def test_connect
    Sentry.init do |config|
      config.dsn = connect_url
      config.transport.timeout = 2 # Read and write timeout when waiting for the server to return data in seconds
      config.transport.open_timeout = 1 # Timeout waiting for the Sentry server connection to open in seconds
    end
    client = Sentry::Client.new(Sentry.configuration)

    ex = assert_timeout(Sentry::ExternalError, timeout: 1) do
      client.transport.send_event({})
    end

    assert_match(/Failed to open TCP connection/, ex.message)
  end

  def test_read
    Sentry.init do |config|
      config.dsn = read_url
      config.transport.timeout = 2 # Read and write Timeout when waiting for the server to return data in seconds
      config.transport.open_timeout = 1 # Timeout waiting for the Sentry server connection to open in seconds
    end
    client = Sentry::Client.new(Sentry.configuration)

    ex = assert_timeout(Sentry::ExternalError, timeout: 2) do
      client.transport.send_event({})
    end

    assert_match(/Net::ReadTimeout with/, ex.message)
  end
end
