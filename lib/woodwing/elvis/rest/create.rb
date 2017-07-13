module WoodWing
  class Elvis
    module Rest


      # https://elvis.tenderapp.com/kb/api/rest-create
      # Upload and create an asset.
      #
      # This call will create a new asset in Elvis. It can be used to upload files
      # into Elvis. It can also be used to create 'virtual' assets like collections.
      # In that case no file has to be uploaded and Elvis will create a 0 kb
      # placeholder for the virtual asset.
      #
      # When you want to create a new asset, certain metadata is required. The
      # metadata is needed to determine where the file will be stored in Elvis.
      #
      # http://yourserver.com/services/create
      #   ?Filedata=<multipart/form-data encoded file>
      #   &metadata=<JSON encoded metadata>
      #   &<Elvis metadata field name>=<value>
      #   &nextUrl=<next URL>
      #
      # Options
      #
      #   Filedata  The file to be created in Elvis.  If you do not specify a
      #             filename explicitly through the metadata, the filename of
      #             the uploaded file will be used.
      #             NOTE: The parameter is named "Filedata" because that is the
      #                   standard name used by flash uploads. This makes it easy
      #                   to use flash uploaders to upload batches of files to Elvis.
      #             Optional. If omitted, a 0kb placeholder file will be created.
      #             See the method create_collection()
      #
      #   metadata  A JSON encoded object with properties that match Elvis metadata
      #             field names. This metadata will be set on the asset in Elvis.
      #             Optional. You can also use parameters matching Elvis field names.
      #
      #   *   Any parameter matching an Elvis metadata field name will be used as
      #       metadata. This metadata will be set on the asset in Elvis.
      #       Optional. You also use the 'metadata' parameter.
      #
      #   nextUrl   When specified, the service will send a 301 redirect to this
      #             URL when it is completed successfully. If you place '${id}' in
      #             the URL, it will be replaced with the Elvis asset id of the
      #             created asset.
      #             Optional. If omitted, a simple 200 OK status code will be returned

      def create(options={})

        Utilities.demand_required_options!( :create, options )

        # SMELL:  Don't think this is required since last change to
        #         get_response_with_post
        options.merge!( { multipart: true } )

        url       = base_url + "create"
        response  = get_response_using_post(url, options)

      end # create

      alias :create_file :create
      alias :upload_file :create
      alias :import_file :create
      alias :create_asset :create
      alias :upload_asset :create
      alias :import_asset :create


      def create_folder(path)
        url = base_url + 'createFolder'
        get_response(url, {path: path})
      end


    end # module Rest
  end # class Elvis
end # module WoodWing
