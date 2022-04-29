extends Object
# Main function for planet generation
export var Grid : Dictionary
# Also holds data :/
const characters : Array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
const resourcetypes : Array = ["FoodStuffs","Coal", "Stone", "Iron", "Iridium", "Generic Warp Material Idk"]
func new_galaxy():
	Grid = null # For freeing all nodes

func spiral_galaxy(a, b, rotations, cluster_distance, Objects) -> Dictionary:
	Grid.clear()
	for angle in range(0, (360 * rotations) + 1, ( cluster_distance)):
		var radian = deg2rad(angle)
		var radius = (a + (b * radian))
		var y = round(radius * cos(radian))
		var x = round(radius * sin(radian))
		Grid = create_cluster(Grid, Vector2(x, y), 6, Objects)
		continue
		 # Create a cluster in the given location
	return Grid
	
func create_cluster(grid, location, radius, Objects) -> Dictionary:
	for x in range(-radius,radius + 1, 2):
		for y in range(-radius, radius + 1, 2):
			if  (y*y) + (x*x) <= (radius * radius):
				if randf() < 0.3:
					var place := Vector2(location.x + x,location.y + y)
					if not grid.has(place):
						if checkneighbors(grid, place, 3) == 0:
							grid[place] = Objects.System.new()
							grid[place] = new_system(Grid[place], Objects)
				continue
			continue
		continue
	return Grid

# IF not 0, means theres a neighboring something
func checkneighbors(grid, location, radius) -> int:
	var count : int = 0
	for r in range(2, radius + 1):
		for x in range(-r,r + 1):
			for y in range(-r, r + 1):
				if count != 0:
					return 1
				match r:
					2: # Put checks and randomizers here
						count += checktile(x, y, grid, location, r)
					3:
						if randf() < 0.5:
							count += checktile(x, y, grid, location, r)
					4:
						if randf() < 0.1:
							count += checktile(x, y, grid, location, r)
	return 0

func checktile(x, y, grid, location, r) -> int:
	if  (y*y) + (x*x) <= (r * r):
		if grid.has((location + Vector2(x, y))):
			return 1
		return 0
	return 0
func new_system(System, Objects):
	System.star_name = generate_name(characters)
	System.star_type = generate_star_type()
	System.planets = generate_planets(System.star_name, System.planets, Objects)
	System.planets[Vector2(0, 0)] = Objects.Body.new()
	System.planets[Vector2(0, 0)].body_type = System.star_type
	return System

func generate_star_type() -> int:
	randomize()
	if randf() <= 0.1:
		return 3
	if randf() <= 0.2:
		return 5
	if randf() <= 0.5:
		return 4
	if randf() <= 1:
		return 6
	else:
		return randi() % 6 + 3

func generate_planet_type() -> int:
	randomize()
	if randf() <= 0.15:
		return 0
	if randf() <= 0.25:
		return 1
	if randf() <= 0.35:
		return 2
	else:
		return randi() % 2

func generate_name(characters) -> String:
	randomize()
	var name : String = ''
	for _place in range(0, randi() % 10):
		name += characters[randi() % (characters.size())]
		continue
	return name

# Responsible For creating new planets
func generate_planets(star_name, planets, Objects) -> Dictionary:
	var R : int = 3 # Internal Radius# External radius
	var r : int = 1 + R
	for planet in (randi() % 7 + 2):
		while true:
			var x = randi() % r
			var y = randi() % r
			if randf() < 0.5:
				x = -x
			if randf() < 0.5:
				y = -y
			if  (y*y) + (x*x) <= (r * r) and (y*y) + (x*x) >= (R * R):
				if not planets.has(Vector2(x, y)): # In empty# Create Dict Key
					if checkneighbors(planets, Vector2(x, y), 2) == 0:
						planets[Vector2(x, y)] = Objects.Body.new() # Checks if empty
						planets[Vector2(x, y)] = new_planet(star_name, planets[Vector2(x, y)], planet)
						R = R + (randi() % 3 + 1) # Random Distance between planets
						r = 2 + R
						break
					continue
				continue
			continue
		continue
	return planets

func new_planet(star_name, location, count) -> Object:
	randomize()
	location.body_name = str(star_name) + " " + str(count)
	location.body_type = generate_planet_type()
	return location
	
# Creates a cluster of new planets

# Shapes of a galaxy
