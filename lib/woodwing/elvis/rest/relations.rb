module WoodWing
  class Elvis
    module Rest


      # https://elvis.tenderapp.com/kb/api/rest-create_relation
      def create_relation(options={})
        url = base_url + "create_relation"
        response = get_response(url, options)
      end # create_relation


      # https://elvis.tenderapp.com/kb/api/rest-remove_relation
      def remove_relation(options={})
        url = base_url + "remove_relation"
        response = get_response(url, options)
      end # remove_relation

      alias :delete_relation :remove_relation


    end # module Rest
  end # class Elvis
end # module WoodWing
