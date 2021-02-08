extends Resource

class_name SM_Tree

class Point:
	var type : int
	var out_edges : Array
	var name : String

var graph := Array()

func _ready():
	pass

func find(graph, name):
	for i in range(len(graph)):
		if graph[i].name == name:
			return i
	return -1

func connect_to_break(state, br):
	var s_num = find(graph, state)
	if s_num == -1:
		print("Nie ma takiego stanu: ", state)
		return
	if graph[s_num].out_edges.find(br) == -1:
		graph[s_num].out_edges.push_back(br)
	else:
		print("Już jest połączenie z tym przerywaczem: ", br)

func connect_to_state(br, state):
	var b_num = find(graph, state)
	if b_num == -1:
		print("Nie ma takiego przerywacza: ", br)
		return
	if len(graph[b_num].out_edges) != 0:
		print("Usuwam stare połączenie: ", graph[b_num].out_edges[0])
		graph[b_num].out_edges.clear()
	graph[b_num].out_edges.push_back(state)

func add_point(type : int, name : String):
	var p = Point.new()
	p.type = type
	p.name = name
	p.out_edges = []
	graph.push_back(p)
