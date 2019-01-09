--[[

  * * * * neighborhood.lua * * * *

File containing neighborhood isolation function and case statement 
function to run all necessary image processing operations.  The 
implementation chosen uses a "processNeighborhood" function that will 
take a neighborhood size and determine the associated pixel neighborhood 
for each pixel, passing it into the appropriate function.  This is to
prioritize coding maintenance over efficiency, allowing rapid addition 
and updating of neighborhood processes without a large amount of
duplicate code.

Author: Ryan Hinrichs and Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

require "ip"
local viz = require "visual"
local il = require "il"

--Documents containing image processing filters
local fixedFilters = require "fixedFilters"
local edgeFilters = require "edgeFilters"
local dynamicFilters = require "dynamicFilters"

--[[

  * * * * Shift Neighborhood * * * *

Shifts the neighborhood so the processNeighborhood does not 
redetermine every neighborhood value, only the last column 
of the neighborhood.

Author:     Ryan Hinrichs and Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
            size - size of the filter to be used. Specified by the user
Returns:    the shifted neighborhood

--]]
local function shiftNeighbor( neighborhood, size )
  local area = size * size
  
  --Shifts the neighborhood to the left one value
  for i = 1, area - 1 do
    neighborhood[i] = neighborhood[i + 1]
  end

  return neighborhood
end

--[[

  * * * * Filter Switch * * * *

Takes the neighborhood and sends it to the correct 
image processing filter function via a number 
specified by the main calling GUI.

Author:     Ryan Hinrichs and Zachery Crandall
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: neighborhood - table of the image neighborhood to be processed
            size - size of the filter to be used
            number - value that specifies the function to run on the neighborhood
            thresh - threshold used for the out of range filter
Returns:    the altered pixel

--]]
local function filterSwitch( neighborhood, number, size , thresh)
  local pixel = 0
  
  --Case statement to match number variable to appropriate filter
  if number == 1 then
    pixel = fixedFilters.smooth3x3( neighborhood )
  elseif number == 2 then
    pixel = fixedFilters.sharpen3x3( neighborhood )
  elseif number == 3 then
    pixel = fixedFilters.plusmed3x3( neighborhood )
  elseif number == 4 then
    pixel = fixedFilters.outofrange( neighborhood , thresh )
  elseif number == 5 then
    pixel = dynamicFilters.mean( neighborhood , size)
  elseif number == 6 then
    pixel = dynamicFilters.median( neighborhood , size)
  elseif number == 7 then
    pixel = dynamicFilters.min( neighborhood , size)
  elseif number == 8 then
    pixel = dynamicFilters.max( neighborhood , size)
  elseif number == 9 then
    pixel = dynamicFilters.range( neighborhood , size)
  elseif number == 10 then
    pixel = dynamicFilters.stdev( neighborhood , size)
  elseif number == 11 then
    pixel = edgeFilters.sobelMag3x3( neighborhood )
  elseif number == 12 then
    pixel = edgeFilters.sobelDir3x3( neighborhood )
  elseif number == 13 then
    pixel = edgeFilters.kirschMag3x3( neighborhood )
  elseif number == 14 then
    pixel = edgeFilters.kirschDir3x3( neighborhood )
  elseif number == 15 then
    pixel = edgeFilters.laplacian3x3( neighborhood )
  elseif number == 16 then
    pixel = edgeFilters.emboss3x3( neighborhood )
  elseif number == 17 then
    pixel = edgeFilters.embossScale3x3( neighborhood )
  end

  return pixel
end

--[[

  * * * * Process Neighborhood * * * *
 
Traverses the image, pixel by pixel, and allocates an array for the
neighborhood specifed by the size.  This neighborhood is passed into the 
filter switch, and the return value is placed into the output image.  It 
then shifts the neighborhood, fills the new neighborhood with the new 
pixel values, and repeats the process until the entire image has been 
processed.  Then, the altered image is returned.

Author:     Ryan Hinrichs
Class:      CSC442/542 Digital Image Processing
Date:       Spring 2017
Parameters: img - the image being processed
            filterNum - value specifying the function to run on the neighborhood
            size - size of the filter to be used. Specified by the user
            thresh - threshold used for the out of range filter
Returns:    outputImg - the altered image

--]]
local function processNeighborhood( img, filterNum, size, thresh)
  img = il.RGB2YIQ( img )
  local neighborhood = {}
  local index = 0
  local shift = (size - 1) / 2
  local pixel

  local row, col = img.height, img.width
  
  -- Clone the image
  local outputImg = img:clone()

  --Walks through the entire image, ignoring the edges
  for r = shift, row-1-shift do
    for c = shift, col-1-shift do
      --If the neighborhood is coming from the first column
      if c == shift then
        index = 0
        --Create the image array
        for i = -shift, shift do
          for j = -shift, shift do
            index = index + 1
            neighborhood[index] = img:at(r + i, c + j).ihs[0]
          end
        end
      else
        count = 1
        --Create the image array
        for i = -shift, shift do
          index = count * size
          count = count + 1
          neighborhood[index] = img:at(r + i, c + shift).ihs[0]
        end
      end

      --Sends the neighborhood to the filter switch and 
      --gets the pixel value
      pixel = filterSwitch( neighborhood, filterNum, size , thresh)
      
      --Places the altered pixel intensity value into the output image
      outputImg:at(r,c).ihs[0] = pixel
      
      --Shifts the neighborhood
      neighborhood = shiftNeighbor( neighborhood, size )
    end
  end
  
  --Returns the new altered image
  return il.YIQ2RGB( outputImg )
end

-- Export all functions
return{
  processNeighborhood = processNeighborhood,
}