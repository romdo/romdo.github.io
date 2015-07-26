require 'yaml'
require 'uri'
require 'net/http'
require 'time'
require 'fileutils'

require 'nokogiri'
require 'rinku'
require 'filesize'

desc "run \"jekyll serve\""
task :serve do
  exec("jekyll serve")
end

desc "Update episodes based on RSS feed"
task :update do
  conf = YAML.load_file("_config.yml")
  puts ""
  puts "Fetching RSS feed to build posts from..."
  response = http_get(conf["rss_url"])

  doc = Nokogiri::XML(response.body)

  remove_all_posts
  puts ""
  puts "Building posts from RSS:"
  doc.css("channel > item").each do |item|
    create_post(item)
  end
  puts ""
end


# Methods

def remove_all_posts
  puts ""
  puts "Removing existing posts:"
  Dir["_posts/*.html"].each do |file|
    puts "   #{file.gsub(File.dirname(__FILE__), '')}"
    File.delete(file)
  end
end

def create_post(item)
  link        = item.at_css("link").text
  slug        = File.basename(link)
  pub_date    = item.at_css("pubDate").text
  date        = Time.parse(pub_date)
  description = item.at_css("description").text
  enclosure   = item.at_css("enclosure")

  file = "_posts/#{date.strftime("%Y-%m-%d")}-#{slug}.html"
  content = <<-HD
---
layout: post
title: "#{item.at_css("title").text}"
date: "#{Time.parse(pub_date).strftime("%Y-%m-%d %H:%M:%S %z")}"
guid: "#{File.basename(item.at_css("guid").text)}"
slug: "#{slug}"
link: "#{link}"
duration: "#{item.at_css("itunes|duration").text}"
media_url: "#{enclosure[:url]}"
media_size: "#{Filesize.new(enclosure[:length], Filesize::SI).pretty}"
media_size_bytes: "#{enclosure[:length]}"
image_url: "#{item.at_css("itunes|image")[:href]}"
---
#{auto_link(description.gsub("\n", "<br />\n"))}
HD

  puts "   #{file}"
  FileUtils.mkdir_p(File.dirname(file))
  File.open(file, "w") { |f| f.write(content) }
end

def auto_link(str)
  Rinku.auto_link(str) { |url| url.gsub(/^https?\:\/\//i, "") }
end

def http_get(url, params = {}, options = {})
  uri = URI.parse(url)
  uri.query = URI.encode_www_form(params)

  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri.scheme == "https"

  if options[:http_pull_timeout]
    http.read_timeout = options[:http_pull_timeout]
  end

  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  response
end
