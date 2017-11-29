require "colorize"

class Board
  attr_accessor :attempt_number, :gameboard, :secret_code

  def initialize(active_player)
    #create secret code, attempt counter to draw board, and gameboard
    @code_setter = CodeSetter.new(active_player)
    @attempt_number = 0
    @gameboard = create_gameboard
  end

  def create_gameboard
    gameboard = []
    block = " ■".colorize(:red)
    12.times do
      gameboard.push([[0,0,0,0],[block,block,block,block]])
    end
    gameboard
  end
  #display board in user friendly fashion
  def display_board
    i = 0
    print "    _____________________________\n"
    print "   |               |             |\n"

    12.times do
      show_guess = @gameboard[i][0].join(" ")
      show_feedback = @gameboard[i][1].join("")
      print "   |    #{show_guess}    |  #{show_feedback}   |\n"
      i+=1
    end
  print "   |_______________|_____________|\n\n"
  end
  #colour the blocks using the gem
  def colorize(indicator)
    return " ■".colorize(:green) if indicator == "green"
    return " ■".colorize(:yellow) if indicator == "yellow"
    return " ■".colorize(:red) if indicator == (" " || 0)
  end

  def update_gameboard(guess)
    @gameboard[@attempt_number][0] = guess
    @gameboard[@attempt_number][1] = get_feedback(guess,display_secret_code).map { |e| colorize(e) }
    @attempt_number += 1
  end
  #will be used to check for success
  def code_cracked?(guess)
    guess == @code_setter.secret_code ? true : false
  end
  #used to check guesses against code
  def display_secret_code
    @code_setter.secret_code
  end
  #in hindsight, this and the evaluate method in ai.rb do #the same thing.
  #when refactoring, should just have one method and call it mutliple times
  def get_feedback(guess, solution)
    #ensure that false-positive duplicates do not occur.
    #i.e if code is [1,1,2,3] and user enters [1,1,2,1]
    #the feedback should suggest correct position = 3 AND misplaced_colour = 0
    feedback = [" "," "," "," "]
    temp_code = solution.dup
    #finds correct colour and correct position
    temp_code.each_with_index do |ccolour, cindex|
      if ccolour == guess[cindex]
        feedback[cindex] = "green"
        #remove this colour from the solution to prevent false positives (via duplicates)
        temp_code[cindex] = nil
      end
    end
    #finds misplaced correct colour
    guess.each_with_index do |gcolour, gindex|
      if temp_code.include?(gcolour) && feedback[gindex] != "green"
        feedback[gindex] = "yellow"
        #remove the colour
        temp_code[temp_code.index(gcolour)] = nil
      end
    end
      feedback.sort!
      #sort the board to make it more difficult for user
      #user does not know which of their guess gives which response
      #i.e without sort, say code is [1,1,4,5]] and user guesses [1,4,1,5]
      #the output would be [green,yellow,yellow,green] instead of [g,g,y,y]
  end

end
