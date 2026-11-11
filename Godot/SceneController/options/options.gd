extends Control

@export var close_button: Button
@export var diff_slider_nd: HSlider
@export var map_size_nd: LineEdit
@export var cell_size_nd: LineEdit
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
var head_tex_in: Resource
var body_tex_in: Resource
var snake_texs_in: Array[Resource]

func _ready() -> void:
	connect_signals()
	diff_slider_nd.value = SceneManger.difficulty
	ap_spr_nd.button_pressed = ! SceneManger.is_ap_spr
	sn_spr_nd.button_pressed = ! SceneManger.is_sn_spr

func connect_signals():
	
	close_button.button_up.connect(close_button_handler)
	diff_slider_nd.drag_ended.connect(diff_slider_handler)
	map_size_nd.text_submitted.connect(map_size_handler)
	cell_size_nd.text_submitted.connect(cell_size_handler)
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
	SceneManger.options_update.emit()

#input handlers
func diff_slider_handler(value_changed: bool):
	if value_changed:
		@warning_ignore("narrowing_conversion")
		SceneManger.difficulty = diff_slider_nd.get_value()
		option_updated()

func map_size_handler(text):
	var map_valid: bool = true
	var reject_reason: String
	map_size_in = int(text)
	if (map_size_in & 2) == 0:
		map_valid = false
		reject_reason = "Must be odd"
	if (map_size_in * SceneManger.cell_size) > get_viewport().get_visible_rect().size.y:
		map_valid = false
		reject_reason = "Too large"
	if map_valid:
		SceneManger.cells_across = map_size_in
		option_updated()
	elif not map_valid:
		map_size_nd.text = str(SceneManger.cells_across)
		print_debug(reject_reason)

func cell_size_handler(text):
	var cell_valid: bool = true
	cell_size_in = int(text)
	if (cell_size_in * SceneManger.cells_across) > get_viewport().get_visible_rect().size.y:
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
	SceneManger.border_update.emit()

func ap_sprtd_handler(checked: bool):
	if checked:
		SceneManger.is_ap_spr = false
	elif not checked:
		SceneManger.is_ap_spr = true
	print_debug("is_ap_spr ", SceneManger.is_ap_spr)
	option_updated()

func ap_col_handler(color: Color):
	ap_col_in = color
	SceneManger.apple_col_tex = to_tex(ap_col_in, ap_col_in)
	option_updated()

func sn_spr_handler(checked: bool):
	SceneManger.is_sn_spr =! checked
	option_updated()

func sn_fill_handler(color: Color):
	sn_fl_in = color
	body_tex_in = to_tex(sn_fl_in, sn_bd_in)
	snake_array()

func sn_bd_handler(color: Color):
	sn_bd_in = color
	body_tex_in = to_tex(sn_fl_in, sn_bd_in)
	snake_array()

func hd_fill_handler(color: Color):
	hd_fl_in = color
	head_tex_in = to_tex(hd_fl_in, hd_bd_in)
	snake_array()

func hd_bd_handler(color: Color):
	hd_bd_in = color
	head_tex_in = to_tex(hd_fl_in, hd_bd_in)
	snake_array()

func snake_dialog_handler(path):
	var required_files_a = [
		"Body.png",
		"Up.png",
		"Down.png",
		"Left.png",
		"Right.png"
	]
	var required_files_b = [
		"Body.png",
		"Head.png"
	] 
	var generated_files: Array[Resource] = []
	var is_a: bool
	var is_b: bool
	
	for file in required_files_a:
		var file_path = path.path_join(file)
		if not FileAccess.file_exists(file_path):
			is_a = false
		else:
			is_a = true
			if file == required_files_a[0]:
				generated_files.append(load(file_path))
			elif (file == required_files_a[1]):
				generated_files.append(load(file_path))
	
	if not is_a:
		generated_files = []
		for file in required_files_b:
			var file_path = path.path_join(file)
			if not FileAccess.file_exists(file_path):
				is_b = false
			else:
				is_b = true
				generated_files.append(load(file_path))
	
	if is_a or is_b:
		SceneManger.snake_spr_texs = generated_files
		option_updated()
	else:
		error_dia_nd.popup_centered()

func apple_dialog_handler(path):
	SceneManger.apple_spr_tex = load(path)
	option_updated()

func close_button_handler():
	SceneManger.options_state.emit(false)

func to_tex(fl_col: Color, bd_col: Color):
	var img_rect: Rect2i
	img_rect.size = Vector2i(46, 46)
	img_rect.position = Vector2i(2, 2)
	var tex_image = Image.create(50, 50, false, Image.FORMAT_RGBA8)
	tex_image.fill(bd_col)
	tex_image.fill_rect(img_rect, fl_col)
	
	var col_tex: Texture2D = ImageTexture.create_from_image(tex_image)
	return col_tex

func snake_array():
	snake_texs_in = []
	snake_texs_in.append(body_tex_in)
	var counter: int = 0
	while counter < 4:
		snake_texs_in.append(head_tex_in)
		counter += 1
	SceneManger.snake_col_texs = snake_texs_in
	option_updated()
