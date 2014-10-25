require 'matrix'

class Graph
	attr_reader :nodes

	def initialize
		@nodes = generate_nodes
		generate_edges
	end

	def add_edge(predecessor_name, successor_name)
		@nodes[predecessor_name].add_edge(@nodes[successor_name])
	end

	def [](name)
		@nodes[name]
	end

	def to_s
		arr = []
		self.nodes.each do |name, node|
	 		arr << node.to_s
		end
		arr.join("\n")
	end

	def bfs(source) #breadth first search compute distances to a source vertex
		source = nodes[source]
		source.color = "gray" #some adjacents discovered
		source.distance = 0
		q = [source]
		while q.size > 0
			u = q.shift
			u.successors.each do |successor|
				if nodes[successor].color == "white" #no adjacents discovered
					nodes[successor].color = "gray"
					nodes[successor].distance = u.distance + 1
					q.push(nodes[successor])
				end
			end
			u.color = "black" #all adjacents discovered
		end
	end

	private

		def generate_nodes #called by initialize
			nodes = {}
			node_count = 1
			(3.downto(0)).each do |cannibals|
				(3.downto(0)).each do |missionaries|
					(0..1).each do |boat| #boat 0 designates boat on left bank
						if node_count < 10
							name = "node0#{node_count}".intern
						else
							name = "node#{node_count}".intern
						end
						nodes[name] = Node.new(cannibals, missionaries, boat)
						node_count += 1
					end
				end
			end
			nodes
		end

		def generate_edges #called by initialize

			nodes.each do |current_name, current|
				case current.boat
					when 0 then trip_vectors = generate_vectors(0) #boat on left side
					when 1 then trip_vectors = generate_vectors(1) #boat on right side
				end
				trip_vectors.each do |trip_vector|
					nodes.each do |compare_name, compare|
						potential_trip = current.vector + trip_vector
						if (current.boat != compare.boat) && #boat goes across
							(potential_trip == compare.vector) && #with 2 ppl
							(potential_trip[0] <= potential_trip[1] || potential_trip[1]==0) &&
							(potential_trip[2] <= potential_trip[3] || potential_trip[3]==0)
								#no cannibals will eat any missionaries on either side
								current.successors << compare_name
						end #e.g. we can get to the compare node from current node
					end
				end
			end
		end

		def generate_vectors(boat) #helper of generate_edges
			vectors = []
			plus=[ [2,0], [0,2], [1,1], [1,0], [0,1] ]
			minus=[ [-2,0], [0,-2], [-1,-1], [-1,0], [0,-1] ]
			if boat==0 #boat on left side
				(0..4).each do |n|
					vectors << Vector.elements(minus[n] + plus[n])
				end
			else
				(0..4).each do |n|
					vectors << Vector.elements(plus[n] + minus[n])
				end
			end
			vectors
		end
end

class Node
	attr_accessor	:cannibals_left, :missionaries_left
	attr_accessor	:cannibals_right, :missionaries_right
	attr_accessor	:color, :distance, :predecessor
	attr_reader :name, :successors, :vector, :boat

	def initialize(cannibals, missionaries, boat)
		@successors = []
		@cannibals_left = cannibals
		@missionaries_left = missionaries
		@boat = boat
		@cannibals_right = 3 - @cannibals_left
		@missionaries_right = 3 - @missionaries_left
		@vector = Vector[@cannibals_left, @missionaries_left, @cannibals_right, @missionaries_right]
		@distance = nil #computed in search algorithm (in Graph)
		@color = "white" #used in search algorithm (in Graph)
	end

	def add_edge(successor)
		@successors << successor
	end

	def to_s
		str = "<"
		str << @cannibals_left.to_s
		str << ', '
		str << @missionaries_left.to_s
		str << ', '
		str << @cannibals_right.to_s
		str << ', '
		str << @missionaries_right.to_s
		str << ', '
		str << @boat.to_s
		str << ">"
	end

	def hash #not sure if this is necessary
		self.to_s.hash
	end
end

graph = Graph.new #initialize Graph with all potential states stored as nodes

#list all possible successors for each node
graph.nodes.each do |name, node|
	puts "#{name.capitalize}: #{node} #{node.successors}"
end
# no routes to or from the following 4 nodes--as expected!!!
p graph[:node02].to_s
p graph[:node08].to_s
p graph[:node25].to_s
p graph[:node31].to_s

graph.bfs(:node01) #compute distance from
p graph[:node32].distance
