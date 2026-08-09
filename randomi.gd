extends Node3D

@onready var dialog_controller: CanvasLayer = $"../../DialogController2"

var shanca = {
	"Miri": 800,
	"MiriShume": 200,
	"Keqi": 500,
	"KeqiShume": 150
}

func tipiShanca() -> int:

	var rng = RandomNumberGenerator.new()
	rng.randomize()

	# 1. Calculate weighted sum (1650 total)
	var weightedSum: int = 0
	for key in shanca:
		weightedSum += shanca[key]

	# 2. Pick random roll from 1 to 1650
	var tipiType: int = rng.randi_range(1, weightedSum)
	var selected_rarity: String = "Miri"

	# 3. Correct Weighted Roll Logic
	for key in shanca:
		var weight = shanca[key]
		if tipiType <= weight:
			selected_rarity = key
			break
		tipiType -= weight
		

	# 4. Map to integer ID
	match selected_rarity:
		"Miri":
			return 0
		"MiriShume":
			return 1
		"Keqi":
			return 2
		"KeqiShume":
			return 3
		_:
			return 0
