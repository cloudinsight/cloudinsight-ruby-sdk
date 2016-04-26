# encoding: utf-8

require 'test_helper'
require 'cloud_insight/statsd'

class StatsdTest < Minitest::Test
  def setup
    @socket = mock
    @socket.stubs(:connect).with('localhost', 8251).returns(@socket)
    @socket.stubs(:close).returns(true)
    CloudInsight::Statsd.any_instance.stubs(:rand).returns(0.1)
    CloudInsight::Statsd.any_instance.stubs(:socket).returns(@socket)
    @sd = CloudInsight::Statsd.new
  end

  def test_gauge
    @sd.gauge('yaiba.test_gauge', 8080, ['yaiba:gauge', 'yaiba:cloud_insight'], 0.5)
    assert_equal 1, @sd.buffer.size
    assert_equal 'yaiba.test_gauge:8080|g|@0.5|#yaiba:gauge,yaiba:cloud_insight', @sd.buffer.first
  end

  def test_gauge_with_default_option
    @sd.gauge('yaiba.test_gauge')
    assert_equal 1, @sd.buffer.size
    assert_equal 'yaiba.test_gauge:1|g|@1.0', @sd.buffer.first
  end

  def test_gague_with_constant_tags
    tags = ['yaiba:cloud_insight']
    @sd = CloudInsight::Statsd.new 'localhost', 8251, max_buffer_size: 10, constant_tags: ['yabia:yabia']
    @sd.gauge('yaiba.test_gauge', 9090, tags)
    assert_equal 1, @sd.buffer.size
    assert_equal 'yaiba.test_gauge:9090|g|@1.0|#yaiba:cloud_insight,yabia:yabia', @sd.buffer.first
    @sd.gauge('yaiba.test_gauge', 9091, tags)
    assert_equal 'yaiba.test_gauge:9091|g|@1.0|#yaiba:cloud_insight,yabia:yabia', @sd.buffer.last
  end

  def test_increment
    @sd.increment('yaiba.test_increment', 8080, ['yaiba:increment', 'yaiba:cloud_insight'], 0.5)
    assert_equal 1, @sd.buffer.size
    assert_equal 'yaiba.test_increment:8080|c|@0.5|#yaiba:increment,yaiba:cloud_insight', @sd.buffer.first
  end

  def test_increment_with_default_option
    @sd.increment('yaiba.test_increment')
    assert_equal 1, @sd.buffer.size
    assert_equal 'yaiba.test_increment:1|c|@1.0', @sd.buffer.first
  end

  def test_decrement
    @sd.decrement('yaiba.test_decrement', 8080, ['yaiba:decrement', 'yaiba:cloud_insight'], 0.5)
    assert_equal 1, @sd.buffer.size
    assert_equal 'yaiba.test_decrement:-8080|c|@0.5|#yaiba:decrement,yaiba:cloud_insight', @sd.buffer.first
  end

  def test_buffer_with_max
    @sd.stubs(:send_to_agent).returns(true)
    30.times { @sd.increment('test_buffer') }
    assert_equal 30, @sd.buffer.size
    20.times { @sd.increment('test_buffer') }
    @sd.increment('test_buffer2')
    assert_equal 1, @sd.buffer.size
    assert_equal 'test_buffer2:1|c|@1.0', @sd.buffer.first
  end

  def test_send_data_exception
    @sd.send(:logger).expects(:error)
    @sd.send(:send_to_agent)
  end
end
