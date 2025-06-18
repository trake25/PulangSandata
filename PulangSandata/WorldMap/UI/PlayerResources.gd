extends Control

@onready var food_label : Label = %FoodLabel
@onready var wood_label : Label = %WoodLabel
@onready var weapons_label : Label = %WeaponsLabel
@onready var wealth_label : Label = %WealthLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Initializer.player_resources = self
	Initializer.playerresouces_isready = true
	print("Player Resources ready")

func initialize() -> void:
	print("Player Resources initialized")
