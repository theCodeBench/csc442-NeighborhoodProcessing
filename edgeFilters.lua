--[[

  * * * * edgeFilters.lua * * * *

File containing all edge detection neighborhood routines.

Author: Ryan Hinrichs and Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

require "ip"
local viz = require "visual"
local il = require "il"

local util = require "util"
local math = require "math"



--[[

  * * * * Sobel Magnitude * * * *

Applies Sobel filters to find the x and y partial derivatives of the image.
Once the filters are applied, the partial derivatives gx and gy are used
to approximate the magnitude. This is done using the formula:
sqrt( gx * gx + gy * gy ), which is then clipped to be within the range
[0, 255].

X filter used:            Y filter used: 
| -1  0  1  |             |  1  2  1  |
| -2  0  2  |             |  0  0  0  |
| -1  0  1  |             | -1 -2 -1  |

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
Returns:    the Sobel magnitude, clipped at [0, 255]

--]]
local function sobelMag3x3( neighborhood )
  local gx = 0
  local gy = 0

  -- Apply the Sobel filters to get the partial x and y derivatives
  gx = neighborhood[3] + 2 * neighborhood[6] + neighborhood[9] - neighborhood[1] - 2 * neighborhood[4] - neighborhood[7]
  gy = neighborhood[1] + 2 * neighborhood[2] + neighborhood[3] - neighborhood[7] - 2 * neighborhood[8] - neighborhood[9]

  -- Return the magnitude, clipped at 0 and 255
  return util.clip( math.sqrt( gx * gx + gy * gy ) )
end



--[[

  * * * * Sobel Direction * * * *

Applies Sobel filters to find the x and y partial derivatives of the image.
Once the filters are applied, the partial derivatives gx and gy are used
to approximate the direction. This is done using the formula:
arctan( gy / gx ), which is in radians. If this result is negative, 
2 * pi is added to it. It is then scaled using 255/360 as the scaling
factor and returned for display.

X filter used:            Y filter used: 
| -1  0  1  |             |  1  2  1  |
| -2  0  2  |             |  0  0  0  |
| -1  0  1  |             | -1 -2 -1  |

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
Returns:    the scaled Sobel direction angle in degrees

--]]
local function sobelDir3x3( neighborhood )
  local gx = 0
  local gy = 0
  local dir = 0
  local pi = math.pi

  -- Apply the Sobel filters to get the partial x and y derivatives
  gx = neighborhood[3] + 2 * neighborhood[6] + neighborhood[9] - neighborhood[1] - 2 * neighborhood[4] - neighborhood[7]
  gy = neighborhood[1] + 2 * neighborhood[2] + neighborhood[3] - neighborhood[7] - 2 * neighborhood[8] - neighborhood[9]

  -- Calculate arctan( gy / gx )
  dir = math.atan2( gy, gx )

  -- Offset negative numbers by 2 * pi to make them positive
  if dir < 0 then
    dir = dir + 2 * pi
  end

  -- Return the scaled result in degrees
  return ( 255 / 360 * util.rad2deg( dir ) )
end



--[[

  * * * * Kirsch Rotation * * * *

This function will calculate the new value when a 45 degree rotation is
applied to the Kirsch filter (ki) and it is applied to the specified neighborhood.

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
            ki - Kirsch filter to be rotated
            newMax - the previous maximum kirsch value found
            i - the index to be set to -3 after the rotation
            j - the index to be set to 5 after the rotation
Returns:    newMax - the new kirsch value found after the rotation

--]]
local function kirschRotate3x3( neighborhood, ki, prevMax, i, j)
  local newMax = 0

  -- Remove the value of the indices to be changed from the previous max value
  newMax = prevMax - neighborhood[i] * ki[i]
  newMax = newMax - neighborhood[j] * ki[j]

  -- Reassign values changed during rotation
  ki[i] = -3
  ki[j] = 5

  -- Add the new values calculated from the changed indices to the new max
  newMax = newMax + neighborhood[i] * ki[i]
  newMax = newMax + neighborhood[j] * ki[j]

  return newMax
end



--[[

  * * * * Kirsch Magnitude * * * *

This function determines the Kirsch magnitude for the neighborhood. This is
done by applying the eight rotations of the east Kirsch filter to the
neighborhood. The maximum value resulting from one of the eight masks is
scaled by 1/3 and returned.

Kirsch East filter used:
| -3 -3  5  |
| -3  0  5  |
| -3 -3  5  |

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
Returns:    the scaled Kirsch magnitude, clipped at [0, 255]

--]]
local function kirschMag3x3( neighborhood )
  local ki = { -3, -3, 5, -3, 0, 5, -3, -3, 5 }
  local max = 0
  local newMax = 0
  local maxIndex = 0

  -- Apply the east Kirsch filter
  for j = 1, 9 do
    max = max + neighborhood[j] * ki[j]
  end

  -- First rotation
  newMax = kirschRotate3x3( neighborhood, ki, max, 9, 2)

  if newMax > max then max = newMax end

  -- Second rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 6, 1)

  if newMax > max then max = newMax end

  -- Third rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 3, 4)

  if newMax > max then max = newMax end

  -- Fourth rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 2, 7)

  if newMax > max then max = newMax end

  -- Fifth rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 1, 8)

  if newMax > max then max = newMax end

  -- Sixth rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 4, 9)

  if newMax > max then max = newMax end

  -- Seventh rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 7, 6)

  if newMax > max then max = newMax end  

  return util.clip( max / 3 )
end



--[[

  * * * * Kirsch Direction * * * *

This function determines the Kirsch direction for the neighborhood. This is
done by applying the eight rotations of the east Kirsch filter to the
neighborhood. The angle of rotation associated with the Kirsch filter
that achieves the maximum value when applied to the neighborhood is found.
This angle is scaled using 255/360 and returned.

Kirsch East filter used:
| -3 -3  5  |
| -3  0  5  |
| -3 -3  5  |

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
Returns:    the scaled Kirsch direction angle

--]]
local function kirschDir3x3( neighborhood )
  local ki = { -3, -3, 5, -3, 0, 5, -3, -3, 5 }
  local max = 0
  local newMax = 0
  local angle = 0

  -- Apply the east Kirsch filter
  for j = 1, 9 do
    max = max + neighborhood[j] * ki[j]
  end

  -- Only alter the indices that will change in the rotation
  -- First rotation
  newMax = kirschRotate3x3( neighborhood, ki, max, 9, 2)

  if newMax > max then 
    max = newMax 
    angle = 45
  end

  -- Second rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 6, 1)

  if newMax > max then 
    max = newMax 
    angle = 45 * 2
  end

  -- Third rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 3, 4)

  if newMax > max then 
    max = newMax 
    angle = 45 * 3
  end

  -- Fourth rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 2, 7)

  if newMax > max then 
    max = newMax 
    angle = 45 * 4
  end

  -- Fifth rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 1, 8)

  if newMax > max then 
    max = newMax 
    angle = 45 * 5
  end

  -- Sixth rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 4, 9)

  if newMax > max then 
    max = newMax 
    angle = 45 * 6
  end

  -- Seventh rotation
  newMax = kirschRotate3x3( neighborhood, ki, newMax, 7, 6)

  if newMax > max then 
    max = newMax 
    angle = 45 * 7
  end

  return ( 255 / 360 * angle )
end



--[[

  * * * * Laplacian Zero Crossing * * * *

This function uses the 8 directional Laplacian filter to approximate
the second derivative of the specified neighborhood. This second 
derivative value is offset by 128, clipped at [0, 255], and returned.

Laplacian filter used:
| -1 -1 -1 |
| -1  8 -1 |
| -1 -1 -1 |

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
Returns:    the offset Laplacian value clipped at [0,255]

--]]
local function laplacian3x3( neighborhood )
  local row1, row2, row3
  local sum

  -- Apply laplacian filter
  row1 = -neighborhood[1] - neighborhood[2] - neighborhood[3]
  row2 = -neighborhood[4] + 8 * neighborhood[5] - neighborhood[6]
  row3 = -neighborhood[7] - neighborhood[8] - neighborhood[9]

  -- Sum the rows
  sum = row1 + row2 + row3

  -- Offset the sum by 128, clip it at 0 and 255
  return util.clip( sum + 128 )
end



--[[

  * * * * Image Embossing * * * *

This function uses the embossing filter shown below. This filter is
applied to the specified neighborhood and the result is offset by 128, 
clipped at [0, 255], and returned.

Emboss filter used:
|  1  1  0 |
|  1  0 -1 |
|  0 -1 -1 |

Author:     Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
Returns:    the offset embossing value clipped at [0,255]

--]]
local function emboss3x3( neighborhood )
  local row1, row2, row3
  local sum

  -- Apply emboss filter
  row1 = neighborhood[1] + neighborhood[2]
  row2 = neighborhood[4] - neighborhood[6]
  row3 = -neighborhood[8] - neighborhood[9]

  -- Sum the rows
  sum = row1 + row2 + row3

  -- Offset the sum by 128, clip it at 0 and 255
  return util.clip( sum + 128 )
end



-- Export all functions
return {
  sobelMag3x3 = sobelMag3x3,
  sobelDir3x3 = sobelDir3x3,
  kirschMag3x3 = kirschMag3x3,
  kirschDir3x3 = kirschDir3x3,
  laplacian3x3 = laplacian3x3,
  emboss3x3 = emboss3x3,
}