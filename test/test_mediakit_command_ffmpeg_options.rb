require 'minitest_helper'

class TestMediakitCommandFfmpegOptions < Minitest::Test
  def test_global_options_of_boolean
    global = Mediakit::Runners::FFmpeg::Options::GlobalOption.new(l: true)
    assert_equal("-l", global.compose)
  end

  def test_global_options_with_str_arg
    global = Mediakit::Runners::FFmpeg::Options::GlobalOption.new(h: 'full')
    assert_equal("-h full", global.compose)
  end

  def test_global_options_with_num_arg
    global = Mediakit::Runners::FFmpeg::Options::GlobalOption.new(t:100)
    assert_equal("-t 100", global.compose)

    global = Mediakit::Runners::FFmpeg::Options::GlobalOption.new(t: 100.0)
    assert_equal("-t 100.0", global.compose)
  end

  def test_global_options_with_nil_arg
     assert_raises(ArgumentError) do
       Mediakit::Runners::FFmpeg::Options::GlobalOption.new(t: nil)
     end
  end

  def test_input_file_option
    option = Mediakit::Runners::FFmpeg::Options::InputFileOption.new(options: {b: '1000k'}, path: 'test.mp4')
    assert_equal('-b 1000k -i test.mp4', option.compose)
    assert_equal('-b 1000k -i test.mp4', option.to_s)
  end

  def test_output_file_option
    option = Mediakit::Runners::FFmpeg::Options::OutputFileOption.new(options: {b: '1000k'}, path: 'test.mp4')
    assert_equal('-b 1000k test.mp4', option.compose)
    assert_equal('-b 1000k test.mp4', option.to_s)
  end

  def test_option
    global = Mediakit::Runners::FFmpeg::Options::GlobalOption.new(t: 100.0)
    input = Mediakit::Runners::FFmpeg::Options::InputFileOption.new(options: {b: '1000k'}, path: 'in.mp4')
    output = Mediakit::Runners::FFmpeg::Options::OutputFileOption.new(options: {b: '1000k'}, path: 'out.mp4')
    options = Mediakit::Runners::FFmpeg::Options.new(global, input, output)
    assert_equal('-t 100.0 -b 1000k -i in.mp4 -b 1000k out.mp4', options.compose)
    assert_equal('-t 100.0 -b 1000k -i in.mp4 -b 1000k out.mp4', options.to_s)
  end

  def test_stream_specifier
    stream_specifier = Mediakit::Runners::FFmpeg::Options::StreamSpecifier.new(stream_index: 1)
    assert_equal('1', stream_specifier.to_s)

    stream_specifier = Mediakit::Runners::FFmpeg::Options::StreamSpecifier.new(stream_index: 1, stream_type: 'a')
    assert_equal('a:1', stream_specifier.to_s)

    stream_specifier = Mediakit::Runners::FFmpeg::Options::StreamSpecifier.new(stream_type: 'a')
    assert_equal('a', stream_specifier.to_s)

    stream_specifier = Mediakit::Runners::FFmpeg::Options::StreamSpecifier.new(usable: 'u')
    assert_equal('u', stream_specifier.to_s)

    stream_specifier = Mediakit::Runners::FFmpeg::Options::StreamSpecifier.new(program_id: 1)
    assert_equal('p:1', stream_specifier.to_s)

    stream_specifier = Mediakit::Runners::FFmpeg::Options::StreamSpecifier.new(stream_index: 1, program_id: 1)
    assert_equal('1', stream_specifier.to_s)
  end
end