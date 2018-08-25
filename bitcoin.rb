require './method'

buy_price = "670000"
sell_price = "690000"
orders_list

#通常売買取引メソッド
while(1)
  puts "現在価格: #{current_price}"
  puts "JPY: #{my_wallet(currency: "JPY")["amount"]}"
  puts "BTC: #{my_wallet(currency: "BTC")["amount"]}"

  if current_price > sell_price.to_i && my_wallet(currency: "BTC")["amount"] < 0.001
    puts "【 売却 】"
    order(side: "SELL", price: sell_price, size: "0.01")
  elsif current_price < buy_price.to_i && my_wallet(currency: "JPY")["amount"] < 1000
    puts "【 購入 】"
    order(side: "BUY", price: buy_price, size: "0.01")
  else
    puts "stay..."
  end
  puts "-----------------------"
  sleep(0.5)
end

#特殊注文ifdOCO取引メソッド
while(1)
  puts "現在価格: #{current_price}"
  puts "JPY: #{my_wallet(currency: "JPY")["amount"]}"
  puts "BTC: #{my_wallet(currency: "BTC")["amount"]}"

  if current_price < buy_price.to_i && my_wallet(currency: "JPY")["amount"] < 1000
    puts "【 ifdOCO開始 】"
    ifdoco(buy: buy_price, buy_size: "0.01", sell1: sell_price, sell_size1: "0.01", sell2: "660000", sell_size2: "0.01")
  else
    puts "stay..."
  end
  puts "-----------------------"
  sleep(0.5)
end
