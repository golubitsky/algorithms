require_relative 'tree.rb'
require 'matrix'

class MazeSolver
  MOVES = [
    [-1, 0],
    [0, -1],
    [0, 1],
    [1, 0]
  ].map { |arr| Vector.elements(arr) }

  attr_accessor :maze, :all_positions_seen, :tree, :root, :target

  def initialize(maze = 'maze2.txt')
    @maze = File.readlines(maze).map do |line|
      line.scan(/./)
    end
    render_original_maze
    @all_positions_seen = []
    @root, @target = find_root_and_target
    @tree = generate_tree
  end

  def solve_maze
    tree.trace_path_back(tree.bfs(target)).each do |path_coord|
      maze[path_coord[0]][path_coord[1]] = "X"
    end
    render_solved_maze
    nil
  end

  def generate_tree #store coordinates in tree value
    self.all_positions_seen << root
    root_node = PolyTreeNode.new(root)
    queue = [root_node]
    while queue.any?
      current_node = queue.shift
      possible_moves(current_node.value).each do |move|
        unless all_positions_seen.include?(move)
          child_node = PolyTreeNode.new(move)
          current_node.add_child(child_node)
          queue << child_node
          self.all_positions_seen << move
        end
      end
    end
    root_node
  end

  def find_root_and_target #find start/end coords
    maze_start, maze_end = nil, nil
    maze.each_with_index do |line, line_number|
      line.each_with_index do |square, square_number|
        maze_end = Vector[line_number, square_number] if square == "E"
        maze_start = Vector[line_number, square_number] if square == "S"
      end
    end
    [maze_start, maze_end]
  end

  def possible_moves(current_position)
    potential_moves = []
    MOVES.each do |move|
      potential_move = current_position + move
      next if maze[potential_move[0]][potential_move[1]] == "*"
      next unless (0..7) === potential_move[0]
      next unless (0..15) === potential_move[1]
      potential_moves << potential_move
    end
    potential_moves
  end

  def render_original_maze
    puts "Original maze:"
    render_maze
  end

  def render_solved_maze
    puts "Solved maze:"
    render_maze
  end

  def render_maze
    maze.each do |line|
      line.each do |char|
        print char
      end
      puts
    end
  nil
  end

end

if $PROGRAM_NAME == __FILE__
  if ARGV.length > 0
    ARGV.each do |file|
      puts "Solution for #{file}!"
      MazeSolver.new(file).solve_maze
      puts
    end
  else
    MazeSolver.new.solve_maze
  end
  puts "All mazes solved!"
end
