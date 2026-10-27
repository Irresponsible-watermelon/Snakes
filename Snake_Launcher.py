import tkinter as tk
from tkinter import ttk
from pathlib import Path
import subprocess
import sys
from tkinter import messagebox

def launch_snakePy():
    if getattr(sys, "frozen", False):
        app_dir = Path(Path(sys.executable).parent
                       / "Snake_Game(Pygame)")
    else:
        app_dir = Path(__file__).parent / "dist"

    game_path = app_dir / "Snake_Game.exe"

    if not game_path.is_file():
        messagebox.showerror("Game not found", f"Could not find:\n{game_path}")
        return

    subprocess.Popen([str(game_path)], cwd=app_dir)

window = tk.Tk()
window.title("Snake Lab Launcher")
window.geometry("400x250")

heading = ttk.Label(
    window,
    text="Snake Lab",
    font=("Arial", 20, "bold")
)
heading.pack(pady=20)

message = ttk.Label(window, text="Choose a game to play")
message.pack(pady=10)

PyGame_button = ttk.Button(
    window,
    text="Launch Snake - PyGame Edition",
    command=launch_snakePy
    
)
PyGame_button.pack(pady=10)

Godot_button = ttk.Button(
    window,
    text="Launch Snake - Godot Edition"
)
Godot_button.pack(pady=10)


window.mainloop()
