#/usr/bin/env ruby
# This script converts all of the JATS Tag Library documents into the form
# required by the new library browser framework.
# It depends on saxon9he.jar being in the same directory as this script.

require 'nokogiri'


usage = <<-END_USAGE
Usage: #{__FILE__} [ file-to-convert ]
<file-to-convert>, if given, specifies the file either by the hash, slug, or
the title.  If not given, then all the files are converted.
END_USAGE

if ARGV.grep(/^-\?|h$/).any?
  print usage
  exit 0
end

if ARGV.size > 1
  puts "Too many arguments"
  print usage
  exit 1
end


file_to_convert = ARGV[0]  # This will be nil if not given


script_dir = File.dirname(__FILE__)
entries_dir = "jqapi-docs/entries"
Dir.mkdir(entries_dir) unless File.directory?(entries_dir)

converted = false
doc = Nokogiri::XML(File.open("toc-xref.xml"))
doc.xpath('//item').each { |item|
  hash = item.attribute("hash").to_str
  title = item.attribute("title").to_str
  slug = item.attribute("slug").to_str

  if hash != "" && (!file_to_convert || file_to_convert == hash ||
      file_to_convert == title || file_to_convert == slug)

    in_html = "#{hash}.html"
    out_html = "#{entries_dir}/#{slug}.html"
    puts "Transforming #{in_html} -> #{out_html}"
    transform_cmd =
      "java -jar #{script_dir}/saxon9he.jar " +
      "-xsl:#{script_dir}/make-doc.xsl " +
      "-s:#{in_html} " +
      "> #{out_html}"

    %x( #{transform_cmd} )
    if $?.exitstatus != 0
      puts "Failed: '#{transform_cmd}', exit status is #{$?.exitstatus}"
      exit
    end
    converted = true
  end
}

if !converted
  puts "No matching file found"
end