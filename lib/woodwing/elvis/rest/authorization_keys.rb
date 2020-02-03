module WoodWing
  class Elvis
    module Rest


      # https://elvis.tenderapp.com/kb/api/rest-createauthkey
      def create_auth_key(options={})
        url = base_url + "create_auth_key"
        response = get_response(url, options)
      end # create_auth_key


      # https://elvis.tenderapp.com/kb/api/rest-update_auth_key
      def update_auth_key(options={})
        url = base_url + "update_auth_key"
        response = get_response(url, options)
      end # update_auth_key

      alias :replace_auth_key :update_auth_key


      # https://elvis.tenderapp.com/kb/api/rest-revokeauthkeys
      def revoke_auth_keys(options={})
        url = base_url + "revoke_auth_keys"
        response = get_response(url, options)
      end # revoke_auth_keys


    end # module Rest
  end # class Elvis
end # module WoodWing
