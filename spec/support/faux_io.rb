# This class encapsulates the pattern of faking STD IO and exposing the streams
# for testing.
class FauxIO
  def initialize(&block)
    begin
      original_stdout = $stdout
      original_stderr = $stderr

      $stdout = @stdout = StringIO.new
      $stderr = @stderr = StringIO.new

      yield
    rescue SystemExit => e
    ensure
      $stdout = original_stdout
      $stderr = original_stderr
    end
  end

  def stdout
    @stdout.string
  end

  def stderr
    @stderr.string
  end
end
