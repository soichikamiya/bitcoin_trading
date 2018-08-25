puts ("グー = 0    チョキ = 1   パー = 2")
puts ("手の数字を選んで下さい。 【0 or 1 or 2】")
choice = gets()
you = Integer(choice)
computer = rand(3)
puts ("コンピューター : #{computer}")

diff = you - computer
if diff == 0
    puts ("あいこです、もう一回！")

elsif diff == -1 || diff == 2
    puts ("あなたの勝ちです、おめでとう！！")

else
    puts ("残念、あなたの負けです")
end
