###################################################
###
##  File: woodwing.rb
##  Desc: API definitions for WoodWing products
#

require "url_safe_base64"
require 'rest_client'
require 'multi_json'

module WoodWing
  require_relative 'woodwing/version'
  require_relative 'woodwing/elvis'
end # module WoodWing

WW      = WoodWing        unless defined?(WW)
