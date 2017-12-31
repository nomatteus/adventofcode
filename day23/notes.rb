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

  # CURRENT INTUITION: This is an algorithm searching for 2-number integer factorizations of
  #  numbers (i.e. values of b). If there is a 2-number factorization for a value of b, then
  #  h is incremented by 1
  do  # for d from 2 to b
    e = 2   # e acts as a counter, incrementing by 1 on each loop iteration
    do  # for e from 2 to b
      # First outer iteration b=106700, d=2, e=2,3,4... -> ... 2*2, 2*3, 2*4, etc... so will have 53350 iterations before this is true
      # Second outer iteration, b = 106717, d=3, e=2,3,4 => ... 3*2, 3*3, 3*4, etc.. never true, since 106717 not divisible by 3
      # third outer iteration, b = 106734, d=4,
      # next outer iteration , b = 106751, d=5,
      # next outer iteration , b = 106768, d=6,
      if (d * e) == b
        f = 0
      end
      e += 1
    while e != b      # simplified from g !=0  -->  (e-b) != 0

    d += 1
  while d != b        # Simplified from  g != 0 ->  d - b != 0

  if f == 0
    h = h + 1
  end

  # This will clearly never happen since b starts from 106700 and only increases
  if b == 17067 # Simplified from g == 0  -->  b - 17067 == 0
    exit      # terminate program
  end

  b = b + 17
end
