extends CanvasLayer

@onready var health_label = get_node_or_null("Control/VBoxContainer/HealthLabel")
@onready var item_label = get_node_or_null("Control/VBoxContainer/ItemLabel")
@onready var message_label = get_node_or_null("Control/VBoxContainer/MessageLabel")
@onready var message_timer = get_node_or_null("MessageTimer")

func _ready():
	if message_timer:
		message_timer.timeout.connect(_on_message_timer_timeout)
		
func _process(_delta):
	var player = get_tree().get_first_node_in_group("Player")
	if player and health_label and item_label:
		health_label.text = "Vida: " + str(player.health)
		item_label.text = "Itens: " + str(player.items_collected) + "/5"
	
	if player and health_label and item_label:
		health_label.text = "Vida: " + str(player.health)
		item_label.text = "Itens: " + str(player.items_collected) + "/5"
	else:
		if not player:
			print_once("Aviso: Player não encontrado no grupo 'Player'")

var warned = false
func print_once(msg):
	if not warned:
		print(msg)
		warned = true
		
func display_message(text: String):
	if message_label:
		message_label.text = text
		if message_timer:
			message_timer.start()

func _on_message_timer_timeout():
	if message_label:
		message_label.text = ""
