###################################################
###
##  File: utilities.rb
##  Desc: Utilitie methods for working with the REST API
##        for WoodWing's Elvis product
#

require_relative 'utilities/pmask'

module WoodWing

class Utilities

  class << self


=begin
    # SMELL: Is this really necessary with RestClient ?
    def url_encode_options(options)
      raise "Invalid parameter class: expected Hash" unless Hash == options.class
      a_string  = ''
      first_one = true
      options.each_pair do |k, v|
        if first_one
          a_string += '?'
          first_one = false
        else
          a_string += '&'
        end
        # a_string += "#{k}=#{String == v.class ? v.gsub(' ','%20') : v}"
        a_string += "#{k}=#{URI::encode(v)}"
      end # options.each_pair
      #debug_me{:a_string} if debug?
      return a_string
    end # url_encode_options

=end

    # encode the username and password for use on the URL for login

    # SMELL: This is not necessary with a session-based logon/off system
    #        HOWEVER, it might still be useful for some cases.  Can this
    #        scheme and a session management scheme work together?

    def encode_login(username='guest', password='guest')

      {
        authcred:     UrlSafeBase64.encode64("#{username}:#{password}"),
        authpersist:  'true',
        authclient:   'api_ruby'
      }

    end # def encode_login(username='guest', password='guest')


    # raise ArgumentError if required options are not present

    def demand_required_options!(command, options)

      raise ArgumentError unless Symbol == command.class
      raise ArgumentError unless Hash == options.class
      raise ArgumentError unless WW::Rest::Elvis::COMMANDS.include?(command)

      required_options = WW::Rest::Elvis::COMMANDS[command][1]

      answer = true

      return(answer) if required_options.empty?

      required_options.each do |ro|
        answer &&= options.include?(ro)
      end

      raise "ArgumentError: #{caller.first.split().last} requires #{required_options.join(', ')}" unless answer

    end # def demand_required_options!(command, options)

  end # eigenclass

end # class Utilities

end # module WoodWing

