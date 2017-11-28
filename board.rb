require "colorize"

class Board
  attr_accessor :attempt_number, :gameboard, :secret_code

  def initialize(active_player)
    #create secret code, attempt counter, and gameboard
    @secret_code = CodeSetter.new(active_player)
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
    return " ■".colorize(:red) if indicator == ("red" || 0)
  end

  def update_gameboard(guess)
    @gameboard[@attempt_number][0] = guess
    @gameboard[@attempt_number][1] = get_feedback(guess).map { |e| colorize(e) }
    @attempt_number += 1
  end

  #will be used to check for success
  def code_cracked?(guess)
    guess == @secret_code ? true : false
  end

  def get_feedback(guess)
    #correct_position is correct colour and position
    #checked is an array used to ensure that false-positive duplicates
    #do not occur. i.e if code is [1,1,2,3] and user enters [1,1,2,1]
    #the feedback should suggest correct_position = 3 AND misplaced_colour = 0
    correct_position = 0
    misplaced_colour = 0
    checked = []
    feedback = []

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

    correct_position.times{feedback << "green"}
    misplaced_colour.times{feedback << "yellow"}
    4-misplaced_colour-correct_position.times{feedback << "red"}
    #@@feedback used to update_gameboard
    return feedback
  end
  #reset feedback after each turn
end
