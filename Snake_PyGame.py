import pygame

pygame.init()

# Game Window

Screen_Width = 600
Screen_height = 600

screen = pygame.display.set_mode((Screen_Width, Screen_height))
pygame.display.set_caption('PyGame Snake')

#variables

cell_size = 50 
direction = 'U' # UDLR, Up Down Left Right
update_snake = 0
loop_cap = 999

bg_col = (0, 0, 0,)
snake_skin = (255, 255, 255)
snake_guts = (0, 0, 0)
snake_head = (255, 255, 255)


#snake
snake_box = [[int(Screen_Width / 2), int(Screen_height / 2)]]
snake_box.append([int(Screen_Width / 2), int((Screen_height / 2) + cell_size)])
snake_box.append([int(Screen_Width / 2), int((Screen_height / 2) + (cell_size * 2))])

#functions

def draw_screen():
    screen.fill(bg_col)
    

#Game Loop

run = True
while run:

    draw_screen()

    move_left_key = pygame.K_a
    move_right_key = pygame.K_d
    move_down_key = pygame.K_s
    move_up_key = pygame.K_w

    #Event Handler

    #key = pygame.key.get_pressed()
    #if key[move_left_key]:
    #    player.move_ip(-1,0)
    #elif key[move_right_key]:
    #    player.move_ip(1,0)
    #elif key[move_up_key]:
    #    player.move_ip(0,-1)
    #elif key[move_down_key]:
    #    player.move_ip(0,1)
            
    
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

#snake drawing
    if update_snake > loop_cap:
        update_snake = 0
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

    head = 1
    for x in snake_box:
        if (head == 0): 
            pygame.draw.rect(
                screen, snake_skin,
                (x[0], x[1], cell_size, cell_size)
            )
            pygame.draw.rect(
                screen, snake_guts,
                (x[0] + 2, x[1] + 2, cell_size - 4, cell_size - 4)
            )
        if (head == 1):
            pygame.draw.rect(
                screen, snake_skin,
                (x[0], x[1], cell_size, cell_size)
            )
            pygame.draw.rect(
                screen, snake_head,
                (x[0] + 2, x[1] + 2, cell_size - 4, cell_size - 4)
            )
            head = 0



    pygame.display.update()
    update_snake += 1
pygame.quit()