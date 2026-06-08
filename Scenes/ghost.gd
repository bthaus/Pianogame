extends Enemy


func shoot():
	return
func connect_action():
	beat.beat.connect(move.bind(Vector2.ZERO))
func max_proximity_to_player():
	return 0
func _on_hitbox_body_entered(body: Node2D) -> void:
	if hp<=0:return
	body.hit(10,color)
	pass # Replace with function body.
func set_color():
	if player==null:
		player=PlayerCharacter.instance
	var colors_player_has=[]	
	if unlocked_colors.is_empty():
		var spells=PlayerCharacter.learned_spells
		
		for spell in spells:
			var instance:Spell=player.piano.get_spell_instance(spell)
			if instance.color==null:continue
			if not colors_player_has.has(instance.color):
				colors_player_has.append(instance.color)
		print(colors_player_has)
		unlocked_colors.append_array(colors_player_has)		
	#if override_color==Colorss.None:
	color=color_dic.keys()[unlocked_colors.pick_random()]
	#else: color=colors[override_color]
	var temp=color
	#color=unlocked_colors.pick_random()
	#if color==Colorss.Red:
		#hp*=2
	$PointLight2D.color=color_dic[color]
	$AnimatedSprite2D.modulate=color_dic[color]	
