class NilableHash < Hash
  def nilify_blanks
    keys.each do |k|
      self[k] = nil if self[k] == ''
    end
  end
end