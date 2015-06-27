require 'yaml'
require 'nokogiri'

desc "Update feeds/podcast.rss"
task :update_rss do
  conf = YAML.load_file("_config.yml")

  response = http_get(conf["rss_url"])

  File.open(conf["rss_path"], "w") do |f|
    f.write(response.body)
  end
end


# Methods

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
