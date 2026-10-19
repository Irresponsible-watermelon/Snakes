import pygame

pygame.init()

# Game Window

Screen_Width = 800
Screen_height = 600

screen = pygame.display.set_mode((Screen_Width, Screen_height))

player = pygame.Rect((300, 300, 20, 20))

#Game Loop

run = True
while run:

    move_left_key = pygame.K_a
    move_right_key = pygame.K_d
    move_down_key = pygame.K_s
    move_up_key = pygame.K_w

    key = pygame.key.get_pressed()
    if key[move_left_key]:
        player.move_ip(-1,0)
    elif key[move_right_key]:
        player.move_ip(1,0)
    elif key[move_up_key]:
        player.move_ip(0,-1)
    elif key[move_down_key]:
        player.move_ip(0,1)
            

    #Event Handler
    pygame.draw.rect(screen,(109, 56, 111),player)
    
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            run = False

    pygame.display.update()
pygame.quit()