require 'matrix'
#constants
KNIGHT_MOVES = [ Vector[2, 1], 	Vector[2, -1], Vector[-2, 1], Vector[-2, -1], Vector[1, 2], Vector[1, -2], Vector[-1, 2], Vector[-1, -2]  ]
X = 0
Y = 1
LETTERS = [0, *'a'..'h']

class Graph
    attr_reader :nodes
    attr_accessor :knights_tour, :call_counter

    @knight_tour = [];
    def initialize
        @nodes = generate_nodes
        @knights_tour = []
        generate_edges
        order_moves
        @call_counter = 0
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

    def find_knights_tour(square)
        initialize_tour
        find_tour(square)
        knights_tour
    end

    def find_tour(square)
        @call_counter += 1
        nodes[square].visited = true
        knights_tour << square
        if knights_tour.length < 64
            done = false
            nodes[square].successors.each do |successor|
                next if nodes[successor].visited?
                done = find_tour(successor)
            end
            if done == false
                knights_tour.pop
                nodes[square].visited = false
            end
        else
            done = true
        end
        done
    end

    def initialize_tour #used to run search multiple times
        @knights_tour = []
        nodes.each { |name, node| node.visited = false }
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
                    current.add_edge(new_square)
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

        def order_moves #order successive moves by number of next successive moves (Warnsdorff Heuristic)
            nodes.each do |name, node|
                number_of_successors = {}
                node.successors.each do |successor|
                    number_of_successors[successor] = nodes[successor].successors.count
                end
                number_of_successors = number_of_successors.sort_by{|k,v| v} #sort from least to most successive moves
                node.successors = []
                number_of_successors.each { |n| node.add_edge(n.first) } #reorder according to heuristic
            end
        end

end

class Node
    attr_accessor :successors, :position, :visited

    def initialize(x, y)
        @position = Vector[x, y]
        @successors = []
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


graph = Graph.new #initialize Graph with all potential states stored as nodes

edge_total = 0  #how many total edges in the graph
graph.nodes.each do |name, node|
    edge_total += node.successors.count
end

p "There are #{edge_total} possible knight moves on an 8x8 chess board."

graph.nodes.each do |name, node|
p graph.find_knights_tour(name)
end
p "All 64 solutions found using #{graph.call_counter} recursive calls."
