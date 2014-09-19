#!/usr/bin/env ruby
# encoding: utf-8
##########################################################
###
##  File: elvis_search.rb
##  Desc: Search Elvis for stuff
##        can produce an XML file for use with Carrot2 clustering
##  By:   Dewayne VanHoozer (dvanhoozer@gmail.com)
#

require 'debug_me'
include DebugMe

require 'pathname'
require_relative '../lib/woodwing'


me        = Pathname.new(__FILE__).realpath
my_dir    = me.parent
my_name   = me.basename.to_s

$options = {
  verbose:          false,
  debug:            false,
  show_text:        false,
  show_dates:       false,
  cluster_results:  false,
  cluster_filename: nil,
  cluster_file:     nil,
  elvis_api_url:  ENV['ELVIS_API_URL']  || 'http://localhost:8080/services/',
  elvis_user:     ENV['ELVIS_USER']     || 'guest',
  elvis_pass:     ENV['ELVIS_PASS']     || 'guest',
  meta_fields:    '',
  query:          ''  # syntax identical to Elvis UI search box
}

def verbose?
  $options[:verbose]
end

def debug?
  $options[:debug]
end

def show_text?
  $options[:show_text]
end

def show_dates?
  $options[:show_dates]
end

def cluster_results?
  $options[:cluster_results]
end

$KNOWN_MFIELDS = %w[  assetCreator
  assetDomain
  assetFileModifier
  assetModifier
  assetPath
  assetPropertyETag
  assetType
  basicDataETag
  cf_PrayerFocus
  cf_Theme
  cf_TFTD
  cf_LongReading
  cf_Citation
  contentETag
  extension
  filename
  fileSize
  fileType
  folderPath
  indexRevision
  metadataComplete
  mimeType
  name
  previewETag
  previewState
  sceArchived
  sceUsed
  status
  textContent
  versionETag
versionNumber ]

usage = <<EOS

Search Elvis for stuff

Usage: #{my_name} [options] 'query'

Where:

  options               Do This
    -h or --help        Display this message
    -v or --verbose     Display progress
    -d or --debug       Sets $DEBUG
    -m or --meta        Display these metadata fields
      field_names+        one of more metadata field
                          names seperated by commas
          --dates       Shows creation and modification
                          dates and users
          --text        Shows text around the search term(s)
                          for the first "hit" in the document

          --cluster     User document clustering
            out_filename  filename into which the search
                          results are stored

  'query'               The search query constrained by
                        single quotes.

NOTE:

  The single quotes around the search query are required to
  defeat the command line file glob/wildcard facility.

  The '-m or --meta' option can be used many times as needed.
  The following list contains the known (case-SENSITIVE)
  metadata fields:

  #{$KNOWN_MFIELDS.join(', ')}

EOS

# Check command line for Problems with Parameters
$errors   = []
$warnings = []


# Get the next ARGV parameter after param_index
def get_next_parameter(param_index)
  unless Fixnum == param_index.class
    param_index = ARGV.find_index(param_index)
  end
  next_parameter = nil
  if param_index+1 >= ARGV.size
    $errors << "#{ARGV[param_index]} specified without parameter"
  else
    next_parameter = ARGV[param_index+1]
    ARGV[param_index+1] = nil
  end
  ARGV[param_index] = nil
  return next_parameter
end # def get_next_parameter(param_index)


# Get $options[:out_filename]
def get_out_filename(param_index)
  filename_str = get_next_parameter(param_index)
  $options[:out_filename] = Pathname.new( filename_str ) unless filename_str.nil?
end # def get_out_filename(param_index)


# Display global warnings and errors arrays and exit if necessary
def abort_if_errors
  unless $warnings.empty?
    STDERR.puts
    STDERR.puts "The following warnings were generated:"
    STDERR.puts
    $warnings.each do |w|
      STDERR.puts "\tWarning: #{w}"
    end
    STDERR.print "\nAbort program? (y/N) "
    answer = (gets).chomp.strip.downcase
    $errors << "Aborted by user" if answer.size>0 && 'y' == answer[0]
  end
  unless $errors.empty?
    STDERR.puts
    STDERR.puts "Correct the following errors and try again:"
    STDERR.puts
    $errors.each do |e|
      STDERR.puts "\t#{e}"
    end
    STDERR.puts
    exit(-1)
  end
end # def abort_if_errors


# Display the usage info
if  ARGV.empty?               ||
  ARGV.include?('-h')       ||
  ARGV.include?('--help')
  puts usage
  exit
end

%w[ -v --verbose ].each do |param|
  if ARGV.include? param
    $options[:verbose]        = true
    ARGV[ ARGV.index(param) ] = nil
  end
end

%w[ -d --debug ].each do |param|
  if ARGV.include? param
    $options[:debug]          = true
    $DEBUG                    = true
    ARGV[ ARGV.index(param) ] = nil
  end
end

%w[ -m --meta ].each do |param|
  while ARGV.include?(param) do
    $options[:meta_fields] += ',' unless $options[:meta_fields].empty?
    $options[:meta_fields] += get_next_parameter(ARGV.index(param))
  end
end

%w[ --dates ].each do |param|
  if ARGV.include? param
    $options[:show_dates]     = true
    $options[:meta_fields]   += ',' unless $options[:meta_fields].empty?
    $options[:meta_fields]   += "assetCreated,assetCreator,assetModified,assetModifier,versionNumber"
    ARGV[ ARGV.index(param) ] = nil
  end
end

%w[ --text ].each do |param|
  if ARGV.include? param
    $options[:show_text]      = true
    ARGV[ ARGV.index(param) ] = nil
  end
end

%w[ --cluster ].each do |param|
  if ARGV.include? param
    $options[:cluster_results]    = true
    next_param = get_next_parameter(param)
    unless next_param.nil?
      $options[:cluster_filename]   = Pathname.new(next_param)
      $warnings << "File already exists: #{$options[:cluster_filename].realpath}" if $options[:cluster_filename].exist?
    end
  end
end


ARGV.compact!

debug_me(){ :ARGV }


if ARGV.empty?
  $errors << "No search query was specified."
end

$options[:query] = ARGV.shift

unless ARGV.empty?
  $errors << "The search query is malformed - may not be enclosed in quotes."
end

abort_if_errors

max_mfield_size = 0

unless $options[:meta_fields].empty?
  $options[:meta_fields] = $options[:meta_fields].split(',')
  $options[:meta_fields].each do |mf|
    max_mfield_size = mf.size if mf.size > max_mfield_size
  end
  max_mfield_size += 2
end


if cluster_results?
  $options[:cluster_file] = File.new($options[:cluster_filename],'w')
end


######################################################
# Local methods




######################################################
# Main

at_exit do
  begin
    $elvis.logout
  rescue
    # eat it
  end
  puts
  puts "Done."
  puts
end

$elvis = WoodWing::Elvis.new
$elvis.login

if debug?
  puts
  pp $options
  puts
  pp $elvis
  puts
end

options = {
  q:                    $options[:query],
  appendRequestSecret: 'true'
}

options[:metadataToReturn] = $options[:meta_fields].join(',') unless $options[:meta_fields].empty?


response = $elvis.search options

if debug?
  puts "======= Full Response ======="
  pp response
end

puts

unless response.include?(:totalHits)
  puts "ERROR: response does not include :totalHits"
  exit
end

puts
puts "Total Hits:   #{response[:totalHits]}"
puts "First Result: #{response[:firstResult]}"
puts "Max. Results: #{response[:maxResultHits]}"
puts

if cluster_results?
  $options[:cluster_file].puts <<ENDXML
<?xml version="1.0" encoding="UTF-8"?>
<searchresult>
  <query>#{$options[:query]}</query>
ENDXML

end

if response[:totalHits] > 0
  result_number = 0
  response[:hits].each do |hit|

    $options[:cluster_file].puts '<document>' if cluster_results?

    metadata = hit[:metadata]
    puts
    puts "="*45
    puts "== Result # #{result_number+=1}   ID: #{hit[:id]}"
    puts
    puts "originalUrl:  #{hit[:originalUrl]}"
    puts "Asset Path:   #{metadata[:assetPath]}"
    puts "Status:       #{metadata[:status]}"

    unless $options[:meta_fields].empty?
      puts
      $options[:meta_fields].each do |mf|
        mf_label = "#{mf}:" + ' '*(max_mfield_size-mf.size)
        puts "#{mf_label} #{metadata[mf.to_sym]}"
      end
    end

    if show_dates?
      puts
      puts "Created on:   #{metadata[:assetCreated][:formatted]}  by: #{metadata[:assetCreator]}"
      puts "Modified on:  #{metadata[:assetModified][:formatted]}  by: #{metadata[:assetModifier]}  Version Number # #{metadata[:versionNumber]}"
    end

    if show_text?
      puts
      puts "highlightedText:  #{hit[:highlightedText]}"
    end

    puts

    if cluster_results?
      $options[:cluster_file].puts <<ENDXML
  <title>#{metadata[:assetPath]}</title>
  <snippet>#{hit[:highlightedText].gsub('<B>','').gsub('</B>','').gsub('<','').gsub('>','')}</snippet>
  <url>http://localhost#{metadata[:assetPath]}</url>
</document>
ENDXML

    end # if cluster_results?

  end # response[:hits].each do |hit|
end # if response[:totalHits] > 0


if cluster_results?
  $options[:cluster_file].puts "</searchresult>"
  $options[:cluster_file].close
  # TODO: invokl carrot2 CLI
  # TODO: retrieve carrot2 generated XML file
  # TODO: display document clusters
end

__END__

# To interface with Carrot2 document clustering workbench this kind of xml
# file needs to be generated with 1 document entry for each 'hit' of
# the query.

<?xml version="1.0" encoding="UTF-8"?>
<searchresult>
  <query>seattle</query>
  <document>
    <title>City of Seattle</title>
    <snippet>Official site featuring a guide to living in Seattle and information on doing business, city services, and visitor's resources.</snippet>
    <url>http://www.seattle.gov/</url>
  </document>
</searchresult>

