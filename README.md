# Space Shooter Game

A classic space shooter game built using the Processing framework. The player controls a spaceship to shoot down enemies while avoiding obstacles. The game tracks the score and high score, with the added feature of flashing milestones when the score reaches certain multiples of 10.

## Features

- **Spaceship Controls**: Move the spaceship left and right using arrow keys and shoot lasers with the spacebar or 'S' key.
- **Enemy Spawning**: Enemies spawn randomly at the top and move down the screen.
- **Milestone Messages**: Flashing milestone messages are displayed every time the score reaches multiples of 10 (e.g., "Newbie" at 10, "Rampage" at 40, etc.).
- **Background Music**: Looping background music plays throughout the game.
- **Sound Effects**: Sound effects for shooting and background music.
- **High Score Tracking**: High score is saved and loaded from a file (`highscore.txt`).
- **Game Over Screen**: When the player loses, a game over screen is shown, and the player can press 'R' to restart.

## Requirements

- [Processing](https://processing.org/) (version 3.5+)
- A working internet connection for downloading assets (such as the spaceship image, enemy image, sound effects, etc.).

## How to Run

1. Download and install [Processing IDE](https://processing.org/download/).
2. Clone or download this repository to your local machine.
3. Open the project folder in the Processing IDE.
4. Press the **Run** button in the Processing IDE to start the game.

## Game Controls

- **Left Arrow**: Move the spaceship left.
- **Right Arrow**: Move the spaceship right.
- **Spacebar / 'S' key**: Shoot lasers.
- **'R' key**: Restart the game after game over.

## Files

- **`space_shooter.pde`**: Main game code.
- **`ship.png`**: Spaceship image.
- **`enemy.png`**: Enemy image.
- **`laser.mp3`**: Laser shooting sound effect.
- **`background_music.mp3`**: Background music.
- **`highscore.txt`**: File for storing the high score.


## Credits

- **[Processing](https://processing.org/)** for providing the framework.
- **[FreeSound](https://freesound.org/)** for background music and sound effects.
- The images used for the spaceship and enemy are custom created or downloaded from free resources.

