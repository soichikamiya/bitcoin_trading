require 'net/http'
require 'uri'
require 'json'
require "openssl"
require './key'

#板情報取得
def current_price
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = '/v1/getboard'

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.get uri.request_uri
  #puts response.body
  #response_hash = JSON.pretty_generate(response.body) #JSON形式に変換
  response_hash = JSON.parse(response.body)
  response_hash["mid_price"]
end

#資産残高情報取得
def my_wallet(currency:)
  key = API_KEY
  secret = API_SECRET

  timestamp = Time.now.to_i.to_s
  method = "GET"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/getbalance"


  text = timestamp + method + uri.request_uri
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

  options = Net::HTTP::Get.new(uri.request_uri, initheader = {
    "ACCESS-KEY" => key,
    "ACCESS-TIMESTAMP" => timestamp,
    "ACCESS-SIGN" => sign,
  });

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  response = JSON.parse(response.body).find {|n| n["currency_code"] == "#{currency}"}
  response
end

#通常売買取引
def order(side:, price:, size:)
  key = API_KEY
  secret = API_SECRET

  timestamp = Time.now.to_i.to_s
  method = "POST"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/sendchildorder"
  body = '{
    "product_code": "BTC_JPY",
    "child_order_type": "LIMIT",
    "side": "' + side + '",
    "price": ' + price + ',
    "size": ' + size + ',
    "minute_to_expire": 20000,
    "time_in_force": "GTC"
  }'

  text = timestamp + method + uri.request_uri + body
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

  options = Net::HTTP::Post.new(uri.request_uri, initheader = {
    "ACCESS-KEY" => key,
    "ACCESS-TIMESTAMP" => timestamp,
    "ACCESS-SIGN" => sign,
    "Content-Type" => "application/json"
  });
  options.body = body

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  puts response.body
end

#特殊注文取引
def ifdoco(buy:, buy_size:, sell1:, sell_size1:, sell2:, sell_size2:)
  key = API_KEY
  secret = API_SECRET

  timestamp = Time.now.to_i.to_s
  method = "POST"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/sendparentorder"
  body = '
    {
    "order_method": "IFDOCO",
    "minute_to_expire": 10000,
    "time_in_force": "GTC",
    "parameters": [
      {
      "product_code": "BTC_JPY",
      "condition_type": "LIMIT",
      "side": "BUY",
      "price": ' + buy + ',
      "size": ' + buy_size + '
      },
      {
      "product_code": "BTC_JPY",
      "condition_type": "LIMIT",
      "side": "SELL",
      "price": ' + sell1 + ',
      "size": ' + sell_size1 + '
      },
      {
      "product_code": "BTC_JPY",
      "condition_type": "STOP_LIMIT",
      "side": "SELL",
      "price": ' + sell2 + ',
      "size": ' + sell_size2 + '
      }]
    }'

  text = timestamp + method + uri.request_uri + body
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

  options = Net::HTTP::Post.new(uri.request_uri, initheader = {
    "ACCESS-KEY" => key,
    "ACCESS-TIMESTAMP" => timestamp,
    "ACCESS-SIGN" => sign,
    "Content-Type" => "application/json"
  });
  options.body = body

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  puts response.body
end

#注文一覧取得
def orders_list
  key = API_KEY
  secret = API_SECRET

  timestamp = Time.now.to_i.to_s
  method = "GET"
  uri = URI.parse("https://api.bitflyer.jp")
  uri.path = "/v1/me/getchildorders"


  text = timestamp + method + uri.request_uri
  sign = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), secret, text)

  options = Net::HTTP::Get.new(uri.request_uri, initheader = {
    "ACCESS-KEY" => key,
    "ACCESS-TIMESTAMP" => timestamp,
    "ACCESS-SIGN" => sign,
  });

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true
  response = https.request(options)
  puts response.body
end
