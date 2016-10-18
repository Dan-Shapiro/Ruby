#Classes
class List
	attr_reader :all_tasks
	def initialize
		@all_tasks = []
	end

	public
	def add(task)
		all_tasks << task
	end
	def show
		curr = 1
		@all_tasks.each do |task, index| 
			puts "#{curr}: #{task.description}"
			curr += 1
		end
	end
	def read_file(filename)
		IO.readlines(filename).each do |line|
			status, *description = line.split(":")
			status = status.include?("X")
			add(Task.new(description.join(":").strip, status))
		end
	end
	def write_file(filename)
		machinified = @all_tasks.map(&:to_machine).join("\n")
		IO.write(filename, machinified)
	end
	def delete(task_number)
		all_tasks.delete_at(task_number - 1)
	end
	def update(task_number, task)
		all_tasks[task_number - 1] = task
	end
	def toggle(task_number)
		all_tasks[task_number - 1].toggle_status
	end
end

class Task
	attr_reader :description
	attr_accessor :status
	def initialize(description, status=false)
		@description = description
		@status = status
	end

	public
	def to_s
		description
	end
	def completed?
		status
	end
	def to_machine
		"#{represent_status}:#{description}"
	end
	def toggle_status
		@completed_status = !completed?
	end

	private
	def represent_status
		"#{completed? ? '[X]' : '[ ]' }"
	end
end

#modules
module Menu
	def menu
		" Welcome to the TodoList!
		This menu lists the Tasks
		1) Add
		2) Show
		3) Update
		4) Delete
		5) Write to file
		6) Read from file
		7) Toggle status
		Q) Quit "
	end
	def show
		menu
	end
end

module Promptable
	def prompt(message="What would you like to do?", symbol=":> ")
		print message
		print symbol
		gets.chomp
	end
end

#actions
if __FILE__ == $PROGRAM_NAME
	include Menu
	include Promptable
	my_list = List.new
	puts "Please choose form the list"
	until ["q"].include?(user_input=prompt(show).downcase)
		case user_input
			when "1" then my_list.add(Task.new(prompt("What is the task you would like to accomplish?")))
			when "2" then my_list.show
			when "3"
				my_list.show
				my_list.update(prompt("Which task number to update?").to_i, Task.new(prompt("New description?")))
			when "4"
				my_list.show
				my_list.delete(prompt("Which task number to delete?").to_i)
			when "5" then my_list.write_file(prompt("What is the filename to write to?"))
			when "6"
				begin
					my_list.read_file(prompt("What is the filename to read from?"))
				rescue Errno::ENOENT
					puts "Filename not found"
				end
			when "7"
				my_list.show
				my_list.toggle(prompt("Which task number to toggle?").to_i)
			else puts "Sorry, I did not understand"
		end
		prompt("Press enter to continue", "")
	end
	puts "Thanks for using the menu system"
end