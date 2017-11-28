class Game

  attr_accessor :board, :success, :turns, :computer, :active_player
  def initialize
    @active_player = true
    @success = false
    @turns = 1
  end

  def start_game
    intro
    select_game_type
    @board = Board.new(@active_player)
    @computer = AiPlayer.new
    instructions
    play
  end

  def play
    play_round
    @success ? success_message : failure_message
  end

  def success_message
    puts @active_player ?  "\nCongrats, you have cracked the code" : "\nThe Computer has cracked your code.\nComputer is OP. Don't mess with computer"
    play_again
  end
  def failure_message
    puts @active_player ?  "\nYou failed to crack the code. I gave you 12 tries dude, wth?" : "I aint even trying to write a failure message for the computer coz its definitely gonna win"
    play_again
  end

  def play_again
    puts "\n Would you like to play again? type 'yes' or 'no'"
    user_input = gets.chomp.downcase
    if user_input == 'yes'
      print "let's play!"
      start_game
    elsif user_input == 'no'
        print "That's cool. Hope you had fun"
        exit
    else
      print "I didnt quite catch that."
      play_again
    end
  end

  def play_round
    loop do
      ask_for_guess
      @active_player ? guess = get_player_guess : guess = get_computer_guess
      @board.update_gameboard(guess)
      @board.display_board
      @success = true if @board.code_cracked?(guess)
      @turns += 1 if @success == false

      break if @success == true || @turns >= 13
    end
  end

  def ask_for_guess
    puts @active_player ? "\nPlease guess the code: " : "\nComputer is guessing... "
  end

  def get_player_guess
    guess = gets.chomp.split("").map(&:to_i)
    if (guess.length == 4) && (guess.all?{|e| (1..6).include?(e)}) && (guess.all?{|e| e.class == Fixnum})
      return guess
    else
      puts "\nInvalid guess. The code is 4 digits long with each digit between 1-6"
      puts "Enter the code in the correct format i.e XXXX."
      get_player_guess
    end
  end

  def get_computer_guess
    @computer.guess
  end

  def select_game_type
    puts "\nIf you want to guess the code, press 1"
    puts "Or if you want to make the code for the computer to guess, press 2"
    game_type = gets.chomp.to_i
    until game_type == 1 || game_type == 2
      puts "I didn't get that, please press 1 or 2"
      game_type = gets.chomp.to_i
    end
    @active_player = false if game_type == 2
    @active_player = true if game_type == 1
  end

  def intro
    puts"

             /$$      /$$                       /$$                         /$$      /$$ /$$                 /$$
            | $$$    /$$$                      | $$                        | $$$    /$$$|__/                | $$
            | $$$$  /$$$$  /$$$$$$   /$$$$$$$ /$$$$$$    /$$$$$$   /$$$$$$ | $$$$  /$$$$ /$$ /$$$$$$$   /$$$$$$$
            | $$ $$/$$ $$ |____  $$ /$$_____/|_  $$_/   /$$__  $$ /$$__  $$| $$ $$/$$ $$| $$| $$__  $$ /$$__  $$
            | $$  $$$| $$  /$$$$$$$|  $$$$$$   | $$    | $$$$$$$$| $$  \__/| $$  $$$| $$| $$| $$  \ $$| $$  | $$
            | $$\  $ | $$ /$$__  $$ \____  $$  | $$ /$$| $$_____/| $$      | $$\  $ | $$| $$| $$  | $$| $$  | $$
            | $$ \/  | $$|  $$$$$$$ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$      | $$ \/  | $$| $$| $$  | $$|  $$$$$$$
            |__/     |__/ \_______/|_______/    \___/   \_______/|__/      |__/     |__/|__/|__/  |__/ \_______/
                                                                                                                "
    puts "\n\nWelcome to Mastermind.\n\n"
    puts "You can either create a secret code for the computer to guess,"
    puts "or guess the computer's secret code. You have 12 turns to guess.\n\n"
    puts "The code is 4 digits long, and can contain duplicates."

  end

  def instructions
    puts "Here is the board:\n\n"
    puts
    @board.display_board
    puts "The left column displays the guess, and the right column displays feedback to the guess."
    puts "The feedback works as follows:\n"
    puts "#{"■".colorize(:green)} means one of the guessed digits is in the correct position"
    puts "#{"■".colorize(:yellow)} means one of the chosen digits exists in the secret code but in the incorrect position."
    puts "#{"■".colorize(:red)} means one of the digits does not exist in the secret code.\n\n"
    puts "---WARNING---"
    puts "The feedback does not indicate which of the chosen digits is in the correct position"
    puts "or which of the digits exists in an incorrect position"
    puts "i.e. #{"■".colorize(:green)} does not tell you which digit of the guess is in the correct position.\n\n"
    puts "Now that we got that sorted, let's play!"
  end
end
