module WoodWing
  class Elvis
    module Rest


      def move(source, target, options={})
        url = base_url + "move"
        options.merge!(source: source, target: target)
        get_response(url, options)
      end

      def copy(source, target, options={})
        url = base_url + "copy"
        options.merge!(source: source, target: target)
        get_response(url, options)
      end

    end # module Rest
  end # class Elvis
end # module WoodWing
