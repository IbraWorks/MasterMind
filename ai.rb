class AiPlayer

  def initialize
    @set = all_possible_answers
    @feedback_to_evaluation = []
    @first_guess = true
    @guess = []
    @all_combos = all_possible_answers
  end

  #get set of all possible answers
  def all_possible_answers
    [1,2,3,4,5,6].repeated_permutation(4).to_a
  end

  def guess
    if @first_guess
      @first_guess = false
      @guess = [1,1,2,2]
      @set.delete([1,1,2,2])
    #if theres one combo left in the set, thats the answer
    elsif @set.length == 1
      @guess = @set[0]
    else
      eliminate_combos
      @guess = minmax_technique
      @set.delete(@guess)
    end
    print "The Computer has guessed: #{@guess.join} "
    return @guess
  end

  def minmax_technique
    possible_responses =  [[0,0], [0,1], [0,2], [0,3], [0,4], [1,0], \
                          [1,1], [1,2], [1,3], [2,0], [2,1], [2,2], \
                          [3,0], [4,0]]
    minimum = 10**100
    best_combo = nil
    @all_combos.each do |guess|
      maximum = 0
      possible_responses.each do |response|
        count = 0
        @set.each do |code|
          if response == evaluate_guess(guess,code)
            count += 1
          end
        end
        maximum = count if count > maximum
      end
      if maximum < minimum
        minimum = maximum
        best_combo = guess
      end
    end
    return best_combo
  end

  def evaluate_guess(guess,secret_code)
    correct_position = 0
    misplaced_colour = 0
    checked = []

    guess.each_with_index do |gcolour, gindex|
      if gcolour == secret_code[gindex]
        correct_position += 1
        if checked[gindex] == gcolour
          misplaced_colour -= 1
        else
          checked[gindex] = gcolour
        end
      else
        secret_code.each_with_index do |ccolour, cindex|
          if gcolour == ccolour && gcolour != secret_code[gindex] && checked[cindex] != ccolour
            misplaced_colour += 1
            checked[cindex] = ccolour
          end
        end
      end
    end
    return [correct_position,misplaced_colour]
  end

  def update_feedback(feedback)
    @feedback_to_evaluation = feedback
  end

  def eliminate_combos
    #go through set, get rid of combos that dont return same number of
    #correct_position and misplaced_colour given the last guess
    @set.delete_if do |code|
      response = evaluate_guess(@guess,code)
      if (response[0] != @feedback_to_evaluation[0]) || (response[1] != @feedback_to_evaluation[1])
        true
      end
    end
  end

end
