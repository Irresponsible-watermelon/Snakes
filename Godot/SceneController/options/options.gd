extends Panel

var temp_snake_texs: Array[Resource]
var temp_apple_tex: Resource

@export var diff_slider_nd: HSlider
@export var map_size_nd: TextEdit
@export var cell_size_nd: TextEdit
@export var bg_col_nd: ColorPickerButton
@export var bd_col_nd: ColorPickerButton
@export var ap_spr_nd: CheckButton
@export var ap_col_nd: ColorPickerButton
@export var sn_spr_nd: CheckButton
@export var sn_fill_nd: ColorPickerButton
@export var sn_bd_nd: ColorPickerButton
@export var hd_fill_nd: ColorPickerButton
@export var hd_bd_nd: ColorPickerButton

var diff_in: int
var map_size_in: int
var cell_size_in: int
# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func on_resources_updated():
	SceneManger.apple_spr_tex = temp_apple_tex
	SceneManger.snake_spr_texs = temp_snake_texs
	SceneManger.resource_refresh.emit()

func connect_signals():
	diff_slider_nd.drag_ended.connect(diff_slider_handler)
	map_size_nd.text_changed.connect(map_size_handler)
	cell_size_nd.text_changed.connect(cell_size_handler)
	bg_col_nd.color_changed.connect(bg_col_handler)
	bd_col_nd.color_changed.connect(bd_col_handler)
	ap_spr_nd.toggled.connect(ap_sprtd_handler)
	ap_col_nd.color_changed.connect(ap_col_handler)
	sn_spr_nd.toggled.connect(sn_spr_handler)
	sn_fill_nd.color_changed.connect(sn_fill_handler)
	sn_bd_nd.color_changed.connect(sn_bd_handler)
	hd_fill_nd.color_changed.connect(hd_fill_handler)
	hd_bd_nd.color_changed.connect(hd_bd_handler)

func option_updated():
	pass
#input handlers
func diff_slider_handler(value_changed: bool):
	if value_changed:
		diff_in = diff_slider_nd.get_value()
		option_updated()

func map_size_handler(text):
	var map_valid: bool = true
	var reject_reason: String
	map_size_in = int(text)
	if (map_size_in & 2) == 0:
		map_valid = false
		reject_reason = "Must be odd"
	if (map_size_in * SceneManger.cell_size) > get_viewport().height:
		map_valid = false
		reject_reason = "Too large"
	if map_valid:
		SceneManger.cells_across = map_size_in
		option_updated()
	elif not map_valid:
		map_size_nd.text = str(SceneManger.cells_across)

func cell_size_handler(text):
	var cell_valid: bool = true
	cell_size_in = int(text)
	if (cell_size_in * SceneManger.cellscells_across) > get_viewport().height:
		cell_valid = false
	if cell_valid:
		SceneManger.cell_size = cell_size_in
		option_updated()
	elif not cell_valid:
		cell_size_nd.text = str(SceneManger.cell_size)

func bg_col_handler(color: Color):
	SceneManger.background_col = color
	option_updated()

func bd_col_handler(color: Color):
	SceneManger.border_col = color
	option_updated()

func ap_sprtd_handler(checked: bool):
	SceneManger.is_ap_spr =! checked
	option_updated()

func ap_col_handler(color: Color):
	SceneManger.ap_col = color
	option_updated()

func sn_spr_handler(checked: bool):
	SceneManger.is_sn_spr =! checked
	option_updated()

func sn_fill_handler(color: Color):
	SceneManger.bd_fill_col = color
	option_updated()

func sn_bd_handler(color: Color):
	SceneManger.bd_bd_col = color
	option_updated()

func hd_fill_handler(color: Color):
	SceneManger.hd_fill_col = color
	option_updated()

func hd_bd_handler(color: Color):
	SceneManger.hd_bd_col = color
	option_updated()
