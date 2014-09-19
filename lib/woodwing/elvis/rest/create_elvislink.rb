module WoodWing
  class Elvis
    module Rest

=begin

  Create an '.elvislink' file

  http://elvis.example.com/elvislink
      /yourfilename.elvislink
      ?action=openAuthkey | openAssets | openContainers
             | activateContainers | openSearch | openBrowse
      &key=<authkey to open and link to the user>
      &containerIds=<collection id's to open or activate>
      &assetIds=<assets to open>
      &q=<query for search>
      &sort=<sort for search>
      &folderPath=<folderPath to open>
      &includeSubFolders=true|false

  What does it do?

  Produce an '*.elvislink' file that will open the desktop client and perform an action. Some actions that can be performed:

      Show results sent by an email link (authkey).
      Open a search.
      Show a specific asset.

  Available since Elvis 2.6

  Parameters

  action    The action that should be performed when the link file is opened in
            the desktop client.
            See the elvisContext functions for the possible actions.
            Optional. Not needed when you specify the 'key' parameter. In that case the
            openAuthkey action is automatically used.

  key       An authkey to be opened and displayed in the desktop client. The
            permissions granted by the authkey will be linked to the user when opened.
            Optional. Only needed if you want to open an authkey.

  other parameters  For detailed descriptions of the other parameters, see the
  elvisContext functions.

  Return value

  The service produces an XML file with the extension '.elvislink'. The file also includes the server URL so the desktop client can connect to the correct server.

  Examples

  openAuthkey   elvislink

    http://demo.elvisdam.com/elvislink
        ?key=9T_WLil348lBtFk8FDTwPN

    This URL generates: openAuthkey-2011_11_328-144355.elvislink

    <?xml version="1.0" encoding="UTF-8"?>
    <elvisLink serverUrl="http://demo.elvisdam.com">
        <openAuthkey authkey="9T_WLil348lBtFk8FDTwPN"/>
    </elvisLink>

  openSearch  elvislink

    http://demo.elvisdam.com/elvislink/openBeaches.elvislink
        ?action=openSearch&q=beach&sort=name

    This URL generates: openBeaches.elvislink

    <?xml version="1.0" encoding="UTF-8"?>
    <elvisLink serverUrl="http://demo.elvisdam.com">
        <openSearch q="beach" sort="name"/>
    </elvisLink>

  openBrowse  elvislink

    http://demo.elvisdam.com/elvislink/openTrailers.elvislink
        ?action=openBrowse
        &folderPath=/Demo Zone/Videos/Movie Trailers
        &includeSubFolders=true
        &sort=assetCreated

    This URL generates: openTrailers.elvislink

    <?xml version="1.0" encoding="UTF-8"?>
    <elvisLink serverUrl="http://demo.elvisdam.com">
        <openBrowse folderPath="/Demo Zone/Videos/Movie Trailers"
                    includeSubFolders="true" sort="assetCreated"/>
    </elvisLink>

  openAssets  elvislink

    http://demo.elvisdam.com/elvislink
        ?action=openAssets
        &assetIds=Bg7fObz1aVr96wy97riUad,0l2ZhcAfK779hCXqTf2E7s

    This URL generates: openAssets-2011_11_328-140254.elvislink

    <?xml version="1.0" encoding="UTF-8"?>
    <elvisLink serverUrl="http://demo.elvisdam.com">
        <openAssets assetIds="Bg7fObz1aVr96wy97riUad,0l2ZhcAfK779hCXqTf2E7s"/>
    </elvisLink>

  openContainers  elvislink

    http://demo.elvisdam.com/elvislink/openCollections.elvislink
        ?action=openContainers
        &containerIds=0JkPrbQc40g8RQIC1NI6uo,6BN2FRaCqyLA5DjJJdB9h4
        &sort=name

    This URL generates: openCollections.elvislink

    <?xml version="1.0" encoding="UTF-8"?>
    <elvisLink serverUrl="http://demo.elvisdam.com">
        <openContainers
                    containerIds="0JkPrbQc40g8RQIC1NI6uo,6BN2FRaCqyLA5DjJJdB9h4"
                    sort="name"/>
    </elvisLink>

  activateContainers  elvislink

    http://demo.elvisdam.com/elvislink
        ?action=activateContainers
        &containerIds=0JkPrbQc40g8RQIC1NI6uo,6BN2FRaCqyLA5DjJJdB9h4

    This URL generates: activateContainers-2011_11_328-142851.elvislink

    <?xml version="1.0" encoding="UTF-8"?>
    <elvisLink serverUrl="http://demo.elvisdam.com">
        <activateContainers
                    containerIds="0JkPrbQc40g8RQIC1NI6uo,6BN2FRaCqyLA5DjJJdB9h4"/>
    </elvisLink>

=end

      def create_elvislink(options)

        Utilities.demand_required_options!( :elvislink, options )

        url       = base_url + "elvislink"
        response  = get_response_using_get(url, options)

      end # def create_elvislink(options)

    end # module Rest
  end # class Elvis
end # module WoodWing
