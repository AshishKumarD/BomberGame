#extends Node2D
#
#func _ready():
	#var rocks := []
	#
	## Collect all rock nodes (CharacterBody2D instances)
	#for child in get_children():
		#if child is CharacterBody2D and child.name.begins_with("Rock"): # Optional: name check if you want
			#rocks.append(child)
	#
	## Shuffle and pick 20% of them
	#rocks.shuffle()
	#var number_to_disable := int(rocks.size() * 0.5)
#
	#for i in range(number_to_disable):
		#var rock = rocks[i]
		#disable_rock(rock)
#
#func disable_rock(rock: CharacterBody2D) -> void:
	#rock.visible = false
	#rock.set_physics_process(false)
	#rock.set_process(false)
	#rock.set_collision_layer(0)
	#rock.set_collision_mask(0)
#
	## Optional: if it has a CollisionShape2D, disable it too
	#for child in rock.get_children():
		#if child is CollisionShape2D:
			#child.disabled = true
			
extends Node2D

func _ready():
	if is_multiplayer_authority():
		print("randomizing rocks")
		var rocks := []
		
		for child in get_children():
			if child is CharacterBody2D and child.name.begins_with("Rock"):
				rocks.append(child)
		
		rocks.shuffle()
		var number_to_disable := int(rocks.size() * 0.5)
		var rock_names_to_disable := []

		for i in range(number_to_disable):
			rock_names_to_disable.append(rocks[i])

		# Call the RPC on all clients including self
		print("disable")
		rpc("disable_rocks_rpc", rock_names_to_disable)
		disable_rocks_rpc(rock_names_to_disable)

@rpc("any_peer")
func disable_rocks_rpc(rocks: Array) -> void:
	print("disabling rocks")
	for i in range(rocks.size()):
		var rock = rocks[i]
		_disable_rock(rock)

func _disable_rock(rock: CharacterBody2D) -> void:
	rock.visible = false
	rock.set_physics_process(false)
	rock.set_process(false)
	rock.set_collision_layer(0)
	rock.set_collision_mask(0)

	for child in rock.get_children():
		if child is CollisionShape2D:
			child.disabled = true
