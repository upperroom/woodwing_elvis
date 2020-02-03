module WoodWing
  class Elvis
    module Rest


      # https://elvis.tenderapp.com/kb/api/rest-createauthkey
      def create_auth_key(options={})
        url = base_url + "createAuthKey"
        response = get_response_using_post(url, options)
      end # create_auth_key


      # https://elvis.tenderapp.com/kb/api/rest-update_auth_key
      def update_auth_key(options={})
        url = base_url + "updateAuthKey"
        response = get_response_using_post(url, options)
      end # update_auth_key

      alias :replace_auth_key :update_auth_key


      # https://elvis.tenderapp.com/kb/api/rest-revokeauthkeys
      def revoke_auth_keys(options={})
        url = base_url + "revokeAuthKeys"
        response = get_response_using_post(url, options)
      end # revoke_auth_keys


    end # module Rest
  end # class Elvis
end # module WoodWing
