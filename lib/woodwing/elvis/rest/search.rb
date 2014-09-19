module WoodWing
  class Elvis
    module Rest


      # https://elvis.tenderapp.com/kb/api/rest-search
      # Search assets in Elvis using all of the powerful search functions provided
      # by the Elvis search engine. You can execute all possible queries and even
      # use faceted search.
      #
      # Returned information can be formatted as JSON, XML or HTML to support any
      # kind of environment for clients.
      #
      # Apart from all sorts of metadata about the assets, the results returned
      # by a search call also contain ready-to-use URLs to the thumbnail, preview
      # and original file. This makes it extremely easy to display rich visual results.
      #
      # http://yourserver.com/services/search
      #     ?q=<query>
      #     &start=<first result>
      #     &num=<max result hits to return>
      #     &sort=<comma-delimited sort fields>
      #     &metadataToReturn=<comma-delimited fields>
      #     &facets=<comma-delimited fields>
      #     &facet.<field>.selection=<comma-delimited values>
      #     &format=<json|xml|html>
      #     &appendRequestSecret=<true|false>
      #
      # Options
      #   q   (Required) The query to search for, see the query syntax guide
      #       for details.  https://elvis.tenderapp.com/kb/technical/query-syntax
      #       Recap:  supports wildcards: *? logical: AND && OR ||
      #               prefix terms with + to require - to remove
      #               suffix terms with ~ to include similar (eg. spelling errors)
      #               terms seperated by spaces default to an AND condition
      #               use "double quotes" to search for phrases.
      #               All searches are case insensitive.
      #
      #   start   First hit to be returned. Starting at 0 for the first hit. Used
      #           to skip hits to return 'paged' results. Optional. Default is 0.
      #
      #   num   Number of hits to return. Specify 0 to return no hits, this can be
      #         useful if you only want to fetch facets data. Optional. Default is 50.
      #
      #   sort  The sort order of returned hits. Comma-delimited list of fields to
      #         sort on.  By default, date/time fields and number fields are sorted
      #         descending. All other fields are sorted ascending. To explicitly
      #         specify sort order, append "-desc" or "-asc" to the field.
      #           Some examples:
      #             sort=name
      #             sort=rating
      #             sort=fileSize-asc
      #             sort=status,assetModified-asc
      #         A special sort case is "relevance". This lets the search engine
      #         determine sorting based on the relevance of the asset against
      #         the search query. Relevance results are always returned descending.
      #         Optional. Default is assetCreated-desc.
      #
      # metadataToReturn  Comma-delimited list of metadata fields to return in hits.
      #                   It is good practice to always specify just the metadata
      #                   fields that you need. This will make the searches faster
      #                   because less data needs to be transferred over the network.
      #                   Example: metadataToReturn=name,rating,assetCreated
      #                   Specify "all", or omit to return all available metadata.
      #                   Example:  metadataToReturn=all
      #                             metadataToReturn=
      #                   Optional. Default returns all fields.
      #
      # facets  Comma-delimited list fields to return facet for.
      #         Example: facets=tags,assetDomain
      #         Selected values for a facet must be specified with a
      #         "facet.<field>.selection" parameter. Do not add selected items to
      #         the query since that will cause incorrect facet filtering.
      #         Note: Only fields that are un_tokenized or tokenized with
      #         pureLowerCase analyzer can be used for faceted search
      #         Optional. Default returns no facets.
      #
      # facet.<field>.selection   Comma-delimited list of values that should
      #                           be 'selected' for a given facet.
      #                           Example:  facet.tags.selection=beach
      #                                     facet.assetDomain.selection=image,video
      #                           Optional.
      #
      # format  Response format to return, either json, xml or html.
      #         json  format is lightweight and very suitable for consumption
      #               using AJAX and JavaScript.
      #         html  format is the easiest way to embed results in HTML pages,
      #               but is heavier and less flexible than using a HitRenderer
      #               from our open-source JavaScript library.
      #         xml   format is the same as returned by the Elvis SOAP webservice
      #               search operation. This format is suitable for environments
      #               that do not support JSON parsing and work better with XML.
      #               When you use format=xml, error responses will also be returned
      #               in xml format.
      #         Optional. Default is json.
      #
      #   appendRequestSecret   When set to true will append an encrypted code to
      #                         the thumbnail, preview and original URLs. This is
      #                         useful when the search is transformed to HTML by an
      #                         intermediary (like a PHP or XSLT) and is then served
      #                         to a web browser that is not authenticated against
      #                         the server.
      #                         Optional. Default is false.
      #
      # RETURNED VALUE
      # ==============
      #
      # An array of hits in JSON, XML or HTML format. Each item in the array has
      # the following properties.
      #
      #   firstResult     Index of the first result that is returned.
      #   maxResultHits   Maximum number of hits that are returned.
      #   totalHits       Total hits found by the search.
      #
      # hits
      #
      #   id            Unique ID of the asset in Elvis.
      #   permissions   String that indicates the permissions the current user has
      #                 for the asset.
      #   thumbnailUrl  A ready to use URL to display the thumbnail of an asset.
      #                 Only available for assets that have a thumbnail.
      #   previewUrl    A ready to use URL to display the default preview of an
      #                 asset. The type of preview depends on the asset type.
      #                 Only available for assets that have a preview.
      #   originalUrl   A ready to use URL to download the original asset.
      #                 This URL will only work if the user has the 'use original'
      #                 permission for this asset. This can be checked with the
      #                 'permissions' property.
      #   metadata      An object with metadata that was requested to be returned.
      #                 Some metadata will always be returned.
      #
      # Fields that have date or datetime values and the field fileSize contain
      # both the actual numerical value and a formatted value.

      def search(options={})

        Utilities.demand_required_options!( :search, options )
        url = base_url + "search"

        # NOTE: One element of metadata is 'textContent' for books and
        #       large articles that is a LOT of text. The following
        #       line changes the default from 'all' to 'status,name'.
        #       If you want all metadata then you have to request
        #       'all' in your options.

        options   = { metadataToReturn: 'status,name' }.merge(options)
        response  = get_response(url, options)

      end # search

      alias :find :search


    end # module Rest
  end # class Elvis
end # module WoodWing
