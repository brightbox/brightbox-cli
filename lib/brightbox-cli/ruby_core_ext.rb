class Time
  def rfc8601
    self.strftime("%Y-%m-%dT%H:%M")
  end

  def to_s
    rfc8601
  end
end
