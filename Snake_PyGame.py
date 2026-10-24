import pygame
import pygame.freetype
import random
import pygame_gui
import tkinter as tk
from tkinter import filedialog
from pathlib import Path
pygame.init() 
file_dialog_root = tk.Tk()
file_dialog_root.withdraw()

# define what size the gameboard will be
cells_across = int(12)
cell_size = int(50)
cells_up = int(12)

Screen_Width = int(cell_size * cells_across)
Screen_height = int(cell_size * cells_up)

# decide what size window will be

display_info = pygame.display.Info()

Parent_height = max(Screen_height, display_info.current_h // 2)
Parent_Width = max(Screen_Width, display_info.current_w // 2)

# Draw & name window
Parent_Window = pygame.display.set_mode((Parent_Width, Parent_height), pygame.RESIZABLE)
pygame.display.set_caption('PyGame Snake')

# Position gameboard in centre of window

Screen_x = ((Parent_Width - Screen_Width) // 2)
Screen_y = ((Parent_height - Screen_height) // 2)
screen = pygame.Surface((Screen_Width, Screen_height))

#variables

#actually importantish for things to work

direction = 'U' # UDLR, Up Down Left Right
hungry = True
Apple = [0, 0]
PotApple = [0, 0]
click_coords = [0, 0]
shed = False
game_over = False
head_count = 0
AppInSnake = False
Snake_fed = False
clock = pygame.time.Clock()
FPS = 60
base_cps = 2 #cells snake travels per second
cps_inc = 1 #How much cps is increased every time an apple is eaten
true_cps = base_cps #(For now, increasing true_cps over time or once an apple is eaten could be interesting)
Slithertavel = 1000 / true_cps # Milliseconds between each snake movement
Slithimer = 0 # Time since last snake movement
playing = True
skin_sprited = True
apple_sprited = True
apple_sprite_folder = "Apple sprites"
snake_sprite_folder = "Snake sprites"
default_body = 'My_Snake_1'
font_folder = "opendyslexic-0.92"
start_menu = False
pause_menu = False
playing = True
options = False
open_dialogue = None
ap_pre_rect = 0, 0
bin = None
#menus

pause_screen = pygame.Surface((Parent_Width, Parent_height), pygame.SRCALPHA)
gameover_screen =  pygame.Surface((Parent_Width, Parent_height))
start_screen = pygame.Surface((Parent_Width, Parent_height))

options_width = ((Parent_Width * 2) // 3)
options_height = ((Parent_height * 2) // 3)
options_x = (Parent_Width - options_width) // 2
options_y = (Parent_height - options_height) // 2 

options_screen = pygame.Surface((options_width, options_height),pygame.SRCALPHA)

apple_dialog = None
selected_apple = None
selected_apple_path = None

selected_body = None

#controls

move_left_key = pygame.K_a
move_right_key = pygame.K_d
move_down_key = pygame.K_s
move_up_key = pygame.K_w

#cosmetic & stats

screen_bg_col = (0, 0, 0,)
parent_bg_col = (30, 25 ,45)
button_col = (128, 128, 128, 216)
button_border = (255, 255, 255, 216)
snake_skin = (255, 255, 255)
snake_guts = (0, 0, 0)
snake_head = (255, 255, 255)
Apple_variety = (51, 204, 51)
Greyout_col = (128, 128, 128, 128) #(R, G, B, A), where A = 0 is fully transparent and A = 255 is fully opaque
mistakes_avoided = 0
autopsy = ''
max_cps = 0
options_bg_col = (200, 200, 200, 150)

#fonts

Bold_font = pygame.freetype.Font(str(Path(__file__).resolve().parent
                                     / "Assets"
                                     / "opendyslexic-0.92"
                                     / "OpenDyslexic-Bold.otf"), 12)

BoldItalic_font = pygame.freetype.Font(str(Path(__file__).resolve().parent
                                     / "Assets"
                                     / "opendyslexic-0.92"
                                     / "OpenDyslexic-BoldItalic.otf"), 12)

Reg_font = pygame.freetype.Font(str(Path(__file__).resolve().parent
                                     / "Assets"
                                     / "opendyslexic-0.92"
                                     / "OpenDyslexic-Regular.otf"), 12)

Reg_font_lg = pygame.freetype.Font(str(Path(__file__).resolve().parent
                                     / "Assets"
                                     / "opendyslexic-0.92"
                                     / "OpenDyslexic-Bold.otf"), 24)


Italic_font = pygame.freetype.Font(str(Path(__file__).resolve().parent
                                     / "Assets"
                                     / "opendyslexic-0.92"
                                     / "OpenDyslexic-Italic.otf"), 12)



#snake
snake_box = [[int(Screen_Width / 2), int(Screen_height / 2)]]
snake_box.append([int(Screen_Width / 2), int((Screen_height / 2) + cell_size)])
snake_box.append([int(Screen_Width / 2), int((Screen_height / 2) + (cell_size * 2))])

#functions

# High level functions
def clear_screen():
    Parent_Window.fill(parent_bg_col)
    screen.fill(screen_bg_col)
    options_screen.fill(options_bg_col)


def is_snake_dead(game_over, autopsy):
    head_count = 0
    for segment in snake_box:
        if snake_box[0] == segment and head_count > 1:
            game_over = True
            autopsy = 'GRD'
        head_count += 1
    
    if snake_box[0][0] < 0 or snake_box[0][0] > Screen_Width - cell_size or snake_box[0][1] < 0 or snake_box[0][1] > Screen_height - cell_size:
        game_over = True
        autopsy = 'OOB'

    return game_over, autopsy   

def draw_gameboard():
    Parent_Window.blit(screen, (Screen_x, Screen_y))

def on_game_over():
    pass

def on_resize(Parent_Width, Parent_height):
    global Parent_Window, Screen_x, Screen_y, options_width, options_height, options_x, options_y, options_screen, pause_screen, gameover_screen, start_screen, Manager

    # Parent & screen resize

    Parent_Window = pygame.display.set_mode((Parent_Width, Parent_height), pygame.RESIZABLE)
    Screen_x = (Parent_Width - Screen_Width) // 2
    Screen_y = (Parent_height - Screen_height) // 2

    #options resize

    options_width = ((Parent_Width * 2) // 3)
    options_height = ((Parent_height * 2) // 3)
    options_x = (Parent_Width - options_width) // 2
    options_y = (Parent_height - options_height) // 2

    options_screen = pygame.Surface((options_width, options_height))

    #other menus resize
    pause_screen = pygame.Surface((Parent_Width, Parent_height), pygame.SRCALPHA)
    gameover_screen =  pygame.Surface((Parent_Width, Parent_height))
    start_screen = pygame.Surface((Parent_Width, Parent_height))

    #options button resize
    options_btn.x = Parent_Width // 2
    options_btn.y = (Parent_height // 3) + 45
    options_btn.button_surface = pause_screen

    #restart button resize
    restart_btn.x = Parent_Width // 2
    restart_btn.y = Parent_height // 3
    restart_btn.button_surface = pause_screen

    #quit button resize
    quit_btn.x = Parent_Width // 2
    quit_btn.y = (Parent_height // 3) + 90
    quit_btn.button_surface = pause_screen

    #update pygame
    update_Manager()
def asset_selector(asset_subfolder, fileroot, FFP=False):
    if asset_subfolder == snake_sprite_folder:
        if not FFP:
            paths = [str(Path(__file__).resolve().parent
                            / "Assets"
                            / str(asset_subfolder)
                            / str(fileroot)
                            / "Up.png"),
                        str(Path(__file__).resolve().parent
                                / "Assets"
                                / str(asset_subfolder)
                                / str(fileroot)
                                / "Down.png"),
                        str(Path(__file__).resolve().parent
                                / "Assets"
                                / str(asset_subfolder)
                                / str(fileroot)
                                / "Left.png"), 
                        str(Path(__file__).resolve().parent
                                / "Assets"
                                / str(asset_subfolder)
                                / str(fileroot)
                                / "Right.png"), 
                        str(Path(__file__).resolve().parent
                                / "Assets"
                                / str(asset_subfolder)
                                / str(fileroot)
                                / "Body.png"), 
                            ]
        elif FFP:
            paths = [
                str(Path(__file__).resolve()
                    / asset_subfolder
                    / "Up.png"),
                str(Path(__file__).resolve()
                    / asset_subfolder
                    / "Down.png"),
                str(Path(__file__).resolve()
                    / asset_subfolder
                    / "Left.png"),
                str(Path(__file__).resolve()
                    / asset_subfolder
                    / "Right.png"),
                str(Path(__file__).resolve()
                    / asset_subfolder
                    / "Body.png"),
            ]
        return paths
    else:
        abs_path = str(Path(__file__).resolve().parent
            / "Assets"
            / str(asset_subfolder)
            / str(fileroot)
            )
        return abs_path

# if asset type not head, outputs file path.
    # if asset type head, outputs list, with filepaths for each directional sprite, ordered UDLR. Requires head sprites to have following path: /Assets/Snake head sprites/[folder name = fileroot]/[Up/Down/Left/Right]

# pause_manager

def on_esc_pressed():
    global playing, pause_menu, options

    if playing:
        playing = False
        pause_menu = True
    elif not playing:
        playing = True
        pause_menu = False
        options =  False

def draw_pause():
    pause_screen.fill(Greyout_col)
    restart_btn.draw()
    options_btn.draw()
    quit_btn.draw()
    Parent_Window.blit(pause_screen, (0,0))

def quit_press():
    global run
    run = False
# options
         
def options_press():
    global options
    if options == False:
        options = True
    else:
        options = False

def draw_options_menu():
    Parent_Window.blit(options_screen, (options_x, options_y))

def draw_options_title():
    global opts_title_bg_rect
    font_rect = Reg_font_lg.get_rect("Options")
    font_rect.centerx = options_width // 2
    font_rect.y = 10
    opts_title_bg_rect = font_rect.copy()
    opts_title_bg_rect.inflate_ip(20, 12)
    pygame.draw.rect(options_screen,(0,0,0, 128),opts_title_bg_rect, border_radius= 3)
    Reg_font_lg.render_to(options_screen,font_rect.topleft, "Options", (255, 255, 255))

draw_options_title()
# resume
def restart_press():
    global start_menu, pause_menu, playing
    start_menu = True
    pause_menu = False
    playing = False

def start_press():
    global start_menu, playing
    start_menu = False
    playing = True

# Variables reliant on functions

button_font = pygame.freetype.Font(asset_selector(font_folder,"OpenDyslexic-Regular.otf"), 24)

#classes

class button:
    def __init__(self, xcp, ycp, Button_Surface, txt_col, ButtonText='button', onClickFunction=None):
        self.x = xcp
        self.y = ycp
        self.onClickFunction = onClickFunction
        self.alreadypressed = False
        self.bg_col = button_col
        self.border_col = button_border
        self.ButtonText = ButtonText
        self.button_surface = Button_Surface
        self.txt_col = txt_col
        self.padding_x = 10
        self.padding_y = 10
        font_rect = button_font.get_rect(self.ButtonText)
        self.width = font_rect.width + self.padding_x
        self.height = font_rect.height + self.padding_y
        self.temp_rect = pygame.Rect(0, 0, self.width, self.height)
        self.temp_rect.center = (self.x, self.y)
        self.temp_surface = pygame.Surface(self.temp_rect.size)

    def draw(self):
        pygame.draw.rect(self.temp_surface, self.border_col,(0, 0, self.width, self.height,), border_radius= 3)
        pygame.draw.rect(self.temp_surface,self.bg_col,(0 + 2, 0 + 2, self.width - 4, self.height- 4,), border_radius= 3)
        text_box = button_font.get_rect(self.ButtonText)
        text_box.center = (self.temp_surface.get_rect().center)
        button_font.render_to(
            self.temp_surface,
            text_box,
            self.ButtonText,
            fgcolor= self.txt_col
        )
        self.button_surface.blit(self.temp_surface, self.temp_rect.topleft)

#Start Buttons

start_btn = button(
        Parent_Width // 2, (Parent_height // 3),
        start_screen, button_border,
        "Play", start_press
    )

start_options_btn = button(
    Parent_Width // 2, (Parent_height // 3) + 45,
        start_screen, button_border,
        "Options", options_press
    )

start_quit_btn = button(
        Parent_Width // 2, (Parent_height //3) + 90,
        start_screen, button_border,
        "Quit", quit_press
)
#Pause Buttons
restart_btn = button(
        Parent_Width // 2, (Parent_height // 3),
        pause_screen, button_border,
        "Restart", restart_press
    )

options_btn = button(
        Parent_Width // 2, (Parent_height // 3) + 45,
        pause_screen, button_border,
        "Options", options_press
    )

quit_btn = button(
    Parent_Width // 2, (Parent_height //3) + 90,
    pause_screen, button_border,
    "Quit", quit_press
)
#sprites

def body_unpacker(folder, FFP):

    global snake_scales, snake_head_up, snake_head_down, snake_head_right, snake_head_left, skin_sprited

    paths = asset_selector(snake_sprite_folder, folder, FFP)

    missing_paths = [path for path in paths if not Path(path).is_file()]
    if missing_paths:
        raise FileNotFoundError(
            "Sprite files not found: \n" + "\n".join(missing_paths)
        )
    if len(paths) != 5:
        raise ValueError(f"Invalid folder selected")

    loaded_sprites = []
    for path in paths:
        try:
            image = pygame.image.load(path).convert_alpha()
        except pygame.error as error:
            raise RuntimeError(
                f"Could not load sprite {path!r}: {error}"
            ) from error

        loaded_sprites.append(pygame.transform.smoothscale(image,(cell_size, cell_size)))

    snake_head_up, snake_head_down, snake_head_left, snake_head_right, snake_scales = loaded_sprites
    skin_sprited = True

def body_default():
    global skin_sprited
    if skin_sprited:
        global selected_body, default_body
        selected_body = default_body
        try:
            body_unpacker(selected_body, False)
        except (FileNotFoundError, RuntimeError, ValueError) as error:
            print(f"Could not load the default sprite set: {error}")
            skin_sprited = False
body_default()

def apple_default():
    global default_apple, Apple_def_png, selected_apple 
    if apple_sprited:
        default_apple = "Green Apple 50x50 pxlart.png"
        Apple_def_png = asset_selector(apple_sprite_folder, default_apple)
        selected_apple = pygame.transform.smoothscale((pygame.image.load(Apple_def_png).convert_alpha()), (cell_size, cell_size))
apple_default()

#pygui
def update_Manager():
    global Manager, apple_input, apple_dialog, selected_apple, selected_apple_path, body_input, head_input, body_input_y, head_input_y, is_apple_sprited, is_body_sprited, guts_input, is_guts_sprited
    Manager = pygame_gui.UIManager((options_width, options_height))

    draw_options_title()
    apple_input = pygame_gui.elements.UIButton(
        (30, 0, -1, -1),
        "Choose an apple sprite...",
        Manager,
    )
    apple_input_rect = apple_input.rect
    bin, optsttly = (opts_title_bg_rect.bottomleft)
    apple_input_centery = optsttly + 10 + (cell_size //2)
    apple_input_rect.centery = apple_input_centery
    bin, apple_input_y = apple_input_rect.topleft
    apple_input = pygame_gui.elements.UIButton(
    (30, apple_input_y, -1, -1),
    "Choose a food sprite...",
    Manager,
    )

    is_apple_sprited_height = apple_input.rect.height
    is_apple_sprited_rect = pygame.Rect(0, 0, is_apple_sprited_height, is_apple_sprited_height)
    is_apple_sprited_rect.centerx = 15
    is_apple_sprited_rect.centery = apple_input.rect.centery 
    is_apple_sprited = pygame_gui.elements.UICheckBox(
        (is_apple_sprited_rect),
        "",
        Manager,
        initial_state=True
    )

    body_input_y = (apple_input.rect.centery + ((cell_size // 2) + 20)) 
    body_input = pygame_gui.elements.UIButton(
        (30, body_input_y, -1, -1),
        "Choose a snake sprite set...",
        Manager
    )

    is_body_sprited_height = body_input.rect.height
    is_body_sprited_rect = pygame.Rect(0, 0, is_body_sprited_height, is_body_sprited_height)
    is_body_sprited_rect.centerx = 15
    is_body_sprited_rect.centery = body_input.rect.centery
    is_body_sprited = pygame_gui.elements.UICheckBox(
        (is_body_sprited_rect),
        "",
        Manager,
        initial_state=True
    )

    guts_input_y = body_input.rect.centery + (cell_size // 2) + 20
    guts_input = pygame_gui.elements.UIButton(
        (30, guts_input_y, -1, -1),
        "Pick a body fill color",
        Manager
    )

    is_guts_sprited_height = guts_input.rect.height
    is_guts_sprited_rect = pygame.Rect(0, 0, is_guts_sprited_height, is_guts_sprited_height)
    is_guts_sprited_rect.centerx = 15
    is_guts_sprited_rect.centery = guts_input.rect.centery
    is_guts_sprited = pygame_gui.elements.UICheckBox(
        (is_guts_sprited_rect),
        "",
        Manager,
        initial_state=False
    )
    

update_Manager()

def pygame_gui_event_handler(event_in):

    event = options_translator(event_in)
    Manager.process_events(event)
    
    global apple_dialog, open_dialogue, selected_apple_path, selected_apple, selected_body, apple_sprited, skin_sprited

    if event.type == pygame_gui.UI_BUTTON_PRESSED and event.ui_element == apple_input:
        path = filedialog.askopenfilename(
            parent=file_dialog_root,
            title="Choose a food sprite",
            initialdir=str(
                Path(__file__).resolve().parent
                / "Assets"
                / apple_sprite_folder
            ),
            filetypes=[("PNG images", "*.png")]
        )
        if not path:
            apple_default()
            return
        selected_apple_path = path
        selected_apple = pygame.transform.smoothscale((pygame.image.load(path).convert_alpha()), (cell_size, cell_size))

    if event.type == pygame_gui.UI_BUTTON_PRESSED and event.ui_element == body_input:
        folder_path = filedialog.askdirectory(
            parent=file_dialog_root,
            title="Choose a body sprite folder",
            initialdir=str(
                Path(__file__).resolve().parent
                / "Assets"
                / snake_sprite_folder
            ))
        
        if folder_path:
            try:
                body_unpacker(folder_path, True)
            except (FileNotFoundError, RuntimeError, ValueError) as error:
                print(f"Could not use that sprite set: {error}")
        else:
            pass

    if event.type == pygame_gui.UI_CHECK_BOX_CHECKED and event.ui_element == is_apple_sprited:
        apple_sprited = True
    if event.type == pygame_gui.UI_CHECK_BOX_UNCHECKED and event.ui_element == is_apple_sprited:
        apple_sprited = False
    if event.type == pygame_gui.UI_CHECK_BOX_CHECKED and event.ui_element == is_body_sprited:
        skin_sprited = True
        is_guts_sprited.set_state(False)
    if event.type == pygame_gui.UI_CHECK_BOX_UNCHECKED and event.ui_element == is_body_sprited:
        skin_sprited = False
        is_guts_sprited.set_state(True)


def options_translator(event_in):
    mouse_types = (
        pygame.MOUSEMOTION,
        pygame.MOUSEBUTTONDOWN,
        pygame.MOUSEBUTTONUP,
    )

    if event_in.type not in mouse_types:
        return event_in
    else:
        attributes = event_in.dict.copy()
        attributes["pos"] = (
            event_in.pos[0] - options_x,
            event_in.pos[1] - options_y,
        )
        return pygame.event.Event(event_in.type, attributes)


def click_handler(event):
    if event.type == pygame.MOUSEBUTTONDOWN and not options:
            
        if pause_menu and options_btn.temp_rect.collidepoint(event.pos):
            options_btn.onClickFunction()
        if pause_menu and restart_btn.temp_rect.collidepoint(event.pos):
            restart_btn.onClickFunction()
        if pause_menu and quit_btn.temp_rect.collidepoint(event.pos):
            quit_btn.onClickFunction()
        if start_menu and start_btn.temp_rect.collidepoint(event.pos):
            start_btn.onClickFunction()
        if start_menu and start_options_btn.temp_rect.collidepoint(event.pos):
            start_options_btn.onClickFunction()
        if start_menu and start_quit_btn.temp_rect.collidepoint(event.pos):
            start_quit_btn.onClickFunction()


#Game Loop

run = True
while run:
    dt = clock.tick(FPS) #ms since last tick(frame)
    clear_screen()

#Event Handler    
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            run = False
        elif event.type == pygame.KEYDOWN:
            key = pygame.key.get_pressed()
            if playing:
                if key[move_left_key] and direction != 'R':
                    direction = 'L'
                elif key[move_right_key] and direction != 'L':
                    direction = 'R'
                elif key[move_up_key] and direction != 'D':
                    direction = 'U'
                elif key[move_down_key] and direction != 'U':
                    direction = 'D'
            if event.key == pygame.K_ESCAPE:
                on_esc_pressed()
        elif event.type == pygame.VIDEORESIZE:
            Parent_Width, Parent_height = event.size
            on_resize(Parent_Width, Parent_height)
        elif event.type == pygame.MOUSEBUTTONDOWN:
            click_coords[0], click_coords[1] = event.pos
            click_handler(event) # x, y list
        if options:
            pygame_gui_event_handler(event)
                

#Game window actions
    if playing:
        Slithimer += dt #ms since last slither 

    #Cooking
        while hungry:

            AppInSnake = False
            PotApple[0] = cell_size * (random.randint(0, int((Screen_Width / cell_size) - 1)))
            PotApple[1] = cell_size * (random.randint(0, int((Screen_height / cell_size) - 1)))

            #IsAppleInSnake?
            if any(segment == PotApple for segment in snake_box):
                AppInSnake = True
                mistakes_avoided += 1

            if AppInSnake:
                continue
            else:
                Apple = PotApple
                hungry = False
                break

    #IsFoodEaten?
        if snake_box[0] == Apple:
            hungry = True
            snake_box.append(tail)
            true_cps += cps_inc
            max_cps = true_cps - cps_inc
        
            
#slithering
    if not game_over:
            if Slithimer>= Slithertavel :
                Slithimer -= Slithertavel
                snake_box = snake_box[ -1:] + snake_box[:-1]
                if direction =='U':
                    snake_box[0][0] = snake_box[1][0] 
                    snake_box[0][1] = snake_box[1][1] - cell_size
                if direction == 'L':
                    snake_box[0][0] = snake_box[1][0] - cell_size
                    snake_box[0][1] = snake_box[1][1]
                if direction == 'R':
                    snake_box[0][0] = snake_box[1][0] + cell_size
                    snake_box[0][1] = snake_box[1][1]
                if direction == 'D':
                    snake_box[0][0] = snake_box[1][0]
                    snake_box[0][1] = snake_box[1][1] + cell_size
                tail = list(snake_box[-1])
                game_over, autopsy = is_snake_dead(game_over, autopsy)
   
#drawing
    #Snake
    head = True
    for x in snake_box:
        if not selected_body == None and skin_sprited:
            if not head:
                screen.blit(snake_scales, x)
            if head:
                head = False
                if direction == 'U':
                    screen.blit(snake_head_up, x)
                elif direction == 'D':
                    screen.blit(snake_head_down, x)
                elif direction == 'L':
                    screen.blit(snake_head_left, x)
                elif direction == 'R':
                    screen.blit(snake_head_right, x)
        else:
            if not head: 
                pygame.draw.rect(
                    screen, snake_skin,
                    (x[0], x[1], cell_size, cell_size)
                )
                pygame.draw.rect(
                    screen, snake_guts,
                    (x[0] + 2, x[1] + 2, cell_size - 4, cell_size - 4)
                )
            if head:
                pygame.draw.rect(
                    screen, snake_skin,
                    (x[0], x[1], cell_size, cell_size)
                )
                pygame.draw.rect(
                    screen, snake_head,
                    (x[0] + 2, x[1] + 2, cell_size - 4, cell_size - 4)
                )
                head = False
    #Apple
    if not selected_apple == None and apple_sprited:
        screen.blit(selected_apple, (Apple[0], Apple[1]))
    else:
        pygame.draw.rect(
    screen, Apple_variety,
    (Apple[0], Apple[1], cell_size, cell_size)
    )    
    draw_gameboard()

    if pause_menu:        
        draw_pause()
#options menu
    if options:
        Manager.update(dt / 1000)
        Manager.draw_ui(options_screen)

        if selected_apple is not None:

            ap_but_rect = apple_input.rect
            ap_pre_rect = selected_apple.get_rect()
            ap_pre_rect.centery = ap_but_rect.centery

            ap_pre_rect.centerx = (ap_but_rect.centerx + (ap_but_rect.width)) 
            options_screen.blit(selected_apple, (ap_pre_rect.topleft))
        if selected_body is not None:

            bd_but_rect = body_input.rect
            bd_pre_rect = snake_scales.get_rect()
            bd_pre_rect.centery = bd_but_rect.centery
            if snake_scales is not None:
                bd_pre_rect.centerx = ap_pre_rect.centerx
            else:
                bd_pre_rect.centerx = (bd_but_rect.centerx + bd_but_rect.width)
            options_screen.blit(snake_scales, (bd_pre_rect.topleft))
        draw_options_title()
        draw_options_menu()
    if game_over:
        on_game_over()

    pygame.display.update()

file_dialog_root.destroy()
pygame.quit()

#debug/reporting

print(mistakes_avoided, "","mistakes avoided")
print(game_over, "","= game_over")
print(autopsy, "","= cause of death")
print(max_cps,"", "=max_cps")