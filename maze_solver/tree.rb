class PolyTreeNode

  attr_accessor :children

  def initialize(value = nil)
    @parent
    @children = []
    @value = value
  end

  def parent
    @parent
  end

  def parent=(new_parent)
    if new_parent == nil
      @parent = nil
    elsif new_parent != parent
      #When a child changes it's parent, remove itself from the previous parent's child list.
      parent.children.delete(self) if parent
      @parent = new_parent
      parent.children << self unless parent.children.include?(self)
    end
  end

  def value
    @value
  end

  def add_child(child_node)
    @children << child_node
    child_node.parent = self
  end

  def remove_child(child_node)
    if children.include?(child_node)
      @children.delete(child_node)
      child_node.parent = nil
    else
      raise ArgumentError, "requested child not present in children"
    end
  end

  def to_s
    "#{@value}"
  end

  def inspect
    @value
  end

  def dfs(target_value)
    return self if self.value == target_value
    self.children.each do |child|
      node = child.dfs(target_value)
      return node if node
    end
    nil
  end

  def bfs(target_value)
    return self if self.value == target_value
    queue = self.children
    until queue.empty?
      current_node = queue.shift
      if current_node.value == target_value
        return current_node
      else
        queue += current_node.children
      end
      nil
    end
  end

  def trace_path_back(node = nil)
    path = []
    current_node = node || self
    while true
      path << current_node.value
      break if current_node.parent.nil?
      current_node = current_node.parent
    end
    path.reverse
  end
end
