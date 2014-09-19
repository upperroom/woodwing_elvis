###################################################
###
##  File: woodwing.rb
##  Desc: API definitions for WoodWing products
#

module WoodWing
  require_relative 'woodwing/version'
  require_relative 'woodwing/elvis'
end # module WoodWing

WW      = WoodWing        unless defined?(WW)
