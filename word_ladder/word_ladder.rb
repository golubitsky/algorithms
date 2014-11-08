#http://en.wikipedia.org/wiki/Word_ladder

class Graph

  attr_reader :words

  def initialize
    @words = {}
    build_graph
  end

  def build_graph
    input_word_list = File.read('four_letter_words.txt').scan(/\w+/)
    input_word_list.map!{ |word| word.downcase }
    matches = {}
    input_word_list.each do |word|
      i = 0
      while i < word.length #generate matches
        current_match = ''
        current_match << word[0...i]
        current_match << "_"
        current_match << word[i+1..-1] unless i == 3
        if matches.keys.include?(current_match) #add word to bucket
          matches[current_match] << word
        else #make bucket with word
          matches[current_match] = [word]
        end
        i += 1
      end
    end
    matches.each do |match, words|
      words.each do |word1|
        words.each do|word2|
          add_node(word1) unless @words.include?(word1)
          add_node(word2) unless @words.include?(word2)
          add_edge(word1, word2) unless word1 == word2
        end
      end
    end
  end

  def add_node(word)
    words[word] = Node.new(word)
  end

  def add_edge(word1, word2)
    words[word1].neighbors << word2
  end

  def to_s
    words.each do |name, node|
      puts "#{name}: #{node.neighbors.join(' ')}"
    end
  end

  def bfs(word, other_word) #breadth-first-search
    initialize_graph_for_search #reset preds/colors/distances
    words[word].color = "gray"
    word_queue = [word]
    while word_queue.length > 0
      current_word = word_queue.shift
      words[current_word].neighbors.each do |neighbor|
        if words[neighbor].color == "white"
          words[neighbor].color = "gray"
          words[neighbor].pred = current_word
          words[neighbor].distance = words[current_word].distance + 1
          word_queue << neighbor
        end
      end
    end
    "#{words[other_word].distance} steps: #{find_connections(word, other_word)}"
  end

  private

    def find_connections(word1, word2) #bfs helper method
      result = "#{word2}"
      until words[word2].pred == word1
        pred = words[word2].pred
        result.insert(0, "#{pred}-")
        word2 = pred
      end
      result.insert(0, "#{word1}-")
      result
    end

    def initialize_graph_for_search
      words.each do |name, node|
        node.initialize_for_search
      end
    end

end

class Node
  attr_accessor :neighbors, :color, :distance, :pred

  def initialize(word)
    @neighbors = []
    @color = "white"
    @distance = 0
    @pred = nil
  end

  def initialize_for_search
    @color = "white"
    @distance = 0
    @pred = nil
  end
end

graph = Graph.new
p graph.bfs("hate", "love")
p graph.bfs("cold", "warm")
p graph.bfs("live", "dead")

