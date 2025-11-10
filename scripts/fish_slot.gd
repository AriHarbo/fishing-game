extends Control
class_name FishSlot

# Referencias a los nodos
@onready var background: TextureRect = $Background
@onready var fish_icon: TextureRect = $FishIcon
@onready var fish_name_label: Label = $FishName
@onready var hp_bar: TextureProgressBar = $HPBar
@onready var ps_text: Label = $HPBar/PSText
@onready var element_container: VBoxContainer = $ElementContainer
@onready var element_icon_1: TextureRect = $ElementContainer/Element1
@onready var element_icon_2: TextureRect = $ElementContainer/Element2

# Datos del pez
var fish_data: Dictionary = {}
var is_empty: bool = true

# Iconos de elementos (debes asignarlos en el inspector o cargarlos)
@export var element_icons: Dictionary = {
	"water": preload("res://assets/elements/waterElement.png")
}

func _ready():
	# Asegurarse de que el HPBar tenga las texturas necesarias si no están en el inspector
	setup_hp_bar()
	clear_slot()

func setup_hp_bar():
	# Si el HPBar no tiene texturas asignadas, usar ColorRect como alternativa
	if hp_bar.texture_progress == null:
		# Crear texturas básicas por código
		var bg_texture = create_simple_texture(Vector2(110, 20), Color(0.2, 0.2, 0.2, 0.8))
		var progress_texture = create_simple_texture(Vector2(110, 20), Color(0.8, 0.2, 0.2, 1.0))
		
		hp_bar.texture_under = bg_texture
		hp_bar.texture_progress = progress_texture

func create_simple_texture(size: Vector2, color: Color) -> ImageTexture:
	var img = Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	img.fill(color)
	return ImageTexture.create_from_image(img)

# Configurar el slot con datos de un pez
func set_fish(fish: Dictionary):
	fish_data = fish
	is_empty = false
	
	# Mostrar icono del pez
	if fish.has("icon") and fish.icon:
		fish_icon.texture = fish.icon
		fish_icon.visible = true
	
	# Mostrar nombre del pez
	if fish.has("name"):
		fish_name_label.text = fish.name
		fish_name_label.visible = true
	
	# Configurar barra de HP
	if fish.has("current_hp") and fish.has("max_hp"):
		hp_bar.visible = true
		hp_bar.max_value = fish.max_hp
		hp_bar.value = fish.current_hp
		ps_text.text = str(fish.current_hp) + "/" + str(fish.max_hp)
	
	# Configurar elementos
	setup_elements(fish.get("elements", []))

# Configura los iconos de elementos
func setup_elements(elements: Array):
	element_icon_1.visible = false
	element_icon_2.visible = false
	
	if elements.size() > 0:
		element_container.visible = true
		
		# Primer elemento
		if element_icons.has(elements[0]):
			element_icon_1.texture = element_icons[elements[0]]
			element_icon_1.visible = true
		
		# Segundo elemento (si existe)
		if elements.size() > 1 and element_icons.has(elements[1]):
			element_icon_2.texture = element_icons[elements[1]]
			element_icon_2.visible = true
	else:
		element_container.visible = false

# Limpiar slot
func clear_slot():
	is_empty = true
	fish_data = {}
	
	# Mostrar placeholders en vez de ocultar
	fish_name_label.text = "???????????"
	ps_text.text = "Slot-"
	hp_bar.value = 0
	
	element_icon_1.visible = false
	element_icon_2.visible = false

# Actualizar solo el HP en combate
func update_hp(current: int, maximum: int):
	if not is_empty:
		hp_bar.max_value = maximum
		hp_bar.value = current
		ps_text.text = str(current) + "/" + str(maximum)

# Verificar si el slot está vacío
func is_slot_empty() -> bool:
	return is_empty
