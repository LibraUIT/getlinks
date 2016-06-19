require 'net/http'
require 'nokogiri'
require 'open-uri'
require 'fileutils'
class GetLinkService
  def call(server, param)
    uri = URI.parse("http://linkaz.net/index.php?action=javpostlink")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data({"link" => link_param[:link]})
    response = http.request(request)
    doc = Nokogiri::HTML(response.body)
    h = {}
    doc.xpath('//a[@href]').each do |link|
      h[link.text.strip] = link['href']
    end
    @links = h
    true
  end
end
