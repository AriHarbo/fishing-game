extends Control
class_name FishSlot

signal slot_clicked(slot_index: int) # Señal que detecta clicks

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
var fish_data: Variant = {}
var is_empty: bool = true

var slot_index: int = -1  # Índice del slot en el equipo
var is_selected: bool = false  # Si está seleccionado actualmente

# Iconos de elementos (debes asignarlos en el inspector o cargarlos)
@export var element_icons: Dictionary = {
	"water": preload("res://assets/elements/waterElement.png")
}

func _ready():
	# Asegurarse de que el HPBar tenga las texturas necesarias si no están en el inspector
	setup_hp_bar()
	clear_slot()
	mouse_filter = Control.MOUSE_FILTER_STOP # Esto hace que el slot sea clickeable

	
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Solo emite señal si el slot no está vacío
			if not is_empty:
				slot_clicked.emit(slot_index)

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
func set_fish(fish: Variant):
	fish_data = fish
	is_empty = false
	
	# Detectar si es FishData o Dictionary
	var is_resource = fish is FishData
	
	# Mostrar icono del pez
	var icon = fish.sprite if is_resource else (fish.get("icon") if fish.has("icon") else null)
	if icon:
		fish_icon.texture = icon
		fish_icon.visible = true
	
	# Mostrar nombre del pez
	var name = fish.fish_name if is_resource else (fish.get("name") if fish.has("name") else "")
	if name:
		fish_name_label.text = name
		fish_name_label.visible = true
	
	# Configurar barra de HP
	var current = fish.current_hp if is_resource else (fish.get("current_hp") if fish.has("current_hp") else 0)
	var maximum = fish.max_hp if is_resource else (fish.get("max_hp") if fish.has("max_hp") else 0)
	
	if current and maximum:
		hp_bar.visible = true
		hp_bar.max_value = maximum
		hp_bar.value = current
		ps_text.text = str(current) + "/" + str(maximum)
	
	# Configurar elementos
	var elements = fish.elements if is_resource else fish.get("elements", [])
	setup_elements(elements)

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

func set_selected(selected: bool):
	is_selected = selected
	
	if selected:
		# Resaltar el slot seleccionado (tono amarillento/dorado)
		modulate = Color(1.2, 1.2, 0.8)
	else:
		# Color normal
		modulate = Color.WHITE
