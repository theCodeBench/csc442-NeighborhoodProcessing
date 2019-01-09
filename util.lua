--[[

  * * * * util.lua * * * *

File for general utility functions used in the image processing code of this
project. An example is clipping values to [0, 255].

Author: Zachery Crandall
Class:  CSC442/542 Digital Image Processing
Date:   Spring 2017

--]]
require "ip"
local viz = require "visual"
local il = require "il"



--[[

  * * * * Clip Intensity Values * * * *

Function to clip intensity values to the range [0,255].

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: pixel - the pixel to be clipped
Returns:    pixel - the clipped pixel

--]]
local function clip( pixel )
  if pixel < 0 then pixel = 0 end
  if pixel > 255 then pixel = 255 end

  return pixel
end



--[[

  * * * * Convert radians to degrees * * * *

Converts radians to degrees.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: radians - number of radians to be converted
Returns:    the converted angle in degrees

--]]
local function rad2deg( radians )
  return radians * 180 / math.pi
end



--[[

  * * * * Is Sorted Least to Greatest * * * *

Checks if the array of the specified size is sorted from least to greatest.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: arr - array to be checked
Returns:    sorted - true if sorted; false if not

--]]
local function isSortedLtG( arr )
  local sorted = true

  -- Check that each subsequent element is larger than the
  -- previous element
  for i = 1, #arr - 1 do
    if arr[i] > arr[i + 1] then sorted = false end
  end

  return sorted
end



--[[

* * * * Hoare Partition Scheme * * * *

This function partitions a 1D array using the Hoare partition scheme.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: arr - 1D array of values
            lo - lowest index of items to partition
            hi - highest index of items to partition
Returns:    index of partition

--]]
local function partition( arr, lo, hi )
  local pivot = arr[hi]
  local i = lo - 1
  local tmp = 0

  for j = lo, hi - 1 do
    if arr[j] <= pivot then
      i = i + 1

      -- Swap the elements
      tmp = arr[i]
      arr[i] = arr[j]
      arr[j] = tmp
    end
  end

  tmp = arr[i + 1]
  arr[i + 1] = arr[hi]
  arr[hi] = tmp

  return i + 1
end



--[[

* * * * Quicksort * * * *

This function applies a quicksort to a 1D array using the Hoare 
partition scheme.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: arr - 1D array of values
            lo - lowest index of items to sort
            hi - highest index of items to sort
Returns:    arr - sorted 1D array of values

--]]
local function quicksort( arr, lo, hi )
  local temp = 0

  -- Check if the array is already sorted
  if isSortedLtG( arr ) then return arr end

  -- Recursively call quicksort on partitions formed
  if lo < hi then
    temp = partition( arr, lo, hi )
    quicksort( arr, lo, temp - 1 )
    quicksort( arr, temp + 1, hi )
  end

  return arr
end


-- Export all functions
return {
  clip = clip,
  histogramYIQ = histogramYIQ,
  findMinMax = findMinMax,
  quicksort = quicksort,
  rad2deg = rad2deg,
}