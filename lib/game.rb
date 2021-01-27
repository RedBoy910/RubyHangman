require_relative 'save_service.rb'
require 'colorize'

# handles the hangman game
class Game

  #attr_accessor @tries, @word, @save_service 

  include SaveService

  def initialize
    # @key: string = the answer
    # @tries: number of tries left for the player
    # @word: array = the word formed from the player's guesses
    # @guesses: array = the letters the player already used
    @key = SaveService.generate_word
    @tries = 10
    @word = Array.new(@key.size, '_'.green)
    @guesses = []
  end

  # the main function of this class, runs the game
  def play
    while @tries.positive?
      print_guesses_remaining
      print_used_letters
      print_word

      input = scan_letter

      result = process_letter(input)

      if %w[save exit].include? result
        process_forced_exit(result)
        return
      end

      next unless win?

      print_word
      puts 'You won!'.green
      return
    end

    puts "You lost! The word was #{@key}".red
  end

  private

  def process_forced_exit(input)
    if input == 'exit'
      puts 'Thanks for playing!'.green
      nil
    elsif input == 'save'
      puts 'Choose a name for your save:'
      name = gets.chomp

      while name.split('').include? '/' || name == '.' || name == '..'
        puts 'Invalid filename, choose another!'
        name = gets.chomp
      end

      puts 'Thanks for playing! You can always resume this session by choosing from the saved games!'.green
      puts @key.class
      SaveService.make_save(name, self)
    end
  end

  def print_word
    @word.each do |it|
      print it.green
    end
    puts ''
  end

  def print_guesses_remaining
    puts "Number of wrong guesses remaining: #{@tries}".yellow
  end

  def print_used_letters
    if @guesses.empty?
      puts "You haven't tried any letters yet."
      return
    end

    print 'The letters you already tried are: '
    @guesses.each do |it|
      if @key.include? it
        print "#{it.green} "
      else
        print "#{it.red} "
      end
    end
    print "\n"
  end

  # gets the next letter from the player
  def scan_letter
    puts 'Enter the next letter. Otherwise, type "save" to save your game and quit, or type "exit" to quit without saving'
    input = gets.chomp.to_s.downcase.strip

    until ((input.match(/[a-z]/) && input.size == 1) || %w[save exit].include?(input)) && !@guesses.include?(input)
      puts 'Invalid choice, try again'
      input = gets.chomp.to_s.downcase.strip
    end

    input
  end

  # handles the input
  def process_letter(letter)
    return letter if %w[save exit].include? letter

    if @key.include? letter
      key_array = @key.split('')

      key_array.each.with_index do |char, index|
        @word[index] = letter if letter == char
      end
    else
      @tries -= 1
    end

    @guesses << letter

    ''
  end

  def win?
    @key == @word.join
  end
end
