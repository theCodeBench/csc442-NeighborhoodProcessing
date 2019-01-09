--[[

  * * * * dynamicFilters.lua * * * *

File containing all dynamic neighborhood 
filter routines.

Author: Ryan Hinrichs and Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

local util = require "util"
local math = require "math"

--[[

  * * * * Shallow Copy * * * *

Takes an array, creates a shallow copy and returns
the newly copied array.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: array - array to be copied
Returns:    newArray - the new array

--]]
local function shallowCopy( array )
  local newArray = {}
  --Steps through the array and fills newArray with array values
    for i = 1, #array do
      newArray[i] = array[i]
    end
    
  --Returns newly copied array  
  return newArray
end

--[[

  * * * * nxn Mean Filter * * * *

Finds the mean of the nxn pixel neighborhood,
size specified by the user, and replaces the 
center pixel intensity with the calculated mean.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
            size - size of the filter to be used
Returns:    the mean pixel intensity value

--]]
local function mean( neighborhood , size )
  local sum = 0
  
  --Calculates the total neighborhood intensity summation
  for i = 1, (size * size) do
    sum = sum + neighborhood[i]
  end
  
  --Finds the mean or average
  sum = sum / (size * size) 

  return sum
end

--[[

  * * * * nxn Median Filter * * * *

Finds the median of the nxn pixel neighborhood,
size specified by the user, and replaces the 
center pixel intensity with the calculated median.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
            size - size of the filter to be used
Returns:    the median pixel intensity value

--]]
local function median( neighborhood , size )
  local copy = shallowCopy( neighborhood )
  --Calculates the median location
  local medloc = (size * size ) + 1
  medloc = medloc / 2
  
  --Sorts the array
  copy = util.quicksort( copy , 1 , size * size )
  
  --Returns median value
  return copy[medloc]
end

--[[

  * * * * nxn Minimum Filter * * * *

Finds the minimum of the nxn pixel neighborhood,
size specified by the user, and replaces the 
center pixel intensity with the calculated minimum.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
            size - size of the filter to be used
Returns:    the minimum pixel intensity value

--]]
local function min( neighborhood , size)
  local copy = shallowCopy( neighborhood )
  
  --Sorts the array
  copy = util.quicksort( copy , 1 , size * size)
  
  --Returns minimum value
  return copy[1]
end

--[[

  * * * * nxn Maximum Filter * * * *

Finds the maximum of the nxn pixel neighborhood,
size specified by the user, and replaces the 
center pixel intensity with the calculated maximum.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
            size - size of the filter to be used
Returns:    the maximum pixel intensity value

--]]
local function max( neighborhood , size)
  local copy = shallowCopy( neighborhood )
  
  --Sorts the array
  copy = util.quicksort( copy , 1 , size * size )
  
  --Returns the maximum value
  return copy[(size*size)]
end

--[[

  * * * * nxn Range Filter * * * *

Finds the range of the nxn pixel neighborhood,
size specified by the user, and replaces the 
center pixel intensity with the calculated range.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
            size - size of the filter to be used
Returns:    the neighborhood range pixel intensity value

--]]
local function range( neighborhood , size)
  local copy = shallowCopy( neighborhood )
  
  --Sorts the array
  copy = util.quicksort( copy , 1 , size * size )
  
  --Returns the array average
  return (copy[(size * size)] - copy[1])
end

--[[

  * * * * nxn Standard Deviation Filter * * * *

Finds the standard deviation of the nxn pixel neighborhood,
size specified by the user, and replaces the center pixel 
intensity with the calculated standard deviation.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
            size - size of the filter to be used
Returns:    the standard deviation pixel intensity value

--]]
local function stdev( neighborhood , size)
  local sum = 0
  local int i = 0
  local replace = {}
  
  --FInds the total neighborhood intensity average
  for i = 1, (size * size) do
    sum = sum + neighborhood[i]
  end
  sum = sum / (size * size) 

  --Finds a new neighborhood by the equation:
  --newSpot = (oldSpot - summation) ^ 2
  for i = 1, (size * size) do
    replace[i] = (neighborhood[i] - sum) * (neighborhood[i] - sum)
  end 
  
  sum = 0

  --Finds the total altered neighborhood intensity average
  for i = 1, (size * size) do
    sum = sum + replace[i]
  end
  sum = sum / (size * size)

  --Returns square root of the calculated average
  return math.sqrt(sum)
end

-- Export all functions
return {
  mean = mean,
  median = median,
  min = min,
  max = max,
  range = range,
  stdev = stdev
}