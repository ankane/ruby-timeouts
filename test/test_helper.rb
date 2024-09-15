require "bundler/setup"
Bundler.require :default
require "minitest/autorun"
require "minitest/pride"
require "socket"

Thread.report_on_exception = false

class UnknownTimeoutError < StandardError; end

server = TCPServer.new("127.0.0.1", 4567)
Minitest.after_run { server.close }

socket = UDPSocket.new
socket.bind("127.0.0.1", 4568)
Minitest.after_run { socket.close }

class Minitest::Test
  def assert_timeout(exception = UnknownTimeoutError, timeout: 1)
    started_at = monotonic_time
    ex = assert_raises(exception) { yield }
    # test exact class
    assert_equal exception, ex.class

    time = monotonic_time - started_at
    timeout = timeout..timeout + 0.5 unless timeout.is_a?(Range)
    assert_includes timeout, time

    ex
  end

  def assert_threaded_timeout(exception = UnknownTimeoutError, timeout: 1, &block)
    assert_timeout(exception, timeout: timeout) do
      with_threads(&block)
    end
  end

  def with_threads
    threads = []
    results = []
    2.times do
      threads << Thread.new { results << yield }
    end
    threads.each(&:join)
    results
  end

  def connect_host
    "10.255.255.1"
  end

  def connect_url
    "http://#{connect_host}"
  end

  def read_host
    "127.0.0.1"
  end

  def read_port
    4567
  end

  def udp_port
    4568
  end

  def read_host_and_port
    "#{read_host}:#{read_port}"
  end

  def read_url
    "http://#{read_host_and_port}"
  end

  def monotonic_time
    Process.clock_gettime(Process::CLOCK_MONOTONIC)
  end

  def ruby3?
    RUBY_VERSION.to_i >= 3
  end
end
