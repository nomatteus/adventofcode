
* Coordinates are unbounded.
* Make the starting location 0,0 then move from there.
* Need a data structure to support this (something that grows dynamically)
* Either a 2D data structure, or convert to 1D.
* We don't care about the count of presents, only if a present has been delivered or not.

Ideas:

* Use a Set data structure, and add coordinates (e.g. length 2 array), then count elements in set after processing all.
* 
