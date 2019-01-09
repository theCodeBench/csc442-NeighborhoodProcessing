--[[

  * * * * processingWrappers.lua * * * *

File containing all wrappers for image processing operations.

Author: Ryan Hinrichs and Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

require "ip"
local viz = require "visual"
local il = require "il"

local neighborhood = require "neighborhood"



--[[

  * * * * Smoothing Filter Wrapper * * * *

This function makes a call to the main neighborhood processing
function, processNeighborhood, passing in the correct enumeration
for the smoothing operation and neighborhood size necessary.

Author:     Ryan Hinrichs and Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function smooth( img )
  img = neighborhood.processNeighborhood( img , 1 , 3 )
  return img
end



--[[

  * * * * Sharpening Filter Wrapper * * * *

This function makes a call to the main neighborhood processing
function, processNeighborhood, passing in the correct enumeration
for the sharpening operation and neighborhood size necessary.

Author:     Ryan Hinrichs and Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function sharpen( img )
  img = neighborhood.processNeighborhood( img , 2 , 3 )
  return img
end



--[[

  * * * * Plus-shaped Median Filter Wrapper * * * *

This function makes a call to the main neighborhood processing
function, processNeighborhood, passing in the correct enumeration
for the plus-shaped median operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function plusmed( img )
  img = neighborhood.processNeighborhood( img , 3, 3 )
  return img
end



--[[

  * * * * Out-of-Range Filter Wrapper * * * *

This function makes a call to the main neighborhood processing
function, processNeighborhood, passing in the correct enumeration
for the out-of-range filter operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
            thresh - the threshold for the range
Returns:    img - the altered image

--]]
local function oor( img , thresh )
  img = neighborhood.processNeighborhood( img, 4, 3, thresh)
  return img
end



--[[

  * * * * n x n Mean Filter Wrapper * * * *

This function makes a call to the main neighborhood processing
function, processNeighborhood, passing in the correct enumeration
for the n x n mean operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function dymean( img , size )
  img = neighborhood.processNeighborhood( img , 5 , size )
  return img
end



--[[

  * * * * n x n Median Filter Wrapper * * * *

This function makes a call to the main neighborhood processing
function, processNeighborhood, passing in the correct enumeration
for the n x n median operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function dymedian( img , size )
  img = neighborhood.processNeighborhood( img , 6 , size )
  return img
end



--[[

  * * * * n x n Minimum Filter Wrapper * * * *

This function makes a call to the main neighborhood processing
function, processNeighborhood, passing in the correct enumeration
for the n x n minimum operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function dymin( img , size )
  img = neighborhood.processNeighborhood( img , 7, size )
  return img
end



--[[

  * * * * n x n Maximum Filter Wrapper * * * *

This function makes a call to the main neighborhood processing
function, processNeighborhood, passing in the correct enumeration
for the n x n maximum operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function dymax( img , size )
  img = neighborhood.processNeighborhood( img , 8, size )
  return img
end



--[[

  * * * * n x n Range Filter Wrapper * * * *

This function makes a call to the main neighborhood processing
function, processNeighborhood, passing in the correct enumeration
for the n x n range operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function dyran( img , size )
  img = neighborhood.processNeighborhood( img , 9, size )
  img = il.grayscaleIHS( img )
  return img
end



--[[

  * * * * n x n Standard Deviation Filter Wrapper * * * *

This function makes a call to the main neighborhood processing
function, processNeighborhood, passing in the correct enumeration
for the n x n standard deviation operation and neighborhood size 
necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function dystdev( img , size )
  img = neighborhood.processNeighborhood( img , 10, size )
  return img
end



--[[

  * * * * Sobel Magnitude Wrapper * * * *

This function converts the specified image to grayscale. It then
makes a call to the main neighborhood processing function, 
processNeighborhood, passing in the correct enumeration
for the Sobel magnitude operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function sobelMag( img )
  img = il.grayscaleYIQ( img )
  img = neighborhood.processNeighborhood( img, 11, 3 )
  return img
end



--[[

  * * * * Sobel Direction Wrapper * * * *

This function converts the specified image to grayscale. It then
makes a call to the main neighborhood processing function, 
processNeighborhood, passing in the correct enumeration
for the Sobel direction operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function sobelDir( img )
  img = il.grayscaleYIQ( img )
  img = neighborhood.processNeighborhood( img, 12, 3 )
  return img
end



--[[

  * * * * Kirsch Magnitude Wrapper * * * *

This function converts the specified image to grayscale. It then
makes a call to the main neighborhood processing function, 
processNeighborhood, passing in the correct enumeration
for the Kirsch magnitude operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function kirschMag( img )
  img = il.grayscaleYIQ( img )
  img = neighborhood.processNeighborhood( img, 13, 3 )
  return img
end



--[[

  * * * * Kirsch Direction Wrapper * * * *

This function converts the specified image to grayscale. It then
makes a call to the main neighborhood processing function, 
processNeighborhood, passing in the correct enumeration
for the Kirsch direction operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function kirschDir( img )
  img = il.grayscaleYIQ( img )
  img = neighborhood.processNeighborhood( img, 14, 3 )
  return img
end



--[[

  * * * * Laplacian Zero Crossing Wrapper * * * *

This function converts the specified image to grayscale. It then
makes a call to the main neighborhood processing function, 
processNeighborhood, passing in the correct enumeration
for the Laplacian zero crossing operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function laplacian( img )
  img = neighborhood.processNeighborhood( img, 15, 3 )
  return img
end



--[[

  * * * * Embossing Wrapper * * * *

This function converts the specified image to grayscale. It then
makes a call to the main neighborhood processing function, 
processNeighborhood, passing in the correct enumeration
for the embossing operation and neighborhood size necessary.

Author:     Zachery Crandall and Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image to which the operation will be applied
Returns:    img - the altered image

--]]
local function emboss( img )
  img = neighborhood.processNeighborhood( img, 16, 3 )
  return img
end



-- Export all functions
return {
  smooth = smooth,
  sharpen = sharpen,
  plusmed = plusmed,
  oor = oor,
  dymean = dymean,
  dymedian = dymedian,
  dymax = dymax,
  dymin = dymin,
  dyran = dyran,
  dystdev = dystdev,
  sobelMag = sobelMag,
  sobelDir = sobelDir,
  kirschMag = kirschMag,
  kirschDir = kirschDir,
  laplacian = laplacian,
  emboss = emboss,
}