require 'yaml'

class Game

	def load_game
		if File.exists?("saves/saved.yaml")
			saved_game = YAML::load(File.read("saves/saved.yaml"))
			puts	
			saved_game.guess_word
		end
	end

	def save_game
		Dir.mkdir("saves") unless Dir.exists?("saves")
		File.open("saves/saved.yaml", "w") do |file|
			@new_game = true
			file.write(YAML::dump(self))
		end

		puts "GAME SAVED"
		exit
	end

	def choose_word
	dictionary = File.readlines "5desk.txt"
	@secret_word = dictionary[rand(0..61405)].strip.downcase
	correct_size = false
		while correct_size == false
			if @secret_word.length > 13
				@secret_word = dictionary[rand(0..61405)]
				puts @secret_word
			elsif @secret_word.length < 4 
				@secret_word = dictionary[rand(0..61405)]
				puts @secret_word
			end

			if @secret_word.length > 4 && @secret_word.length < 13
				correct_size = true
			end	
		end
	end

	def start_screen
		puts "Return to saved game? [load]"
		puts "Start a new game? [new]"
		input = gets.chomp.downcase

		valid = false
		while valid == false
			if input == 'load'
				load_game
				valid = false
				@new_game = true
			elsif input == 'new'
				@letter_arr = []
				valid = true
				@new_game = false
			else
				puts "invalid input"
			end
		end
	end

	def guess_word
	
	puts "you have #{@chances} guesses"
	puts "you're word is #{@secret_word.length} letters long"
	#sets up clues/wrong guesses array if it IS a new game(not if it is a load game)
	if @new_game == false
		@chances = 9
		@live = "I LIVE"
		@clues = "-" * (@secret_word.length)
	end

	puts @new_game
	puts @clues
	@secret_arr = @secret_word.split('')

	while @chances > 0	
		swap = false
		minus_one = false

		valid_guess = false
		puts "wrong guesses: #{@letter_arr}"

		while valid_guess == false
			puts "please make your guess (only one letter at a time)"
			puts "enter [save] to save your game and exit"
			puts "enter [quit] to exit"

			player_guess = gets.chomp.downcase
			if player_guess == "save"
				save_game	
			elsif player_guess == "quit"
				exit
			elsif player_guess.size == 1 && !@letter_arr.include?(player_guess)
				valid_guess = true
			end
		end

		puts "Your guess was #{player_guess}"

		@secret_arr.each_with_index do |letter, idx|
			if letter == player_guess
				@clues[idx] = player_guess
				swap = true
			else
				minus_one = true
			end
		end
		puts "clues: #{@clues}"
		test_2 = @clues

		if @clues == @secret_word
			puts "YOU WIN"
			@chances = 0
			exit
		end

		if swap == false
			@chances -= 1
			if @chances > 0
				puts "Sorry, you only have #{@chances} mistakes left"
				@letter_arr << player_guess
			else
				puts "GAME OVER"
				puts @secret_word
				@letter_arr << player_guess
				exit
			end
		end

		puts 
	end
	end

	def play
		choose_word
		guess_word
	end
end

a = Game.new
a.start_screen
a.play


