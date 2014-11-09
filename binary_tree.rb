class Tree
  attr_accessor :left, :right, :data

  def initialize(data=nil)
    @data = data
    @left = nil
    @right = nil
  end

  def insert(value)
    if @data == nil
      @data = value
    elsif value <= @data
      if @left.nil?
        @left = Tree.new(value)
      else
        @left.insert(value)
      end
    elsif value > @data
      if @right.nil?
        @right = Tree.new(value)
      else
        @right.insert(value)
      end
    end
  end

  def to_s
    "#{data}"
  end

  def in_order_tree_walk
    unless data.nil?
      left.in_order_tree_walk unless left.nil?
      puts data
      right.in_order_tree_walk unless right.nil?
    end
  end
end

tree = Tree.new
20.times {tree.insert(rand(100)) }
tree.in_order_tree_walk
