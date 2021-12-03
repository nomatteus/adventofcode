# This class implements operations of device
class WatchDevice
  VALID_OPS = [
    :addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori, :setr, :seti,
    :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr
  ]

  # initial_registers is expected to be a 4-element array
  def initialize(initial_registers=[0, 0, 0, 0])
    @registers = Hash.new(0)
    initial_registers.each_with_index do |v, i|
      @registers[i] = v
    end
  end

  # Returns 4-element array with register values
  def registers
    @registers.values
  end

  # addr (add register) stores into register C the result of adding register A and register B.
  def addr(a, b, c)
    @registers[c] = @registers[a] + @registers[b]
  end

  # addi (add immediate) stores into register C the result of adding register A and value B.
  def addi(a, b, c)
    @registers[c] = @registers[a] + b
  end

  # mulr (multiply register) stores into register C the result of multiplying register A and register B.
  def mulr(a, b, c)
    @registers[c] = @registers[a] * @registers[b]
  end

  # muli (multiply immediate) stores into register C the result of multiplying register A and value B.
  def muli(a, b, c)
    @registers[c] = @registers[a] * b
  end

  # banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
  def banr(a, b, c)
    @registers[c] = @registers[a] & @registers[b]
  end

  # bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
  def bani(a, b, c)
    @registers[c] = @registers[a] & b
  end

  # borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
  def borr(a, b, c)
    @registers[c] = @registers[a] | @registers[b]
  end

  # bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
  def bori(a, b, c)
    @registers[c] = @registers[a] | b
  end

  # setr (set register) copies the contents of register A into register C. (Input B is ignored.)
  def setr(a, b, c)
    @registers[c] = @registers[a]
  end

  # seti (set immediate) stores value A into register C. (Input B is ignored.)
  def seti(a, b, c)
    @registers[c] = a
  end

  # gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
  def gtir(a, b, c)
    @registers[c] = a > @registers[b] ? 1 : 0
  end

  # gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
  def gtri(a, b, c)
    @registers[c] = @registers[a] > b ? 1 : 0
  end

  # gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
  def gtrr(a, b, c)
    @registers[c] = @registers[a] > @registers[b] ? 1 : 0
  end

  # eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
  def eqir(a, b, c)
    @registers[c] = a == @registers[b] ? 1 : 0
  end

  # eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
  def eqri(a, b, c)
    @registers[c] = @registers[a] == b ? 1 : 0
  end

  # eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
  def eqrr(a, b, c)
    @registers[c] = @registers[a] == @registers[b] ? 1 : 0
  end
end
