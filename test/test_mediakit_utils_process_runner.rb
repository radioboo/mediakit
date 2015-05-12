require 'minitest_helper'

class TestMediakitUtilsProcessRunner < Minitest::Test
  def setup
    @bin = File.join(TestContext.root, 'test/supports/ffmpeg')
    @runner = Mediakit::Utils::ProcessRunner.new(timeout: 2)
  end

  def teardown
    @runner = nil
  end

  def test_timeout_error
    # error with read timeout
    assert_raises(Timeout::Error) do
      @runner.run(@bin, '--sleep=3')
    end

    # no timeout error wtih output
    @runner.run(@bin, '--sleep=3 --progress')
  end

  def test_return_values
    # no timeout error wtih output
    out, err, status = @runner.run(@bin, '--sleep=1 --progress')
    assert(out)
    assert(out.kind_of?(String))
    assert(err.kind_of?(String))
    assert(status == true)
  end

  def test_escape
    assert_equal("a\\;b", Mediakit::Utils::ProcessRunner.escape("a;b"))
  end
end
