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

guard_id_sleepiest, sleep_mins = guard_records.sort_by { |g, m| -m.size }.first

sleep_freq = Hash.new(0)
sleep_mins.each { |m| sleep_freq[m] += 1 }

max = sleep_freq.values.max
minute_most = sleep_freq.invert[max]




guard_freqs = {}
guard_each_max = {}
guard_records.each do |guard_id, sleepmins|
  guard_freqs[guard_id] = Hash.new(0)
  sleepmins.each { |m| guard_freqs[guard_id][m] += 1 }
  max = guard_freqs[guard_id].values.max
  max_minute = guard_freqs[guard_id].invert[max]
  guard_each_max[guard_id] = { count: max, minute: max_minute }
end

guard2_id, res2 = guard_each_max.to_a.sort_by { |a| -a[1][:count] }.first




part1 = minute_most * guard_id_sleepiest
part2 = guard2_id * res2[:minute]

puts "Part 1: #{part1}" # 151754
puts "Part 2: #{part2}" # 19896
