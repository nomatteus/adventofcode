# This is a pseudo-code representation of the assembly codes
# It has been simplified/combined when possible

a=1
b,c,... = 0

# b = 67
# c = 67
b = 106700
# c = 17067

# infinite loop
while 1 != 0 do
  f = 1
  d = 2      # d acts as a counter, incrementing by 1 on each loop iteration

  do
    e = 2   # e acts as a counter, incrementing by 1 on each loop iteration
    do
      if (d * e) == b
        f = 0
      end
      e += 1
    while e != b   # simplified from g !=0  -->  (e-b) != 0

    d += 1
  while d != b # Simplified from  g != 0 ->  d - b != 0

  if f == 0
    h = h + 1
  end

  # This will clearly never happen since b starts from 106700 and only increases
  if b == 17067 # Simplified from g == 0  -->  b - 17067 == 0
    exit      # terminate program
  end

  b = b + 17
end
