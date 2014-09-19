module WoodWing
  class Elvis
    module Rest


      # https://elvis.tenderapp.com/kb/api/rest-browse
      #
      # browse folders and show their subfolders and collections,
      # similar to how folder browsing works in the Elvis desktop client.
      #
      # Note: Even though it is possible to return the assets in folders,
      #       doing so is not advised. The browse call does not limit the
      #       number of results, so if there are 10000 assets in a folder
      #       it will return all of them. It is better to use a search to
      #       find the assets in a folder and fetch them in pages.
      #
      # http://yourserver.com/services/browse
      #   ?path=<assetPath>
      #   &fromRoot=<folderPath>
      #   &includeFolders=<true|false>
      #   &includeAssets=<true|false>
      #   &includeExtensions=<comma-delimited extensions>
      #
      # Options
      #   path    (Required) The path to the folder in Elvis you want to list.
      #           Make sure the URL is properly URL-encoded, for example: spaces should
      #           often be represented as %20.
      #
      #   fromRoot  Allows returning multiple levels of folders with their
      #             children. When specified, this path is listed, and all folders
      #             below it up to the 'path' will have their children returned as well.
      #
      #             This ability can be used to initialize an initial path in a
      #             column tree folder browser with one server call.
      #
      #             Optional. When not specified, only the children of the specified
      #             'path' will be returned.
      #
      #             Available since Elvis 2.6
      #
      #   includeFolders  Indicates if folders should be returned.
      #                   Optional. Default is true.
      #
      #   includeAsset  Indicates if files should be returned.
      #                 Optional. Default is true, but filtered to
      #                 only include 'container' assets.
      #
      #   includeExtensions   A comma separated list of file extensions to
      #                       be returned. Specify 'all' to return all file types.
      #                       Optional. Default includes all 'container'
      #                       assets: .collection, .dossier, .task

      def browse(options={})

        Utilities.demand_required_options!( :browse, options )

        url      = base_url + "browse"
        response = get_response(url, options)

      end # browse


    end # module Rest
  end # class Elvis
end # module WoodWing
