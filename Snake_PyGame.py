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
#actually very important for things to work

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
Snake_head_folder = "Snake head sprites"
body_sprite_folder = "Snake body sprites"
font_folder = "opendyslexic-0.92"
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

options_screen = pygame.Surface((options_width, options_height))

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


#functions

# High level functions
def clear_screen():
    Parent_Window.fill(parent_bg_col)
    screen.fill(screen_bg_col)

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
    options_btn.y = Parent_height // 3
    options_btn.button_surface = pause_screen
    #update pygame
    update_Manager()
def asset_selector(asset_subfolder, fileroot):
    if asset_subfolder == Snake_head_folder:
        head_paths = [str(Path(__file__).resolve().parent
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
                        ]
        return head_paths
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
    options_btn.draw()
    Parent_Window.blit(pause_screen, (0,0))

# options
         
def options_press():
    global options
    if options == False:
        options = True
    else:
        options = False

def draw_options_menu():
    Parent_Window.blit(options_screen, (options_x, options_y))

# Variables reliant on functions

button_font = pygame.freetype.Font(asset_selector(font_folder,"OpenDyslexic-Regular.otf"), 6)

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

    def draw(self):
        font_rect = button_font.get_rect(self.ButtonText)
        self.width = font_rect.width + self.padding_x
        self.height = font_rect.height + self.padding_y
        self.temp_rect = pygame.Rect(0, 0, self.width, self.height)
        self.temp_rect.center = (self.x, self.y)
        temp_surface = pygame.Surface(self.temp_rect.size)
        pygame.draw.rect(temp_surface, self.border_col,(0, 0, self.width, self.height,), 0, 1)
        pygame.draw.rect(temp_surface,self.bg_col,(0 + 2, 0 + 2, self.width - 4, self.height- 4,), 0, 1)
        text_box = button_font.get_rect(self.ButtonText)
        text_box.center = (temp_surface.get_rect().center)
        button_font.render_to(
            temp_surface,
            text_box,
            self.ButtonText,
            fgcolor= self.txt_col
        )
        
        self.button_surface.blit(temp_surface, self.temp_rect.topleft)

#Buttons
options_btn = button(
        Parent_Width // 2, Parent_height // 3,
        pause_screen, button_border,
        "Options", options_press
    )

#sprites

if skin_sprited:
    snake_head_root = 'My_Snake_1_heads'
    body_sprite = 'My Snake 1 Body.png'
    snake_scales_png = asset_selector(body_sprite_folder, body_sprite)
    snake_head_up_png = (asset_selector(Snake_head_folder,snake_head_root)[0])
    snake_head_down_png = (asset_selector(Snake_head_folder,snake_head_root)[1])
    snake_head_left_png = (asset_selector(Snake_head_folder,snake_head_root)[2])
    snake_head_right_png = (asset_selector(Snake_head_folder,snake_head_root)[3])
    snake_scales = pygame.transform.smoothscale((pygame.image.load(snake_scales_png).convert_alpha()), (cell_size, cell_size))
    snake_head_up = pygame.transform.smoothscale((pygame.image.load(snake_head_up_png).convert_alpha()), (cell_size, cell_size))
    snake_head_down = pygame.transform.smoothscale((pygame.image.load(snake_head_down_png).convert_alpha()), (cell_size, cell_size))
    snake_head_right = pygame.transform.smoothscale((pygame.image.load(snake_head_right_png).convert_alpha()), (cell_size, cell_size))
    snake_head_left = pygame.transform.smoothscale((pygame.image.load(snake_head_left_png).convert_alpha()), (cell_size, cell_size))

if apple_sprited:
    default_apple = "Green Apple 50x50 pxlart.png"
    Apple_def_png = asset_selector(apple_sprite_folder, default_apple)
    selected_apple = pygame.transform.smoothscale((pygame.image.load(Apple_def_png).convert_alpha()), (cell_size, cell_size))

#snake
snake_box = [[int(Screen_Width / 2), int(Screen_height / 2)]]
snake_box.append([int(Screen_Width / 2), int((Screen_height / 2) + cell_size)])
snake_box.append([int(Screen_Width / 2), int((Screen_height / 2) + (cell_size * 2))])

#pygui
def update_Manager():
    global Manager, apple_input, apple_dialog, selected_apple, selected_apple_path, body_input, head_input, body_input_y, head_input_y
    Manager = pygame_gui.UIManager((options_width, options_height))

    apple_input = pygame_gui.elements.UIButton(
        (30, 30, -1, -1),
        "Choose an apple sprite...",
        Manager,
    )
    body_input_y = (apple_input.rect.centery + ((cell_size // 2) + 10)) 
    body_input = pygame_gui.elements.UIButton(
        (30, body_input_y, -1, -1),
        "Choose a body sprite...",
        Manager
    )
    head_input_y = (body_input.rect.centery + ((cell_size // 2) + 10))
    head_input = pygame_gui.elements.UIButton(
        (30, head_input_y, -1, -1),
        "Choose a head sprite set...",
        Manager
    )
update_Manager()

def pygame_gui_event_handler(event_in):

    event = options_translator(event_in)
    Manager.process_events(event)
    
    global apple_dialog, open_dialogue, selected_apple_path, selected_apple, selected_body_path, selected_body

    if event.type == pygame_gui.UI_BUTTON_PRESSED and event.ui_element == apple_input:
        path = filedialog.askopenfilename(
            parent=file_dialog_root,
            title="Choose an apple sprite",
            initialdir=str(
                Path(__file__).resolve().parent
                / "Assets"
                / apple_sprite_folder
            ),
            filetypes=[("PNG images", "*.png")]
        )
        if not path:
            return
        selected_apple_path = path
        selected_apple = pygame.transform.smoothscale((pygame.image.load(path).convert_alpha()), (cell_size, cell_size))

    if event.type == pygame_gui.UI_BUTTON_PRESSED and event.ui_element == body_input:
        path = filedialog.askopenfilename(
            parent=file_dialog_root,
            title="Choose a body sprite",
            initialdir=str(
                Path(__file__).resolve().parent
                / "Assets"
                / body_sprite_folder
            ),
            filetypes=[("PNG images", "*.png")]
        )
        if not path:
            return
        selected_body_path = path
        selected_body = pygame.transform.smoothscale((pygame.image.load(path).convert_alpha()), (cell_size, cell_size))


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
        if skin_sprited:
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
    if not selected_apple == None:
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
            pass
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