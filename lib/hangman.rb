require 'yaml'

class Game

  def initialize
    @root = "/home/aaron/TOP/ruby_programming/hangman/"
    @empty_chr = "_"
    @word = get_word
    puts @word
    @word_array = Array.new(@word.length,@empty_chr)
    puts @word.length
    @lives = 5
    @game_over = false
    @guesses = []
    run
  end

  def run
    #runs the game
    until @game_over
      display_ui
      check_endgame
      guess = get_guess if !@game_over
      update(guess)
    end
    display_gameover

  end

  def load_game
    #loads game from a file
    #reassigns word, word_array, lives, empty_chr, and guesses
    pass
  end

  def get_word
    #loads file, chooses a random word between 5 and 12 letters long
    puts "Generating random word..."
    words = File.readlines("5desk.txt").select do |line|
      line.chomp if (5..12).include?(line.chomp.length)
    end
    puts "Word generated!"
    return words[rand(words.length-1)].downcase.chomp
  end

  def get_guess
    #ensures guess is valid
    print "Next guess?"
    valid = false
    until valid
      prelim = gets.chomp.downcase
      prelim = "$" if prelim == ""
      is_letter = (97..122).include?(prelim.ord)
      is_guessed = @guesses.include?(prelim)
      if is_letter && !is_guessed && prelim.length == 1
        valid = true
      elsif prelim == "save"
        puts "saving..."
        save_game
        puts "Game saved!"
        print "Next guess?"
      else
        puts "Please input a letter that you haven't guessed yet!"
      end
    end
    return prelim
  end

  def display_ui
    #clears screen
    puts "\n" * 30
    #Prints stuff
    draw_hidden_word
    draw_guessed
    draw_lives
    puts "enter 'save' to save the game"
  end

  def draw_hidden_word
    #draws the word in the hidden format
    puts @word_array.join("   ")
    puts " "
  end

  def draw_guessed
    #draws a list of letters that have been guessed but were wrong
    print "Incorrect Guesses: "
    print @guesses.select {|g| !@word.include?(g)} if @lives < 5
    print "\n"
  end

  def draw_lives
    #displays the number of lives left
    puts "Lives: #{@lives}"
  end

  def check_endgame
    #evaluates if player ran out of guesses, or correctly guessed the word
    dead = (@lives == 0)
    win = (@word_array.all? {|w| w != @empty_chr})
    @game_over = true if dead || win
  end

  def update(guess)
    #refreshes the independent variables; guesses and word_array
    @lives = 5
    @guesses.push(guess)
    @guesses.each { |g|
      if @word.include?(g)
        @word.split("").each_with_index { |c,i| @word_array[i] = g if c == g }
      else
        @lives -= 1
      end
    }
  end

  def display_gameover
    if @lives < 1
      puts "You Lost"
      puts "The word was #{@word}"
    else
      puts "You won the game!"
    end
  end

  def save_game
    data = YAML.dump ({
      :word => @word,
      :word_array => @word_array,
      :guesses => @guesses,
      :lives => @lives,
    })

    file = File.open("save.yaml","w")
    file.puts data
    file.close
  end

  def self.from_yaml(string)
    data = YAML.load string
    p data
    self.new(data[:name], data[:age], data[:gender])
  end

end

Game.new
