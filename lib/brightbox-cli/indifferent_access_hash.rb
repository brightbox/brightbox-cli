# A simpler wrapper to allows either String or Symbol keys to be used
# when accessing attributes since fog applies a change on the top
# level resulting in a mix of both which has introduced issues.
class IndifferentAccessHash
  def initialize(hash)
    @hash = hash
  end

  # @param key [String, Symbol] the key to look up
  # @return [Object] the value of the key
  def [](key)
    value = @hash[key.to_s] || @hash[key.to_sym]
    wrap(value)
  end

  # @param key [String, Symbol] the key to set
  # @param value [Object] the value to set
  # @return [Object] the value of the key
  def []=(key, value)
    @hash[key.to_s] = value
  end

  # @param other [Object] the object to compare
  # @return [Object] the result of the comparison
  def ==(other)
    @hash == (other.is_a?(IndifferentAccessHash) ? other.to_h : other)
  end

  def method_missing(method, *args, &block)
    @hash.send(method, *args, &block)
  end

  def to_h
    @hash
  end

  private

  # This is to handle nested hashes to avoid the original issue again
  def wrap(value)
    case value
    when Hash
      IndifferentAccessHash.new(value)
    when Array
      value.map { |v| wrap(v) }
    else
      value
    end
  end
end
