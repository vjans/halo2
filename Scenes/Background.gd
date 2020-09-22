extends TileMap
 
 
var tiles = []
func initTiles():
 
	#make tiles 100x100 2d array and fill with 0 
 
	for i in range(100):
		tiles.append([])
		for j in range(100):	
			tiles[i].append(0)
 
func resetTiles():
 
	#set all tiles to 0
 
	for i in range(100):
		for j in range(100):
			tiles[i][j] = 0
 
func randomWalkers(var x, var y, var depth = 0, var dir = randi()%4):
 
#	random walkers unconver paths in the map by going in a random direction for a random amount of time
#	each tile they pass gets set to 1 (empty / not wall)
#	they split after a while recursively until a certain depth
 
	#set max depth 
	if depth >= 5: return
 
	#set position to input
	var posX = x
	var posY = y
 
	for i in range(10):
		#take step
 
		#turn on every 40th step
		var turn = false
		if randi()%40 == 0:
			var prev = dir
			#make sure to pick different direction
			while prev == dir:
				dir = randi()%4
			turn = true
 
		#move walker in current direction
		if dir == 0: 
			posX+=1
		if dir == 1: 
			posY+=1
		if dir == 2: 
			posX-=1
		if dir == 3: 
			posY-=1
 
		#check if still on map then update
		if posX < 0 or posX >= 100 or posY < 0 or posY >= 100:
			break
		else:
			tiles[posX][posY] = 1
			if turn:
				#remember the tiles where turns happened
				tiles[posX][posY] = 2
 
		#split in 2 
		if i == 9:
			randomWalkers(posX,posY,depth+1)
			randomWalkers(posX,posY,depth+1)
 
			#die and remember where
			if depth == 3:
				tiles[posX][posY] = 3;
			break
 
func putRoom(var x, var y):
 
	#generates a -for now quadratic- room at x,y	of size (2n+1)^2
 
	var n = 2+randi()%2 #room size
 
	for i in range(n*2+1):
		for j in range(n*2+1):
			tiles[x+i-n][y+j-n] = 1
 
func genRooms():
 
	#wherever a walker died we want a room (so they probably are not close and in dead ends)
 
	while true:
		for i in range(100):
			for j in range(100):
				if tiles[i][j] == 3:
					putRoom(i,j)
					continue
		break
 
func getLevelBounds():
	#find min/max x/y where tiles have been set
	var bounds = [100,0,100,0]
	for i in range(100):
		for j in range(100):
			if not tiles[i][j] == 0:
				if i < bounds[0]:bounds[0]=i #lower x
				if i > bounds[1]:bounds[1]=i #upper x
				if i < bounds[2]:bounds[2]=i #lower y
				if i > bounds[3]:bounds[3]=i #upper y
 
	return bounds
 
func updateLevel():
	#generates proper tiling from the raw collision map
 
	#find bounds where something happened
	var bounds = getLevelBounds()
	#only copy bounded area (saves time and space)
	for i in range(bounds[0],bounds[1]):
		for j in range(bounds[2],bounds[3]):
			var k = i-bounds[0]
			var l = j-bounds[2]
 
			#put each tile 2x2
			for x in range(2):
				for y in range(2):
					set_cell(k*2+x,l*2+y,tiles[i][j]-1) #-1 is empty 0 is default floor
 
func putUpper():
	for i in range(100):
		for j in range(100):
			if get_cell(i,j) == -1 and get_cell(i,j+1) == 0:
 
				#put upper tiles (more variety and flip /windows etc
				set_cell(i,j,7)
 
func putLower():
	for i in range(100):
		for j in range(100):
			if get_cell(i,j) == -1 and get_cell(i,j-1) == 0:
				set_cell(i,j,12)
 
 
func putSide():
	for i in range(100):
		for j in range(100):
			if get_cell(i,j) == -1 and (get_cell(i-1,j) == 0  or get_cell(i-1,j) == 7):
				set_cell(i,j,12,false,true,true)
 
	for i in range(100):
		for j in range(100):
			if get_cell(i,j) == -1 and (get_cell(i+1,j) == 0  or get_cell(i+1,j) == 7):
				set_cell(i,j,12,true,true,true)
 
 
func genMap():
 
	resetTiles()
	#carve out paths
	randomWalkers(50,50)
	#put room at spawn
	putRoom(50,50)
	#put rest of rooms
	genRooms()
 
 
 
	updateLevel()
	putUpper()
	putLower()
	putSide()
 
#called on setup
func _ready():
	initTiles()
 
	genMap()
 
 
	pass # Replace with function body.
 
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
 
