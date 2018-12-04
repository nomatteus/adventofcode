# Advent of Code 2018 - Day 1 Solution

This is a solution walk-through in Ruby for:
https://adventofcode.com/2018/day/1

## Reading Input

Our input file is a list of numbers:

    +19
    -15
    +6
    +6
    +17
    ...

The first step in any solution is to read the input file contents into
a usable format. In this case, what we want is an array of integers.
In Ruby, we would do something like this:

    frequency_changes = IO.read('./input').strip.split("\n").map(&:to_i)

Now we have the data in a usable format:

    >> frequency_changes
    => [19, -15, 6, 6, 17, ...]

## Part 1

Note the key parts of the requirements:

* We start with a frequency of `0`
* When we see a value like `+3`, we add that number to the frequency.
* When we see a value like `-5`, we subtract that number from the frequency.

The question asks for the result after all frequency changes have been applied.

What we are really looking for is the sum of all the frequency changes. In
Ruby, we can use the `sum` method to find the answer:

    part1 = frequency_changes.sum

## Part 2

> You notice that the device repeats the same frequency change list over and over. To calibrate the device, you need to find the first frequency it reaches twice.

Now, we need to keep track of the frequencies we see after adding or subtracting
each change, and then return the first frequency that we see twice.

A `Set` is a great way to track which frequencies we see. Each time we have a
new frequency, we will check if it already exists in the `Set`, which means we
have seen it twice. A `Set` uses a hash to store values, which means we can check
for object inclusion in constant time (`O(1)`).

There is one more change in requirements that we need to handle:

> Note that your device might need to repeat its list of frequency changes many times before a duplicate frequency is found, and that duplicates might be found while in the middle of processing the list.

We need a way to loop through the list continuously until we find our solution.
Ruby's `Array` class has a handy method we can use: `cycle`. This will loop
through the list indefinitely, until we stop the looping with a `break` statement.

Putting these concepts together, we have the solution:

    freq = 0
    frequencies_seen = Set.new
    duplicate_freq = nil

    frequency_changes.cycle do |change|
      freq += change

      if frequencies_seen.include?(freq)
        duplicate_freq = freq
        break
      else
        frequencies_seen << freq
      end
    end

    puts "Part 2: #{duplicate_freq}"

## Slow-running Code

The solution above runs in under 200ms, which is a reasonable speed. However,
you may find that your solution takes up to a minute to run. In fact, we can
make one small change to the above solution above to make it run much slower:
change `frequencies_seen = Set.new` to `frequencies_seen = []`. When you run
the code after making that change, you will notice that it takes a minute to
run, but does eventually produce the correct answer.

This is because the slow version is using an `Array` to track frequencies
seen, instead of a `Set`. The `include?` method on an `Array` operates in
linear time (`O(n)`), meaning that we have to check every single element
in the array until we find the one we are looking for (or to find that
it doesn't exist in the array).

A `Set` uses hashing to store and retrieve elements, which runs in constant
time (`O(1)`).

A `Set` or `Hash` (or `HashSet`/`HashMap` in Java) is often the solution to
speed up slow-running code.

