require 'set'
require 'pry'

input = IO.read('./input').strip.split("\n").sort
# input = IO.read('./input_small').strip.split("\n")#.map(&:to_i)

# Store minutes in which guard was asleep
guard_records = Hash.new()
sleep_at = nil
awake_at = nil
current_guard = nil

input.each do |record|
  year, month, day, hour, minute, guard_num = record.scan(/\d+/).map(&:to_i)
  current_guard = guard_num unless guard_num.nil?

  if record.match(/asleep/)
    sleep_at = minute
  elsif record.match(/wakes/)
    awake_at = minute

    guard_records[current_guard] ||= []

    # Log each minute awake (do NOT include awake_at minute)
    (sleep_at...awake_at).each do |min|
      guard_records[current_guard] << min
    end
  end
end

# Build a hash of sleep frequencies.
def generate_sleep_freq(sleep_mins)
  freq = Hash.new(0)
  sleep_mins.each { |m| freq[m] += 1 }
  freq
end

# Generate a sleep frequency for each guard
guard_freqs = {}
guard_each_max = {}
guard_records.each do |guard_id, sleepmins|
  guard_freqs[guard_id] = generate_sleep_freq(sleepmins)
  max_minute, max = guard_freqs[guard_id].max_by { |k, v| v }
  guard_each_max[guard_id] = { count: max, minute: max_minute }
end

# Use the generated data structures to solve part 1 and 2
part1_guard_id = guard_records.max_by { |g, mins| mins.size }[0]
part1_most_freq_minute = guard_freqs[part1_guard_id].max_by { |k, v| v }[0]

part2_guard_id, res2 = guard_each_max.max_by { |k, v| v[:count] }

part1 = part1_most_freq_minute * part1_guard_id
part2 = part2_guard_id * res2[:minute]

puts "Part 1: #{part1}" # 151754
puts "Part 2: #{part2}" # 19896
