module WoodWing
  class Elvis
    module Rest


      # Check out an asset.  Optionally download it, too.
      # @see https://helpcenter.woodwing.com/hc/en-us/articles/206334175-Elvis-4-REST-API-checkout
      #
      # @param [String] assetId the Elvis ID of the asset to check out
      # @param [Hash] options additional options for the request
      # @option options [Boolean] :download whether to download the asset
      #
      # @return [Hash, String] a hash with the result of the API call, or a string with the contents of the file if it was succesfully downloaded
      def checkout(assetId, options={})
        url = base_url + "checkout/" + assetId
        response = get_response_using_post(url, options)
      end # checkout

      # Cancel the checkout of an asset.
      # @see https://helpcenter.woodwing.com/hc/en-us/articles/206334265-Elvis-4-REST-API-undo-checkout
      #
      # @param [String] assetId The Elvis ID of the asset to undo check out
      #
      # @return [Hash] a hash with the result of the API call
      def undo_checkout(assetId)
        url = base_url + "undocheckout/" + assetId
        response = get_response(url)
      end # undo_checkout

      alias :abort_checkout :undo_checkout


    end # module Rest
  end # class Elvis
end # module WoodWing
