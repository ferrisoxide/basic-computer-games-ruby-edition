#! /usr/bin/env ruby
class Animal
  attr_reader :name

  def initialize(args)
    @name = args[:name]
  end
end

class Question
  attr_reader :text
  attr_accessor :yes_path, :no_path

  def initialize(args)
    @text     = args[:text]
    @yes_path = args[:yes_path]
    @no_path  = args[:no_path]
  end
end

class Game

  def starting_position
    @starting_position ||= Question.new(
      text: "Does it swim?",
      yes_path: Animal.new(name: 'fish'),
      no_path:  Animal.new(name: 'bird')
    )
  end

  def play
    puts "Animal"
    puts "Adapted from a BASIC game from Creative Computing - Morristown, New Jersey."
    puts "\n\n"
    puts "Play 'Guess the Animal'"
    puts "Think of an animal and the computer will try and guess it."

    prompt_to_start

    current_position = starting_position
    previous_position = nil
    previous_path = ''

    while true
      answer = ask_question(current_position)

      if current_position.is_a?(Question)
        previous_position = current_position
        previous_path = answer

        current_position = case answer
        when 'Y' then current_position.yes_path
        when 'N' then current_position.no_path
        end
        next
      end

      if current_position.is_a?(Animal)
        if answer == 'Y'
          puts "Why not try another animal?"
        else
          new_animal_name = get_input "The animal you were thinking of was a?"
          last_animal_name = current_position.name
          new_question_text = get_input "Please type a question that would distinguish a #{last_animal_name} from a #{new_animal_name}"
          yes_or_no = get_yn_answer "For a #{new_animal_name} the answer would be?"

          new_animal = Animal.new(name: new_animal_name)

          case yes_or_no
          when 'Y' then
            new_yes_path = new_animal
            new_no_path  = current_position
          when 'N' then
            new_yes_path = current_position
            new_no_path  = new_animal
          end

          new_question = Question.new(
            text: new_question_text,
            yes_path: new_yes_path,
            no_path: new_no_path
          )

          case previous_path
          when 'Y' then previous_position.yes_path = new_question
          when 'N' then previous_position.no_path = new_question
          end
        end

        current_position = starting_position
        previous_position = nil
        previous_path = ''
        prompt_to_start
      end
    end
  end

  private

  def get_input(prompt)
    is_valid = false

    while !is_valid
      puts prompt
      input = gets.chomp
      is_valid = !input.empty?
      is_valid = is_valid && yield(input) if block_given?
    end

    input
  end

  def get_yn_answer(prompt)
    get_input(prompt) do |input|
      input.upcase == 'Y' || input.upcase == 'N'
    end.upcase
  end

  def ask_question(node)
    prompt = if node.is_a?(Animal)
      "Is it a #{node.name}"
    else
      node.text
    end
    get_yn_answer(prompt)
  end

  def prompt_to_start
    get_input "Are you thinking of an animal?" do |input|
      case input.upcase
      when 'Y' then true
      when 'LIST' then
        list_animals
        false
      else
        false
      end
    end
  end

  def list_animals
    puts 'Animals I know'
    animals = collect_animals(starting_position, [])
    animals.each do |animal|
      puts animal.name
    end
  end

  def collect_animals(position, animals)
    if position.is_a?(Animal)
      animals << position
    else
      animals = collect_animals(position.yes_path, animals)
      animals = collect_animals(position.no_path, animals)
    end
    animals
  end

end

game = Game.new
game.play
