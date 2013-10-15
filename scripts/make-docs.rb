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

By default, this:
* Creates the destination directory jatsdoc, if it doesn't already exist
* Copies index.html and toc.html into it
* Transforms all the XHTML files specified by the toc-xref.xml file, from the
  orig-html directory, and puts the results into jatsdoc/entries.
* Copies all of image files from graphics into jatsdoc/resources.

You can also do things piecemeal, by specifying a file to transform, or using
the options to specify particular actions.

[file-to-convert], if given, specifies one XHTML file to transfrom, either by
the hash, slug, or the title (see toc-xref.xml).

Options:
EOB
  opt :index, "Only copy index.html and toc.html"
  opt :resources, "Only copy the image files from graphics -> resources"
end

Trollop::die "Too many arguments" if ARGV.size > 1

file_to_convert = ARGV[0]  # This will be nil if not given

script_dir = File.dirname(__FILE__)
dest_dir = "jatsdoc"
Dir.mkdir(dest_dir) unless File.directory?(dest_dir)



# Transform XHTML files
if file_to_convert || (!opts[:index] && !opts[:resources])
  converted = false

  entries_src_dir = "orig-html"
  entries_dest_dir = "#{dest_dir}/entries"
  Dir.mkdir(entries_dest_dir) unless File.directory?(entries_dest_dir)

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
    puts "No file found that matches '#{file_to_convert}'"
  end
end

# Copy index and toc
if opts[:index] || (!file_to_convert && !opts[:resources])
  FileUtils.cp("index.html", dest_dir)
  FileUtils.cp("toc.html", dest_dir)
end

# Copy the resources
if opts[:resources] || (!file_to_convert && !opts[:index])
  resources_src_dir = "graphics"
  resources_dest_dir = "#{dest_dir}/resources"
  FileUtils.rm_rf resources_dest_dir
  FileUtils.cp_r("#{resources_src_dir}", resources_dest_dir)
end