# encoding: utf-8

require 'socket'
require 'logger'

module CloudInsight
  class Statsd
    attr_reader :socket, :buffer

    ENCODING = 'utf-8'.freeze

    # Init Statsd
    #  @statsd = CloudInsight::Statsd.new
    #  <String> host: the host of the OneStatsd server (default: 'localhost')
    #  <Fixnum> port: the port of the OneStatsd server (default: 8251)
    #  <Hash> option:
    #  <Fixnum>  option[:max_buffer_size]: Maximum number of metrics to buffer before sending to the server (default: 50)
    #  <Array>   option[:constant_tags]: Tags to attach to every metric reported by this client (default: [])
    #  <Boolean> option[:use_ms]: Report timed values in milliseconds instead of seconds (default: false)
    def initialize(host = 'localhost', port = 8251, option = {})
      @host            = host
      @port            = port
      @buffer          = []
      @socket          = nil
      @max_buffer_size = option[:max_buffer_size] || 50
      @constant_tags   = option[:constant_tags] || []
      @use_ms          = option[:use_ms] || false
      exit_handler
    end

    # Record the value of a gauge, optionally setting a list of tags and a sample rate.
    #  @statsd.gauge('test.online', 8080)
    #  @statsd.gauge('test.online', 8080, ['test:online'], 0.8)
    def gauge(metric, value = 1, tags = [], sample_rate = 1)
      report(metric, 'g', value, tags, sample_rate)
    end

    # Increment a counter, optionally setting a value, tags and a sample rate.
    #  @statsd.increment('test.online', 1)
    #  @statsd.increment('test.online', 1, ['test:online'], 0.8)
    def increment(metric, value = 1, tags = [], sample_rate = 1)
      report(metric, 'c', value, tags, sample_rate)
    end

    # Decrement a counter, optionally setting a value, tags and a sample rate.
    #  @statsd.decrement('test.online', 1)
    #  @statsd.decrement('test.online', 1, ['test:online'], 0.8)
    def decrement(metric, value = 1, tags = [], sample_rate = 1)
      report(metric, 'c', -value, tags, sample_rate)
    end

    private

    def report(metric, mtype, value, tags, sample_rate)
      return if sample_rate.to_f != 1.0 && rand > sample_rate.to_f
      data = convert(metric, mtype, value, tags, sample_rate)
      store_to_buffer data if data
    end

    def convert(metric, mtype, value, tags, sample_rate)
      data = []
      data << "#{metric}:#{value}"
      data << mtype.to_s
      data << "@#{sample_rate.to_f}"
      data << "##{tags.join(',')}" unless (tags += @constant_tags).empty?
      begin
        data.join('|').encode(ENCODING)
      rescue
        nil
      end
    end

    def store_to_buffer(data)
      @buffer << data
      flush_buffer if @buffer.size >= @max_buffer_size
    end

    def flush_buffer
      buffer_old = @buffer
      @buffer = []
      send_to_agent { |socket| socket.send(buffer_old.join("\n"), 0) } unless buffer_old.empty?
    end

    def send_to_agent
      yield socket
    rescue => e
      logger.error "send to agent server error: #{e.inspect}"
    end

    def socket
      @socket ||= begin
        UDPSocket.new.tap do |udp_socket|
          udp_socket.connect @host, @port
        end
      end
    end

    def logger
      @logger ||= begin
        Logger.new(STDOUT).tap do |log|
          log.level = Logger::INFO
          log.datetime_format = '%Y-%m-%d %H:%M:%S'
        end
      end
    end

    # flush buffer on exit
    def exit_handler
      at_exit do
        begin
         flush_buffer
         socket.close
       rescue => e
         logger.error "close sokcet error: #{e.inspect}"
       end
      end
    end
  end
end
