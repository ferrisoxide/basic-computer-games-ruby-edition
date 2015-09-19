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

  def root_question
    @root_question ||= Question.new(
      text: "Does it swim?",
      yes_path: Animal.new(name: 'fish'),
      no_path:  Animal.new(name: 'bird')
    )
  end

  def play
    display_welcome_message
    prompt_to_start

    current_question = root_question
    previous_question = nil
    previous_path = ''

    while true
      answer = ask_question(current_question)

      if current_question.is_a?(Question)
        previous_question = current_question
        previous_path = answer
        # Set next question
        current_question = case answer
        when 'Y' then current_question.yes_path
        when 'N' then current_question.no_path
        end
        next
      end

      if current_question.is_a?(Animal)
        if answer == 'Y'
          puts "Why not try another animal?"
        else
          puts "The animal you were thinking of was a?"
          new_animal_name = get_answer
          last_animal_name = current_question.name
          puts "Please type a question that would distinguish a #{last_animal_name} from a #{new_animal_name}"
          new_question_text = get_answer
          puts "For a #{new_animal_name} the answer would be?"
          yes_or_no = get_yn_answer

          new_animal = Animal.new(name: new_animal_name)

          case yes_or_no
          when 'Y' then
            new_yes_path = new_animal
            new_no_path  = current_question
          when 'N' then
            new_yes_path = current_question
            new_no_path  = new_animal
          end

          new_question = Question.new(
            text: new_question_text,
            yes_path: new_yes_path,
            no_path: new_no_path
          )

          case previous_path
          when 'Y' then previous_question.yes_path = new_question
          when 'N' then previous_question.no_path = new_question
          end
        end

        current_question = root_question
        previous_question = nil
        previous_path = ''
        prompt_to_start
      end
    end
  end

  private

  def get_answer
    answer = ''
    while answer == ''
      answer = gets.chomp
    end
    answer
  end

  def get_yn_answer
    answer = ''
    while answer != 'Y' && answer != 'N'
      answer = get_answer.upcase
    end
    answer
  end

  def ask_question(node)
    if node.is_a?(Animal)
      puts "Is it a #{node.name}"
    else
      puts node.text
    end
    get_yn_answer
  end

  def display_welcome_message
    puts "Animal"
    puts "Adapted from a BASIC game from Creative Computing - Morristown, New Jersey."
    puts "\n\n"
    puts "Play 'Guess the Animal'"
    puts "Think of an animal and the computer will try and guess it."
  end

  def prompt_to_start
    while true
      puts "Are you thinking of an animal?"
      answer = gets.chomp.upcase
      list_animals if answer == 'LIST'
      return if answer == 'Y'
    end
  end

  def list_animals
    puts 'Animals I know'
    animals = collect_animals(root_question, [])
    animals.each do |animal|
      puts animal.name
    end
  end

  def collect_animals(node, animals)
    if node.is_a?(Animal)
      animals << node
    else
      animals = collect_animals(node.yes_path, animals)
      animals = collect_animals(node.no_path, animals)
    end
    animals
  end

end

game = Game.new
game.play
