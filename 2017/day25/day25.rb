input = IO.read('./input').strip.split("\n\n")

# Input parsing regex
INITIAL_STATE_PATTERN = /Begin in state ([A-Z]+).\nPerform a diagnostic checksum after ([0-9]+) steps./
RULES_PATTERN = %r{In state ([A-Z]):
  If the current value is ([01]):
    - Write the value ([01]).
    - Move one slot to the (right|left).
    - Continue with state ([A-Z]).
  If the current value is ([01]):
    - Write the value ([01]).
    - Move one slot to the (right|left).
    - Continue with state ([A-Z]).}

class TuringMachine
  attr_accessor :num_steps

  def initialize(input)
    # Parses input and sets the @state_rules
    num_steps, start_state = parse_input(input)

    # Number of steps before we take the "Diagnostic Checksum"
    @num_steps = num_steps

    # Infinite tape, so use a hash indexed by position (we only need 1 dimension)
    # The tape contains all 0s initially, so set that as the default value
    @tape = Hash.new(0)

    # Initial tape position (Start at 0 then go in positive/negative direction from here)
    @cursor = 0

    # State
    @state = start_state
  end

  def run!
    @num_steps.times { step }
    calculate_diagnostic_checksum
  end

  def step
    next_actions = @state_rules[@state][@tape[@cursor]]
    @tape[@cursor] = next_actions[:write]
    @cursor += next_actions[:move]
    @state = next_actions[:next_state]
  end

  def calculate_diagnostic_checksum
    @tape.values.select { |v| v == 1}.size
  end

private

  def parse_input(input)
    @state_rules = {}
    setup_string, *rules_strings = input
    _, start_state, num_steps = setup_string.match(INITIAL_STATE_PATTERN).to_a
    rules_strings.each do |rules_string|
      _, state, cond1, write1, move1, next1, cond2, write2, move2, next2 = rules_string.match(RULES_PATTERN).to_a

      # Build a dynamic list of state rules as given by the input
      @state_rules[state] = {
        cond1.to_i => {
          write: write1.to_i,
          move: move1 == 'left' ? -1 : 1,
          next_state: next1
        },
        cond2.to_i => {
          write: write2.to_i,
          move: move2 == 'left' ? -1 : 1,
          next_state: next2
        }
      }
    end

    [num_steps.to_i, start_state]
  end

end

turing = TuringMachine.new(input)
checksum = turing.run!

puts "Day 25 Turing Checksum: #{checksum}"
