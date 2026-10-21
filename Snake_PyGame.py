import pygame
import random
from pathlib import Path
pygame.init()  

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
skin_sprited = False 
apple_sprited = True
apple_sprite_folder = "Apple sprites"
Snake_head_folder = "Snake head sprites"

#controls

move_left_key = pygame.K_a
move_right_key = pygame.K_d
move_down_key = pygame.K_s
move_up_key = pygame.K_w

#cosmetic & stats

screen_bg_col = (0, 0, 0,)
parent_bg_col = (30, 25 ,45)
snake_skin = (255, 255, 255)
snake_guts = (0, 0, 0)
snake_head = (255, 255, 255)
Apple_variety = (51, 204, 51)
mistakes_avoided = 0
autopsy = ''
max_cps = 0

#functions

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

def draw_changes():
    Parent_Window.blit(screen, (Screen_x, Screen_y))
    pygame.display.update()

# if asset type not head, outputs file path.
# if asset type head, outputs list, with filepaths for each directional sprite, ordered UDLR. Requires head sprites to have following path: /Assets/Snake head sprites/[folder name = fileroot]/[Up/Down/Left/Right]

def asset_selector(asset_type, fileroot):
    if asset_type == Snake_head_folder:
        head_paths = [str(Path(__file__).resolve().parent
                        / "Assets"
                        / str(asset_type)
                        / str(fileroot)
                        / "Up"),
                    str(Path(__file__).resolve().parent
                            / "Assets"
                            / str(asset_type)
                            / str(fileroot)
                            / "Down"),
                    str(Path(__file__).resolve().parent
                            / "Assets"
                            / str(asset_type)
                            / str(fileroot)
                            / "Left"), 
                    str(Path(__file__).resolve().parent
                            / "Assets"
                            / str(asset_type)
                            / str(fileroot)
                            / "Right"), 
                        ]
        return head_paths
    else:
        abs_path = str(Path(__file__).resolve().parent
            / "Assets"
            / str(asset_type)
            / str(fileroot)
            )
        return abs_path

#sprites

if skin_sprited:
    snake_scales_png = 'temp.png'
    snake_head_up_png = 'temp.png'
    snake_head_down_png = 'temp.png'
    snake_head_right_png = 'temp.png'
    snake_head_left_png = 'temp.png'
    snake_scales = pygame.transform.smoothscale((pygame.image.load(snake_scales_png).convert_alpha()), (cell_size, cell_size))
    snake_head_up = pygame.transform.smoothscale((pygame.image.load(snake_head_up_png).convert_alpha()), (cell_size, cell_size))
    snake_head_down = pygame.transform.smoothscale((pygame.image.load(snake_head_down_png).convert_alpha()), (cell_size, cell_size))
    snake_head_right = pygame.transform.smoothscale((pygame.image.load(snake_head_right_png).convert_alpha()), (cell_size, cell_size))
    snake_head_left = pygame.transform.smoothscale((pygame.image.load(snake_head_left_png).convert_alpha()), (cell_size, cell_size))

if apple_sprited:
    Apple_selected = "Green Apple 50x50 pxlart.png"
    Apple_spr_png = asset_selector(apple_sprite_folder, Apple_selected)
    Apple_spr = pygame.transform.smoothscale((pygame.image.load(Apple_spr_png).convert_alpha()), (cell_size, cell_size))

#snake
snake_box = [[int(Screen_Width / 2), int(Screen_height / 2)]]
snake_box.append([int(Screen_Width / 2), int((Screen_height / 2) + cell_size)])
snake_box.append([int(Screen_Width / 2), int((Screen_height / 2) + (cell_size * 2))])


#Game Loop

run = True
while run:

    clear_screen()

#Event Handler    
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            run = False
        elif event.type == pygame.KEYDOWN:
            key = pygame.key.get_pressed()
            if key[move_left_key] and direction != 'R':
                direction = 'L'
            elif key[move_right_key] and direction != 'L':
                direction = 'R'
            elif key[move_up_key] and direction != 'D':
                direction = 'U'
            elif key[move_down_key] and direction != 'U':
                direction = 'D'
        elif event.type == pygame.VIDEORESIZE:
            Parent_Width, Parent_height = event.size
            Parent_Window = pygame.display.set_mode(event.size, pygame.RESIZABLE)
            Screen_x = (Parent_Width - Screen_Width) // 2
            Screen_y = (Parent_height - Screen_height) // 2

#Game window actions
    if playing:
        dt = clock.tick(FPS) #ms since last tick(frame)
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
        if apple_sprited:
            screen.blit(Apple_spr, (Apple[0], Apple[1]))
        pygame.draw.rect(
    screen, Apple_variety,
    (Apple[0], Apple[1], cell_size, cell_size)
    )    

    draw_changes()

pygame.quit()

#debug/reporting

print(mistakes_avoided, "","mistakes avoided")
print(game_over, "","= game_over")
print(autopsy, "","= cause of death")
print(max_cps,"", "=max_cps")