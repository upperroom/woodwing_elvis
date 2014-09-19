module WoodWing
  class Elvis
    module Rest


      # https://elvis.tenderapp.com/kb/api/rest-create_folder
      def create_folder(options={})
        Utilities.demand_required_options!( :create_folder, options )
        url = base_url + "createFolder"
        response = get_response(url, options)
      end # create_folder


      # https://elvis.tenderapp.com/kb/api/rest-remove
      def remove_folder(options={})
        Utilities.demand_required_options!( :remove_folder, options )
        url = base_url + "remove"
        response = get_response(url, options)
      end # remove_folder

      alias :delete_folder :remove_folder



    end # module Rest
  end # class Elvis
end # module WoodWing
