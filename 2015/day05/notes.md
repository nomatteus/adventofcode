Strategy:

* Split string into characters.
* Loop through characters, storing last n recently-used characters (where n is the max chars needed for all the rules)
  * lookback needed is: only current and previous (we only have rules that concern 2 in a row)
* At each character, test all applicable rules, in order of efficiency.
* Evaluate each rule independently. If we have success for a rule, no need to check it anymore for the rest of the string.

Rules

* Nice string must contain at least 3 vowels.
  *
* Nice string must contain at least one letter that appears twice in a row.
  * as soon as we see 2 letters same in a row, no need to check these rules.
* Nice string does *not* contain ab, cd, pq, or xy
  * As soon as we see any
