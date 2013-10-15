#!/usr/bin/env ruby
# This script converts all of the JATS Tag Library documents into the form
# required by the new library browser framework.
# It depends on saxon9he.jar being in the same directory as this script.

require 'fileutils'
require 'nokogiri'
require 'trollop'

opts = Trollop::options do
  banner <<-EOB
Convert JATS Tag Library documentation to format required by jatsdoc library.

Usage: #{__FILE__} [options] [file-to-convert]

By default, this transforms all the XHTML files specified by the toc-xref.xml
file, and puts the results into jatsdoc/entries.  It also copies all of image
files from graphics into jatsdoc/resources.

[file-to-convert], if given, specifies the file either by the hash, slug, or
the title (see toc-xref.xml).  If not given, then all the files are converted.

Options:
EOB
  opt :copy_resources, "Only copy resources"
end

Trollop::die "Too many arguments" if ARGV.size > 1
file_to_convert = ARGV[0]  # This will be nil if not given

#p opts
#p opts[:copy_resources]
#exit

script_dir = File.dirname(__FILE__)

dest_dir = "jatsdoc"

entries_src_dir = "orig-html"
entries_dest_dir = "#{dest_dir}/entries"

resources_src_dir = "graphics"
resources_dest_dir = "#{dest_dir}/resources"

Dir.mkdir(dest_dir) unless File.directory?(dest_dir)
Dir.mkdir(entries_dest_dir) unless File.directory?(entries_dest_dir)

if !opts[:copy_resources]
  converted = false
  doc = Nokogiri::XML(File.open("toc-xref.xml"))
  doc.xpath('//item').each { |item|
    hash = item.attribute("hash").to_str
    title = item.attribute("title").to_str
    slug = item.attribute("slug").to_str

    if hash != "" && (!file_to_convert || file_to_convert == hash ||
        file_to_convert == title || file_to_convert == slug)

      in_html = "#{entries_src_dir}/#{hash}.html"
      out_html = "#{entries_dest_dir}/#{slug}.html"
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
end

# Copy the resources, if there was no "file_to_convert" argument given
if !file_to_convert || opts[:copy_resources]
  FileUtils.rm_rf resources_dest_dir
  #Dir.mkdir(resources_dest_dir) unless File.directory?(resources_dest_dir)


  FileUtils.cp_r("#{resources_src_dir}", resources_dest_dir)
end