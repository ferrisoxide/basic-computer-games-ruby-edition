#! /usr/bin/env ruby
puts "Acey Ducey Card Game"
puts "Adapted from a BASIC game from Creative Computing - Morristown, New Jersey."
puts "\n\n\n"
puts "Acey Ducey is played in the following manner:"
puts "The dealer (computer) deals two cards face up"
puts "You have an option to bet or not to bet depending"
puts "on whether or not you feel the card will have"
puts "a value between the first two."
puts "If you do not want to bet, input a 0."

def play_game

  def card_to_s(index)
    if index < 11
      return index.to_s 
    elsif index == 11
      return "Jack"
    elsif index == 12
      return "Queen"
    elsif index == 13
      return "King"
    elsif index == 14
      return "Ace"      
    end  
  end
  
  money = 100
  
  while money > 0 do
    
    puts "You have #{money} dollars."

    puts "Here are your next two cards:"

    card_a = rand(12) + 2
    card_b = rand(14 - card_a) + card_a + 1

    puts card_to_s(card_a)
    puts card_to_s(card_b)

    valid_bet = false

    while valid_bet == false do
      puts "What is your bet?"
      bet = gets.chomp.to_i
      if bet == 0 
        puts "Chicken!!"
        valid_bet = true
      elsif bet > money
        puts "Sorry, my friend but you have bet to much."
        puts "You have only #{money} dollars to bet."
      elsif
        valid_bet = true
      end
    end

    if bet > 0
      card_c = rand(13) + 2
      puts "The card was #{card_to_s(card_c)}."
      if (card_c > card_a) && (card_c < card_b)
        puts "You win!!!"
        money += bet
      else
        puts "You lose."
        money -= bet
      end
    end
  end
  puts "Sorry, friend but you blew your wad."
end

playing = true

while playing == true 
  play_game
  puts "Try again? (yes or no)"
  again = gets.chomp
  playing = false unless again == "yes"
end  

puts "OK, hope you had fun."
