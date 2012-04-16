class Time
  def rfc8601
    self.strftime(self.utc? ? "%Y-%m-%dT%H:%MZ" : "%Y-%m-%dT%H:%M")
  end

  def to_s
    rfc8601
  end
end
