require 'matrix'
KNIGHT_MOVES = [ Vector[2, 1], 	Vector[2, -1], Vector[-2, 1], Vector[-2, -1], Vector[1, 2], Vector[1, -2], Vector[-1, 2], Vector[-1, -2]  ]
X = 0
Y = 1
LETTERS = [0, *'a'..'h']
class Graph
	attr_reader :nodes

	def initialize
		@nodes = generate_nodes
		generate_edges
	end

	def add_edge(predecessor_name, successor_name)
		nodes[predecessor_name].add_edge(nodes[successor_name])
	end

	def [](name)
		nodes[name]
	end

	def to_s
		arr = []
		self.nodes.each do |name, node|
	 		arr << node.to_s
		end
		arr.join("\n")
	end

	def initialize_tour(start_square)
		nodes[start_square].visited = true
		route = [start_square]
		tour(route)
	end

	def tour(route)
		nodes[route.last].successors.each do |square|
			p route.length
			next if nodes[square].visited?
			route << square
			nodes[square].visited = true
			if tour(route) == false
				nodes[route.last].visited = false
				route.pop
			end
		end
		return false
	end

	def all_squares_visited?
		nodes.each do |name, node|
			return false unless node.visited?
		end
		true
	end

	private

		def generate_nodes #called by initialize
			nodes = {}
			[*1..8].each do |x|
				[*1..8].each do |y|
					name = "#{LETTERS[x]}#{y}".intern
					nodes[name] = Node.new(x, y)
				end
			end
			nodes
		end

		def generate_edges #name 			#node
			nodes.each do |current_square, current|
				moves = generate_moves(current.position)
				moves.each do |move|
					new_square_vector = current.position + move
					new_square = (LETTERS[new_square_vector[X]].to_s + new_square_vector[Y].to_s).intern
					current.successors << new_square
				end
			end
		end

		def generate_moves(position) #helper of generate_edges
			moves = []
			KNIGHT_MOVES.each do |move|
				potential_move = position + move
				next if potential_move[X] < 1 || potential_move[X] > 8
				next if potential_move[Y] < 1 || potential_move[Y] > 8
				moves << move
			end
			moves
		end
end

class Node
	attr_accessor :predecessor, :successors, :position, :visited

	def initialize(x, y)
		@position = Vector[x, y]
		@successors = []
		@distance = nil #computed in search algorithm (in Graph)
		@color = "white" #used in search algorithm (in Graph)
		@visited = false
	end

	def add_edge(successor)
		successors << successor
	end

	def visited?
		visited
	end

	def to_s
		successors.join(' ')
	end
end

=begin
graph = Graph.new #initialize Graph with all potential states stored as nodes
graph.nodes.each do |name, node|
	puts "#{name}: #{node}"
end
=end
board = Graph.new
p board.initialize_tour(:a1)
