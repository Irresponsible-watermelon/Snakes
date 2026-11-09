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
@export var file_dia_nd: FileDialog
@export var error_dia_nd: AcceptDialog

var diff_in: int
var map_size_in: int
var cell_size_in: int
var ap_col_in: Color
var sn_fl_in: Color
var sn_bd_in: Color
var hd_fl_in: Color
var hd_bd_in: Color

# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	connect_signals()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


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
	file_dia_nd.dir_selected.connect(snake_dialog_handler)
	file_dia_nd.file_selected.connect(apple_dialog_handler)

func option_updated():
	pass
	if not SceneManger.is_ap_spr:
		SceneManger.apple_use_tex = SceneManger.apple_col_tex
	elif SceneManger.is_ap_spr:
		SceneManger.apple_use_tex = SceneManger.apple_spr_tex
	
	if not SceneManger.is_sn_spr:
		SceneManger.snake_use_texs = SceneManger.snake_col_texs
	elif SceneManger.is_sn_spr:
		SceneManger.snake_use_texs = SceneManger.snake_spr_texs
		
	SceneManger.resource_refresh.emit()

#input handlers
func diff_slider_handler(value_changed: bool):
	if value_changed:
		SceneManger.difficulty = diff_slider_nd.get_value()
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
	ap_col_in = color
	SceneManger.ap_col = to_tex(ap_col_in, ap_col_in)
	option_updated()

func sn_spr_handler(checked: bool):
	SceneManger.is_sn_spr =! checked
	option_updated()

func sn_fill_handler(color: Color):
	sn_fl_in = color
	SceneManger.bd_col_tx = to_tex(sn_fl_in, sn_bd_in)
	option_updated()

func sn_bd_handler(color: Color):
	sn_bd_in = color
	SceneManger.bd_col_tx = to_tex(sn_fl_in, sn_bd_in)
	option_updated()

func hd_fill_handler(color: Color):
	hd_fl_in = color
	SceneManger.hd_fill_col = to_tex(hd_fl_in, hd_bd_in)
	option_updated()

func hd_bd_handler(color: Color):
	hd_bd_in = color
	SceneManger.hd_bd_col_tx = to_tex(hd_fl_in, hd_bd_in)
	option_updated()
	
func snake_dialog_handler(path):
	var required_files = [
		"Body.png",
		"Up.png",
		"Down.png",
		"Left.png",
		"Right.png"
	]
	var generated_files: Array[Resource]
	var failed: bool
	
	for file in required_files:
		var file_path = path.path_join(file)
		if not FileAccess.file_exists(file_path):
			error_dia_nd.popup_centered()
			failed = true
			return
		else:
			generated_files.append(load(file_path))
	if not failed:
		SceneManger.snake_spr_texs = generated_files
		option_updated()

func apple_dialog_handler(path):
	SceneManger.apple_spr_tex = load(path)
	option_updated()

func to_tex(fl_col: Color, bd_col: Color):
	var img_rect: Rect2i
	img_rect.size = Vector2i(46, 46)
	img_rect.position = Vector2i(2, 2)
	var tex_image = Image.create(50, 50, false, Image.FORMAT_RGBA8)
	tex_image.fill(bd_col)
	tex_image.fill_rect(img_rect, fl_col)
	
	var col_tex: Texture2D = ImageTexture.create_from_image(tex_image)
	return col_tex
