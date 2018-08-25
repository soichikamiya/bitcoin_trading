class IndexController < ApplicationController

  require 'net/http'
  require 'uri'
  require 'json'
  require "openssl"

　#Insert your API_KEY & API_SECRET
  API_KEY = ""
  API_SECRET = ""

  def home
    #現在価格取得
    uri = URI.parse("https://api.bitflyer.jp")
    uri.path = '/v1/getboard'

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    response = https.get uri.request_uri
    #puts response.body
    #response_hash = JSON.pretty_generate(response.body) #JSON形式に変換
    @response_hash = JSON.parse(response.body)["mid_price"]


    #残高情報取得
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
    @response1 = JSON.parse(response.body).find {|n| n["currency_code"] == "JPY"}["amount"]
    @response2 = JSON.parse(response.body).find {|n| n["currency_code"] == "BTC"}["amount"]
  end

  #売買取引メソッド
  def set
    key = API_KEY
    secret = API_SECRET

    timestamp = Time.now.to_i.to_s
    method = "POST"
    uri = URI.parse("https://api.bitflyer.jp")
    uri.path = "/v1/me/sendchildorder"
    body = '{
      "product_code": "BTC_JPY",
      "child_order_type": "LIMIT",
      "side": "' + params[:side] + '",
      "price": ' + params[:price].to_s + ',
      "size": ' + params[:size].to_s + ',
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
    redirect_to("/index/home")
  end
end
