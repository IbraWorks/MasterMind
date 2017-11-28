class CodeSetter
  attr_accessor :secret_code

  def initialize(active_player)
    active_player ? @secret_code = create_secret_code : @secret_code = get_player_secret_code
  end

  def get_player_secret_code
    puts "\n\nplease enter your four-digit secret code."
    puts "Any combination of digits from 1-6. You can have duplicates"
    player_secret_code = gets.chomp.split("").map(&:to_i)

    if !validity(player_secret_code)
      puts "please follow the format and try again"
      get_player_secret_code
    end
    player_secret_code
  end

  def create_secret_code
    user_secret_code = []
    4.times do
    user_secret_code.push([1,2,3,4,5,6].sample)
   end
   return user_secret_code
  end

  def validity(user_input)
  return false if user_input.length != 4
  return false if !user_input.all?{|element| element.class == Fixnum}
  return false if !user_input.all?{|element| (1..6).include?(element)}
  true
  end
end
