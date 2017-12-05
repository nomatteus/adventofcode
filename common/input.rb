class InputReader
  def initialize(file)
    @input = IO.read(file).strip
  end

  def values
    @values = @input.split("\n")
  end
end

class IntegerLineReader < InputReader
  def values
    super
    @values.map(&:to_i)
  end
end
