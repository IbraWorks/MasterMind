class AiPlayer

  def initialize
    @set = all_possible_answers
    @feedback_to_evaluation = []
    @guess_count = 0
    @guess = []
    @all_combos = all_possible_answers
  end

  #get set of all possible answers
  def all_possible_answers
    [1,2,3,4,5,6].repeated_permutation(4).to_a
  end

  def get_guess(secret_code_to_compare_guess)
    if @guess_count == 0
      @guess = [1,1,2,2]
      @set.delete([1,1,2,2])
    elsif @set.length == 1
      @guess = @set[0]
    else
      @feedback_to_evaluation = evaluate(@guess, secret_code_to_compare_guess)
      @guess = minmax_technique
    end
    @guess_count += 1
    puts "The Computer guesses: #{@guess.join("")}"
    return @guess
  end

  def minmax_technique
    possible_solutions = []

    @set.each { |solution|
      possible_solutions << solution if evaluate(@guess, solution) == @feedback_to_evaluation
    }
    @set = possible_solutions.dup

    @guess = @set.sample
    @set.delete(@guess)
    return @guess
  end

  def evaluate(guess, answer)
    feedback = [" ", " ", " ", " "]
    # Duplicate temp_code so it doesn't point directly to @code (destructive)
    temp_code = answer.dup

    # Correct color and position = 1
    temp_code.each_with_index do |x, index|
        if x == guess[index]
          feedback[index] = 1
          # Remove the used color
          temp_code[index] = nil
        end
      end

    # misplaced_colour = 0
    guess.each_with_index do |x, index|
        if temp_code.include?(x) && feedback[index] != 1
          feedback[index] = 0
          # Remove the used color by finding the index
          temp_code[temp_code.index(x)] = nil
        end
      end

    feedback
  end

end
