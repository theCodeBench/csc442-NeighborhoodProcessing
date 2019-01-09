--[[

  * * * * main.lua * * * *

Lua image processing main file start the image processing
window. All menu options are defined here.

Author: Ryan Hinrichs and Zachery Crandall
Class: CSC442/542 Digital Image Processing
Date: Spring 2017

--]]

require "ip"
local viz = require "visual"
local il = require "il"

-- Our routines
local processing = require "processingWrappers"


-- load images listed on command line
local imgs = {...}
for i, fname in ipairs(imgs) do loadImage(fname) end



-- Menu and menu options for point processes required
viz.imageMenu( "Point Processes",
  {
    {"Convert to Greyscale", il.grayscaleYIQ},
    {"Display Image Histogram", il.showHistogramRGB},
    {"Contrast Stretch", il.contrastStretch,
      { {name = "Minimum", type = "number", displaytype = "spin", 
          default = 0, min = 0, max = 100},
        {name = "Maximum", type = "number", displaytype = "spin",
          default = 100, min = 0, max = 100}}},
    {"Histogram Equalization", il.equalizeRGB},
    {"Binary Threshold", il.threshold, {{name = "Threshold", type = "number", displaytype = "textbox", default = "126.0"}}},
    {"Gaussian Noise", il.gaussianNoise,
      { {name = "Sigma", type = "number", displaytype = "spin", default = 1, min = 0, max = 10}}},
    {"Impulse Noise", il.negate,
      { {name = "Probability", type = "number", displaytype = "spin", default = 50, min = 0, max = 100}}},
  }
)

-- Menu and menu options for neighborhood filters
viz.imageMenu( "Neighborhood Filters",
  {
    {"3x3 Smooth Filter", processing.smooth},
    {"3x3 Sharpening Filter", processing.sharpen},
    {"3x3 Plus-shaped Median Filter", processing.plusmed},
    {"3x3 Out-of-Range Noise Cleaning Filter", processing.oor, {{name = "Threshold", type = "number", displaytype = "textbox", default = "126.0"}}},
    {"Mean Filter", processing.dymean, {{name = "Dimension of filter", type = "number", displaytype = "textbox", default = "3"}}},
    {"Median Filter", processing.dymedian, {{name = "Dimension of filter", type = "number", displaytype = "textbox", default = "3"}}},
    {"Minimum Filter", processing.dymin, {{name = "Dimension of filter", type = "number", displaytype = "textbox", default = "3"}}},
    {"Maximum Filter", processing.dymax, {{name = "Dimension of filter", type = "number", displaytype = "textbox", default = "3"}}},
    {"Range Filter", processing.dyran, {{name = "Dimension of filter", type = "number", displaytype = "textbox", default = "3"}}},
    {"St. Dev. Filter", processing.dystdev, {{name = "Dimension of filter", type = "number", displaytype = "textbox", default = "3"}}},
  }
)



-- Menu and menu options for edge operators
viz.imageMenu( "Edge Operators",
  {
    {"Sobel Edge Magnitude", processing.sobelMag},
    {"Sobel Edge Direction", processing.sobelDir},
    {"Kirsch Edge Magnitude", processing.kirschMag},
    {"Kirsch Edge Direction", processing.kirschDir},
    {"Laplacian Edge Op", processing.laplacian},
    {"Emboss Image", processing.emboss},
  }
)



-- Menu and menu options for program help
viz.imageMenu( "Help",
  {
    {"About", viz.imageMessage( "PA2", "Authors: Ryan Hinrichs and Zachery Crandall\nClass: CSC442/542 Digital Image Processing\nDate: March 16, 2017" ) },
  }
)

-- Open window to begin
start()