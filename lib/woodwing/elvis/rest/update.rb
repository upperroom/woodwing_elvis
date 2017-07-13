require 'rest-client'

module WoodWing
  class Elvis
    module Rest

      # Update an existing asset in Elvis with a new file and/or with new metadata.
      # @see https://helpcenter.woodwing.com/hc/en-us/articles/205635069
      #
      # @param [String] id the Elvis ID of the asset to be updated
      # @option [File] :Filedata new file
      # @option [Hash] :metadata a hash with metadata to be updated. the keys should be Elvis metadata field names.
      # @options [String] :metadataToReturn comma-delimited list of metadata fields to return in hits
      def update(id, options)
        url = base_url + "update"
        options.merge!(id: id)
        get_response_using_post(url, options)
      end


    end # module Rest
  end # class Elvis
end # module WoodWing
