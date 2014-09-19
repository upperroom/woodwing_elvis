###################################################
###
##  File: rest.rb
##  Desc: REST API definitions for WoodWing's Elvis
#

require_relative 'elvis/rest'
require_relative 'elvis/soap'

module WoodWing

# Elvis is a Digital Asset Manager implemented in Java
class Elvis

  attr_accessor :base_url
  attr_accessor :cookies

  # SMELL: Why is this error any more special than the others?
  class ConcurrentModificationException < StandardError; end
  class NotLoggedIn < StandardError; end


  COMMANDS = {
    # method name           URL Resource        Required Parameters
    browse:                 ["browse",          [:path]],
    checkout:               ["checkout",        []],
    copy:                   ["copy",            [:source, :target]],
    create:                 ["create",          [:assetPath, :Filedata]],
    create:                 ["create",          [:Filedata]],
    create_auth_key:        ["create_auth_key", []],
    create_collection:      ["create",          [:assetPath]],
    create_relation:        ["create_relation", []],
    create_folder:          ["createFolder",    [:path]],
    localization:           ["localization",    []],
    log_usage_stats:        ["log_usage_stats", []],
    login:                  ["login",           [:username, :password]],
    logout:                 ["logout",          []],
    move:                   ["move",            [:source, :target]],
    profile:                ["profile",         []],
    query_stats:            ["queryStats",      []],
    remove_bulk:            ["remove",          [:q]],
    remove_bulk_ids:        ["remove",          [:ids]],
    remove_folder:          ["remove",          [:folderPath]],
    remove_relation:        ["remove_relation", []],
    revoke_auth_keys:       ["revoke_auth_keys",[]],
    search:                 ["search",          [:q]],
    undo_checkout:          ["undo_checkout",   []],
    update:                 ["update",          [:Filedata, :id]],
    update_metadata:        ["update",          [:id, :metadata]],
    update_auth_key:        ["update_auth_key", []],
    update_bulk_metadata:   ["updatebulk",      [:q, :metadata]],
    zip_download:           ["zip_download",    []]
  }



  def initialize( my_base_url=ENV['ELVIS_API_URL'],
                  my_cookies={})

    @base_url     = my_base_url
    @cookies      = my_cookies

    @base_url += '/'  unless @base_url.end_with?('/')

  end


  # Use RestClient.get

  def get_response(url=nil,options={})

    raise NotLoggedIn unless logged_in?  ||  url.end_with?('login')

    response = RestClient.get(url, { params: options, cookies: @cookies })

if $DEBUG
    debug_me(){[:url, :options, :response ]}
    debug_me(){[ 'response.code', 'response.cookies', 'response.body' ]}
end

    @cookies = response.cookies unless response.cookies.empty?

    response = MultiJson.load(  response.body,
                                :symbolize_keys => true)

    if response.include?(:errorcode)
      if 401 == response[:errorcode]     &&
        response[:message].include?('ConcurrentModificationException')
        raise ConcurrentModificationException
      else
        error_condition = "ERROR #{response[:errorcode]}: #{response[:message]}"
        raise error_condition
      end
    end

    return response
  end


  # SMELL: This is sooooo close to #get_response
  # Use RestClient.post

  def get_response_using_post(url=nil,options={})

     raise NotLoggedIn unless logged_in?  ||  url.end_with?('login')

    response = RestClient.post( url, options, { cookies: @cookies } )

if $DEBUG
    debug_me(){[:url, :options, :response ]}
    debug_me(){[ 'response.code', 'response.cookies', 'response.body' ]}
end

    @cookies = response.cookies unless response.cookies.empty?

    response = MultiJson.load(  response.body,
                                :symbolize_keys => true)

    if response.include?(:errorcode)
      if 401 == response[:errorcode]     &&
        response[:message].include?('ConcurrentModificationException')
        raise ConcurrentModificationException
      else
        error_condition = "ERROR #{response[:errorcode]}: #{response[:message]}"
        raise error_condition
      end
    end

    return response

  end


  # https://elvis.tenderapp.com/kb/api/rest-copy
  def copy(options={})
    Utilities.demand_required_options!( :copy, options )
    url = base_url + "copy"
    response = get_response(url, options)
  end # copy


  # No file is uploaded.  A placehold asset is created with the
  # associated metadata
  def create_collection(options={})
    Utilities.demand_required_options!( :create_collection, options )
    url = base_url + "create"
    options.merge!( {assetType: 'collection'} )
    response = get_response(url, options)
  end # create


  # https://elvis.tenderapp.com/kb/api/rest-localization
  def localization(options={})
    url = base_url + "localization"
    response = get_response(url, options)
  end # localization


  # https://elvis.tenderapp.com/kb/api/rest-log_usage_stats
  def log_usage_stats(options={})
    url = base_url + "log_usage_stats"
    response = get_response(url, options)
  end # log_usage_stats


  # https://elvis.tenderapp.com/kb/api/rest-move
  def move(options={})
    Utilities.demand_required_options!( :move, options )
    url = base_url + "move"
    response = get_response(url, options)
  end # move

  alias :rename :move


  # https://elvis.tenderapp.com/kb/api/rest-profile
  def profile(options={})
    url = base_url + "profile"
    response = get_response(url, options)
  end # profile


  # https://elvis.tenderapp.com/kb/api/rest-query_stats
  def query_stats(options={})
    url = base_url + "queryStats"
    response = get_response(url, options)
  end # query_stats


  # https://elvis.tenderapp.com/kb/api/rest-remove
  # can delete one or more using list of IDs or a search query
  # pr a folderPath.  The folderPath process has been abstracted
  # into #remove_folder.

  def remove_bulk(options={})
    Utilities.demand_required_options!( :remove_bulk, options )
    url       = base_url + "remove"
    response  = get_response(url, options)
  end # remove

  alias :delete_bulk :remove_bulk


  # https://elvis.tenderapp.com/kb/api/rest-remove
  # can delete one or more using list of IDs or a search query
  # pr a folderPath.  The folderPath process has been abstracted
  # into #remove_folder.

  def remove_bulk_ids(options={})
    Utilities.demand_required_options!( :remove_bulk_ids, options )
    url       = base_url + "remove"
    response  = get_response(url, options)
  end # remove

  alias :delete_bulk_ids :remove_bulk_ids


  # https://elvis.tenderapp.com/kb/api/rest-update
  # used to update assets and metadata
  def update(options={})
    Utilities.demand_required_options!( :update, options )
    url = base_url + "update"
    response = get_response(url, options)
  end # update

  alias :replace        :update
  alias :update_asset   :update
  alias :replace_asset  :update


  # https://elvis.tenderapp.com/kb/api/rest-update
  # used to update metadata for a specific asset referenced by 'id'

  def update_metadata(options={})
    Utilities.demand_required_options!( :update, options )
    options[:metadata] = options[:metadata].to_json
    url       = base_url + "update"
    response  = get_response(url, options)
  end # update

  alias :replace_metadata :update_metadata


  # https://elvis.tenderapp.com/kb/api/rest-updatebulk
  # updates metadata fields for all assets matching a specific query
  def update_bulk_metadata(options={})
    Utilities.demand_required_options!( :update_bulk_metadata, options )
    options[:metadata] = options[:metadata].to_json
    url       = base_url + "updatebulk"
    response  = get_response(url, options)
  end # update_bulk

  alias :bulk_update_metadata   :update_bulk_metadata
  alias :bulk_replace_metadata  :update_bulk_metadata
  alias :replace_bulk_metadata  :update_bulk_metadata


  # https://elvis.tenderapp.com/kb/api/rest-zip_download
  def zip_download(options={})
    url = base_url + "zip_download"
    response = get_response(url, options)
  end # zip_download

  alias :download_zip :zip_download

end # class Elvis

end # module WoodWing


WW      = WoodWing        unless defined?(WW)
WwElvis = WoodWing::Elvis unless defined?(WwElvis)
