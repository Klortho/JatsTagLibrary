#/usr/bin/env ruby
# This script converts all of the JATS Tag Library documents into the form
# required by the new library browser framework.
# It depends on saxon9he.jar being in the same directory as this script.

require 'nokogiri'

script_dir = File.dirname(__FILE__)
entries_dir = "jqapi-docs/entries"

doc = Nokogiri::XML(File.open("toc-xref.xml"))
doc.xpath('//item').each { |item|
  hash = item.attribute("hash").to_str
  title = item.attribute("title").to_str
  slug = item.attribute("slug").to_str

  if hash != ""
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
  end
}