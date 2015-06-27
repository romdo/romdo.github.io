require 'yaml'
require 'nokogiri'

desc "Update feeds/podcast.rss"
task :update_rss do
  conf = YAML.load_file("_config.yml")

  local_rss_url  = conf["url"] + conf["rss_path"]
  remote_rss_url = conf["remote_rss_url"]

  response = http_get(remote_rss_url)

  doc = Nokogiri::XML(response.body)
  doc.at_css("channel > atom|link[rel='self']")[:href] = local_rss_url
  File.open(conf["local_rss_path"], "w") { |f| f.write(doc.to_s) }
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
