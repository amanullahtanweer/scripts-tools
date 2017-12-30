
#!/usr/bin/env ruby
#
# Arguments:
#    - Currency

require 'uri'
require 'net/http'
require 'openssl'
require 'json'

hook_url = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

def api_function(currency)
	url = URI("https://cex.io/api/convert/#{currency}/USD")

	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Post.new(url)
	request["content-type"] = 'application/json'
	          request["cache-control"] = 'no-cache'
	request.body = {"amnt":  "1"}.to_json

	response = http.request(request)
	response.read_body
end

def slack_hook(msg)
	url = URI(hook_url)

http = Net::HTTP.new(url.host, url.port)
http.use_ssl = false
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new(url)
request["content-type"] = 'application/json'
request.body = "{\"text\": \"#{msg}\"}"

response = http.request(request)
response.read_body

end

eth = api_function("ETH")
xrp = api_function("XRP")

eth_price = "ETH: #{JSON.parse(eth)["amnt"]}\n"
xrp_price = "XRP: #{JSON.parse(xrp)["amnt"]}"

slack_hook("#{eth_price}#{xrp_price}")
