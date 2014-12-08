class List
  attr_reader :head #used for extend and zip

  def initialize
    @head = nil
  end

  def is_empty?
    @head == nil
  end

  def add_front(data)
    @head = @head ? Node.new(data, @head) : Node.new(data)
  end

  def add_end(data)
    if @head
      current_node = @head
      current_node = current_node.next while current_node.next
      current_node.next = Node.new(data)
    else
      @head = Node.new(data)
    end
  end

  def pop_end
    return false if self.is_empty?
    @head = nil unless @head.next
    current_node = @head
    while current_node.next
      current_node, previous_node = current_node.next, current_node
    end
    popped = current_node.data
    previous_node.next = nil
    return popped
  end

  def pop_front
    return false if self.is_empty?
    pop = @head.data
    @head = @head.next ? @head.next : nil
    return pop
  end

  def search(data)
    current_node = @head
    while current_node
      return true if current_node.data == data
      current_node = current_node.next
    end
    false
  end

  def count
    return 0 if self.is_empty?
    current_node, count = @head, 1
    while current_node.next
      count += 1
      current_node = current_node.next
    end
    count
  end

  def remove(data)
    if @head.data == data
      @head = @head.next
      return true
    end
    current_node = @head
    while current_node
      current_node, previous_node = current_node.next, current_node
      return false unless current_node #avert disaster if data doesn't exist in list
      if current_node.data == data
        previous_node.next = current_node.next
        return true
      end
    end
  end

  def extend(other_list)
    list_copy = self.clone
    current_node = list_copy.head
    while current_node
      previous_node, current_node = current_node, current_node.next
    end
    previous_node.next = other_list.head
    list_copy
  end

  def clone
    new_list = List.new
    return new_list if self.is_empty?
    current_node = self.head
    while current_node
      new_list.add_end(current_node.data)
      current_node = current_node.next
    end
    new_list
  end

  def extend!(other_list)
    if self.is_empty?
      @head = other_list.head
    else
      current_node = @head
      current_node = current_node.next while current_node.next
      current_node.next = other_list.head
    end
    self
  end

  def zip(other_list) #to_be_continued
    current_node_this = self.head
    if current_node_this == nil
      return other_list.clone
    else
      new_list = List.new
      current_node_that = other_list.head
    end
    while current_node_this || current_node_that
      if current_node_this
        new_list.add_end(current_node_this.data)
        current_node_this = current_node_this.next
      end
      if current_node_that
        new_list.add_end(current_node_that.data)
        current_node_that = current_node_that.next
      end
    end
    new_list
  end

  def inspect

  end

  def to_s
    arr = []
    current_node = @head
    while current_node
      arr << current_node.data
      current_node = current_node.next
    end
    arr.join(', ') #need to insert logic for arrays/hashes stored in data
  end

end

class Node
  attr_accessor :next, :data
  def initialize(data, next_node = nil)
    @data = data
    @next = next_node
  end

  def to_s
    "#{@data}"
  end
end

a = List.new
b = List.new
10.times { a.add_end(rand(10)) }
10.times { b.add_front(rand(10)) }
a.extend(b)
p a.count
p b.count
a.extend!(b)
p a.count
p b.count
p a.to_s
