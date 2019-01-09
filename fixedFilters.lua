--[[

  * * * * fixedFilters.lua * * * *

File containing all fixed 3x3 neighborhood 
filter routines that do not utilize edge
detection.

Author: Ryan Hinrichs and Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

local util = require "util"
local math = require "math"

--[[

  * * * * 3x3 Smoothing Filter * * * *

Applies a smoothing filter to all pixels within the image,
averaging the intensity of each pixel by the surrounding 
neighborhood.  This operation makes the image look more
'smooth' or slightly blurred and blended together.

Convolution filter used:
       |  1  2  1  |         
1/16 * |  2  4  2  |            
       |  1  2  1  |            

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
Returns:    the averaged pixel intensity value

--]]
local function smooth3x3( neighborhood )

  local row1, row2, row3
  
  --Calculates the filtered and averaged rows for efficiency
  row1 = 0.0625 * neighborhood[1] + 0.1250 * neighborhood[2] + 0.0625 * neighborhood[3]
  row2 = 0.1250 * neighborhood[4] + 0.25 * neighborhood[5] + 0.1250 * neighborhood[6]
  row3 = 0.0625 * neighborhood[7] + 0.1250 * neighborhood[8] + 0.0625 * neighborhood[9]
  
  --Adds together all of the rows
  row1 = row1 + row2 + row3
  
  return row1
end

--[[

  * * * * 3x3 Sharpening Filter * * * *

Applies a sharpening filter to all pixels within the image,
subtracting the intensities of each pixel's neighborhood from 
the center pixel's intensity.  This operation makes the image 
look more 'sharp' or more dynamically changing with hard edges.

Convolution filter used:
|  0 -1  0  |         
| -1  5 -1  |            
|  0 -1  0  |            

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
Returns:    the sharpened pixel intensity value

--]]
local function sharpen3x3( neighborhood )
  local sum = 0
  local row1, row2, row3
  
  --Calculates the filtered rows for efficiency
  row1 = -1 * neighborhood[2]
  row2 = -1 * neighborhood[4] + 5 * neighborhood[5] + -1 * neighborhood[6]
  row3 = -1 * neighborhood[8]

  --Adds the filtered rows
  sum = row1 + row2 + row3
  
  --Returns clipped value
  return util.clip( sum )
end

--[[

  * * * * 3x3 Plus-Shaped Median Filter * * * *

Applies a median filter to all pixels within the image,
getting the median value of each neighborhood surrounding 
the center pixel in a plus shape.  This operation removes
impulse noise from the image.

Rank-Order filter used:
|  0  1  0  |         
|  1  1  1  |            
|  0  1  0  |            

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
Returns:    the median pixel intensity value

--]]
local function plusmed3x3( neighborhood )
  local copy = {}
  
  --Shallow copy of the original pixel neighborhood
  copy[1] = neighborhood[2]
  copy[2] = neighborhood[4]
  copy[3] = neighborhood[5]
  copy[4] = neighborhood[6]
  copy[5] = neighborhood[8]
  
  --Sorts the array
  copy = util.quicksort( copy, 1, 5 )

  --Returns the median value
  return copy[3]
end

--[[

  * * * * Out-Of-Range Filter * * * *

Applies a range filter to all pixels within the image,
setting the intensity of each pixel to the surrounding 
neighborhood's average if the pixel intensity is not 
within a threshold difference of the neighborhood average.
This operation gets rid of noise by making every pixel
based on the pixels around it.

Convolution filter used:
       |  2  4  2  |         
1/24 * |  4  0  4  |            
       |  2  4  2  |            

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
            thresh - the threshold for determining out of range intensities
Returns:    the altered pixel intensity value

--]]
local function outofrange( neighborhood , thresh )
  local avg = 0
  local val = neighborhood[5]
  
    --Calculates the filtered rows for efficiency
  local row1 = 2 * neighborhood[1] + 4 * neighborhood[2] + 2 * neighborhood[3]
  local row2 = 4 * neighborhood[4] + 4 * neighborhood[6]
  local row3 = 2 * neighborhood[7] + 4 * neighborhood[8] + 2 * neighborhood[9]
  avg = row1 + row2 + row3
  
  --Finds the average
  avg = avg/ 24
  
  --Finds the difference between the center pixel intensity and the average
  local diff = math.abs(val - avg)
  
  --Returns average value if the difference is greater than the threshold
  --Otherwise the pixel intensity is unaffected
  if diff > thresh then return avg
  else return val end
end

-- Export all functions
return {
  smooth3x3 = smooth3x3,
  sharpen3x3 = sharpen3x3,
  plusmed3x3 = plusmed3x3,
  outofrange = outofrange
}