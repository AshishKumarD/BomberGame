extends HBoxContainer

var player_labels = {}
var playing_players = []


func _ready():
	$"../Winner".hide()
	set_process(true)


func _process(_delta):
	var rocks_left = $"../Rocks".get_child_count()
	if rocks_left == 0:
		var winner_name = ""
		var winner_score = 0
		for p in player_labels:
			if player_labels[p].score > winner_score:
				winner_score = player_labels[p].score
				winner_name = player_labels[p].name

		$"../Winner".set_text("THE WINNER IS:\n" + winner_name)
		$"../Winner".show()
		


func increase_score(for_who):
	assert(for_who in player_labels)
	var pl = player_labels[for_who]
	pl.score += 1
	pl.label.set_text(pl.name + "\n" + str(pl.score))


func add_player(id, new_player_name):
	var l = Label.new()
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.set_text(new_player_name + "\n" + "0")
	l.set_h_size_flags(SIZE_EXPAND_FILL)
	var font = preload("res://montserrat.otf")
	l.set("custom_fonts/font", font)
	l.set("custom_font_size/font_size", 18)
	add_child(l)

	player_labels[id] = { name = new_player_name, label = l, score = 0 }
	playing_players.append(id)


func kill_player(id):
	id = int(id) # Ensure consistent type

	print("players", playing_players)
	print("killing player", id)

	if id in player_labels:
		print("true 1")
		player_labels[id].label.hide()
		
	if id in playing_players:
		print("true 2")
		playing_players.erase(id)

	print("players", playing_players)

	if playing_players.size() <= 1 && playing_players.size() >0:
		print("true 3")
		check_for_winner()



func check_for_winner():
	if playing_players.size() >= 1:
		var winner_id = playing_players[0]
		if winner_id in player_labels:
			var winner_name = player_labels[winner_id].name
			$"../Winner".set_text("THE WINNER IS:\n" + winner_name)
			$"../Winner".show()
	elif playing_players.size() == 0:
		$"../Winner".set_text("NO ONE WINS :(")
		$"../Winner".show()


func _on_exit_game_pressed():
	gamestate.end_game()
