class Mastermind
  def initialize
    @board = Board.new
  end

  def start_game
    @player = Player.new(get_player_name)
    @computer = Computer.new
    game_mode = get_game_mode
    if game_mode == "1"
      player_game_loop
    elsif game_mode == "2"
        computer_game_loop
    end
  end

  def get_player_name
    puts "What is your name?"
    player_name = gets.chomp
    return player_name
  end

  def get_game_mode
      puts "Press 1 if you want to guess the secret code, or 2 if you want to provide the secret code"
      game_mode = gets.chomp
      if game_mode == "1" || game_mode == "2"
        return game_mode
      else
        puts "please just press 1 or 2, it's not hard bro"
        get_game_mode
      end
  end

  def computer_game_loop
    player_secret_code = @player.get_secret_code
    @board.sets_code(player_secret_code)
    @computer.get_computer_guess(player_secret_code)

  end

  def player_game_loop
    @board.sets_code(@computer.computer_secret_code)

    loop do
      @board.display_secret_code
      @board.display_all_turns
      #get guess
      player_guess = @player.get_guess
      #check guess
      if @board.check_guess(player_guess)
        #feedback
        @board.feedback(player_guess)
      end
      #check if success/failure
      if @board.cracked? == true
        success_message
        exit
      end

      if @board.no_turns_left? == true
        failure_message
        exit
      end
    end
  end


  def success_message
    puts "Congrats #{@player.name}, you win!"
    @board.display_secret_code
    exit
  end

  def failure_message
    puts "#{@player.name}, you suck!"
    puts
    puts "The code was: #{@board.display_secret_code}"
    exit
  end
end
#-------
class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def get_guess
    puts "#{@name}, What do you think the code is? the colours are: white,
    black, red, blue, yellow and green. Please enter your guess
    in the following format: white,black,red,blue
    using a comma to seperate the colours"
    player_guess = gets.downcase.strip.split(",")
    return player_guess
  end

  def get_secret_code
    puts "#{@name}, please enter your secret code. The colours are: white,
    black, red, blue, yellow and green. Please enter your secret code
    in the following format: white,black,red,blue
    using a comma to seperate the colours"
    player_secret_code = gets.downcase.strip.split(",")
  end
end
#-------
class Board

  attr_accessor :secret_code, :turns
  @@broken_code = false
  @@colours = ["white","black","red","blue","yellow","green"]
  @@code_attempt_number = 0

  def initialize
    @secret_code = []
    @turns = []
  end

  def cracked?
    return true if @@broken_code == true
  end

  def sets_code(potential_secret_code)
    valid_code?(potential_secret_code) ? @secret_code = potential_secret_code : false
  end

  def feedback(guess)
    correct_position = 0
    misplaced_colour = 0
    checked = []

    guess.each_with_index do |gcolour, gindex|
      if gcolour == @secret_code[gindex]
        correct_position += 1
        if checked[gindex] == gcolour
          misplaced_colour -= 1
        else
          checked[gindex] = gcolour
        end
      else
        @secret_code.each_with_index do |ccolour, cindex|
          if gcolour == ccolour && gcolour != @secret_code[gindex] && checked[cindex] != ccolour
            misplaced_colour += 1
            checked[cindex] = ccolour
          end
        end
      end
    end
    puts "#{correct_position} of your guessed colours are in the correct position"
    puts
    puts "#{misplaced_colour} of your chosen colours exist in an incorrect position"
    puts
  end

  def valid_code_type?(code)
    if code.is_a?(Array)
      true
    else
      puts "Please enter code in the correct format: w,x,y,z
      using a comma to seperate the colours"
    end
  end

  def valid_code_length?(code)
    if code.length == 4
      true
    else
      puts "Your code should contain exactly four colours
      written in the format: w,x,y,z"
    end
  end

  def valid_code_colours?(code)
    if code.all? {|colour| @@colours.include?(colour)}
      return true
    else
      puts "You can only select the colours that are available.
      These are: white, black, red, blue, yellow and green"
      puts
    end
  end

  def valid_code?(code)
    if valid_code_colours?(code) && valid_code_length?(code) && valid_code_type?(code)
      return true
    end
  end

  def no_turns_left?
    if @turns.length >= 12
      puts "you've ran out of turns"
      true
    else
      false
    end
  end

  def check_guess(guess)
    if valid_code?(guess)
      if guess == @secret_code
        @@broken_code = true
      end
      @@code_attempt_number += 1
      @turns << {@@code_attempt_number => guess}
    end
  end

  def display_all_turns
    @turns.each do |turns_hash|
      counter = 0
      puts "Code attempt " + turns_hash.keys[counter].to_s + ' : ' + turns_hash.values[counter].to_s
      puts
      counter += 1
    end
  end

  def display_secret_code
    print @secret_code
  end
end

#-------
class Computer < Player

  @@colours = ["white","black","red","blue","yellow","green"]
  def initialize (name = "computer")
    super
  end

  def computer_secret_code
    secret_code = []
    4.times do
      secret_code.push(@@colours.sample)
    end
    return secret_code
  end

  def get_computer_guess(player_secret_code)
    turns = []
    computer_guess = [nil,nil,nil,nil]
    correct_guess = [nil,nil,nil,nil]
    wrong_position = nil
    until player_secret_code == computer_guess || turns.length >= 12
      computer_guess.each_with_index do |comcolour, comindex|
        if comcolour == player_secret_code[comindex]
          computer_guess[comindex] = comcolour
          correct_guess[comindex] = comcolour
        else
          if wrong_position == nil
            computer_guess[comindex] = @@colours.sample
          else
            computer_guess[comindex] = wrong_position
            wrong_position = nil
          end
        end
        if code_has_colour(player_secret_code, comcolour)
          player_secret_code.each_with_index do |codecolour, codeindex|
            if codecolour == comcolour
              if correct_guess[codeindex] == nil
                wrong_position = comcolour
              end
            end
          end
        end
      end
      turns << computer_guess
      puts "Computer guesses: #{computer_guess}"
    end
    if player_secret_code == computer_guess
      puts "It took the computer #{turns.length} attempts to guess your code.

      Computer is OP. Dont mess with computer"
      sleep(8)
      exit
    else
      puts "Impressive. The computer could not guess your code."
      sleep(8)
      exit
    end
  end

  def code_has_colour(code, colour)
    code.any? do |e|
      e == colour
    end
  end

end

game1 = Mastermind.new
game1.start_game
