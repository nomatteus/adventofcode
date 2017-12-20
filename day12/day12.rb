lines = IO.read('./input').strip.split("\n")

class Graph
  attr_accessor :vertices

  def initialize
    # Map of vertex numeric id to vertex object
    @vertices = {}
  end

  def add_vertex(source_id, destination_ids)
    vertex = find_or_create_vertex(source_id)
    @vertices[source_id] = vertex
    dest_vertices = destination_ids.map{ |id| find_or_create_vertex(id) }
    vertex.add_edges(dest_vertices)
    dest_vertices.each { |destv| @vertices[destv.id] = destv }
  end

  def get_vertex(id)
    @vertices[id]
  end

  def dfs(vertex, visited=[])
    edges = vertex.edges - visited
    edges.each do |edge_vertex|
      visited << edge_vertex
      dfs(edge_vertex, visited)
    end
    visited
  end

private

  # find a vertext by its numeric identifier
  def find_or_create_vertex(id)
    @vertices[id]  || Vertex.new(id)
  end
end

class Vertex
  attr_accessor :edges, :id

  def initialize(id)
    @id = id
    @edges = []
  end

  # Edges are just a collection of vertexes that we are connected to
  # Expects an array of vertices
  def add_edges(vertices)
    @edges += vertices
  end

  # Equality defined by a numeric identifier
  def ==(other_vertex)
    self.id == other_vertex.id
  end
end

graph = Graph.new

lines.each do |line|
  source, destinations = line.split(' <-> ')
  source_id = source.to_i
  destination_ids = destinations.split(', ').map(&:to_i)

  graph.add_vertex(source_id, destination_ids)
end

root_vertex = graph.get_vertex(0)
visited_vertices = graph.dfs(root_vertex)
part1 = visited_vertices.uniq.size

puts "Part 1: #{part1}"


groups = []
# Track vertex IDs that have been assigned to a group (so we know we can skip them)
vertex_ids_group_found = []

graph.vertices.values.each do |vertex|
  next if vertex_ids_group_found.include?(vertex.id)
  visited_vertices = graph.dfs(vertex)
  group_vertex_ids = visited_vertices.collect(&:id)
  groups << group_vertex_ids
  vertex_ids_group_found += group_vertex_ids
end

part2 = groups.size
puts "Part 2: #{part2}"
