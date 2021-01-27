require_relative 'game.rb'
require_relative 'save_service.rb'

puts 'This is Hangman! Would you like to start a new game or load a saved one? (type new/save)'
input = gets.chomp.downcase

until ['save', 'new'].include? input
  puts 'Invalid choice, try again'
  input = gets.chomp
end

if input == 'save'
  if Dir.empty? 'saves'
    puts 'There are no previous saved games, loading new one...'
    instance = Game.new
  else
    instance = SaveService.load_save
  end
else
  instance = Game.new
end

puts 'Loading...'
sleep(1)

instance.play