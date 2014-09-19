###################################################
###
##  File: rest.rb
##  Desc: REST API definitions for WoodWing's Elvis
#

module WoodWing
  class Elvis

module Rest

  require_relative 'rest/authorization_keys'
  require_relative 'rest/browse'
  require_relative 'rest/checkout'
  require_relative 'rest/create'
  require_relative 'rest/create_elvislink'
  require_relative 'rest/login_logout'
  require_relative 'rest/relations'
  require_relative 'rest/search'
  require_relative 'rest/stub'

end # module WoodWing::Elvis::Rest

include Rest

end # class Elvis
end # module WoodWing

WW      = WoodWing        unless defined?(WW)
WwElvis = WoodWing::Elvis unless defined?(WwElvis)
