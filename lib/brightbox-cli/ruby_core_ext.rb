class Time
  # Returns a shortened version of ISO 8601 omitting the seconds and timezone
  # information.
  #
  # @note This output is probably in error and should be updated however the
  #   missing characters will reformat a number of columns and pages of output.
  #
  # @return [String] A clipped form of date, ISO 8601 without seconds
  #
  def clipped_iso_8601
    strftime(utc? ? "%Y-%m-%dT%H:%MZ" : "%Y-%m-%dT%H:%M")
  end

  def to_s
    clipped_iso_8601
  end
end
