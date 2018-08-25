def mikuzi(name = "あなた", age = 20, guess = "吉")
  mikuzi = ["大吉", "中吉", "小吉", "吉", "凶"]


  3.times do
    sleep(2)
    result = mikuzi[rand(0..mikuzi.length-1)]
    puts "予想は「#{guess}」ですね、、、"
    sleep(1)
    puts "#{name}(年齢：#{age})の引いたおみくじは"
    sleep(3)
    puts "「#{result}」です！"
    sleep(1)

    if result == "大吉" || result == "中吉"
      puts "おめでとうございます！！"
    elsif result == "小吉" || result == "吉"
      puts "まぁまぁですね！"
    else
      puts "ドンマイです。"
    end

    case result
      when "大吉", "中吉"
        puts "Great！！"
      when "小吉", "吉"
        puts "OK!"
      else
        puts "Bad..."
    end
  end
end
puts "あなたの名前を入力して下さい"
print "名前："
name = gets.chomp
puts "あなたの年齢を入力して下さい"
print "年齢："
age = gets.chomp
puts "おみくじの予想を入力して下さい"
print "予想："
guess = gets.chomp
mikuzi(name, age, guess)


def check_three(num)
  if num % 3 == 0
    puts "#{num} (3の倍数) "
    sleep(1)
  else
    puts num
  end
end

#i = 0
#while i < 30 do
#for i in 1..30 do
#(1..30).each do |i|
30.times do |i|
  i +=1
  check_three(i)
end
