module WoodWing
  class Elvis
    module Rest


      # https://elvis.tenderapp.com/kb/api/rest-checkout
      def checkout(options={})
        url = base_url + "checkout"
        response = get_response(url, options)
      end # checkout


      # https://elvis.tenderapp.com/kb/api/rest-undo_checkout
      def undo_checkout(options={})
        url = base_url + "undo_checkout"
        response = get_response(url, options)
      end # undo_checkout

      alias :abort_checkout :undo_checkout


    end # module Rest
  end # class Elvis
end # module WoodWing
