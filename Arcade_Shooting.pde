import processing.sound.*;

SoundFile shootSound;
SoundFile file;

int score = 0;
int highScore = 0;
ArrayList<Bullet> bullets;
ArrayList<Enemy> enemies;
Spaceship ship;

PImage spaceshipImage;
PImage enemyImage;

float[] starX = new float[100];
float[] starY = new float[100];
float[] starSpeed = new float[100];

boolean flashing = false;
int flashCount = 0;
int flashDelay = 200;
int lastFlashTime = 0;
int lastScoreMilestone = 0;
String milestoneMessage = "";
int milestoneMessageTime = 0;

boolean moveLeft = false;
boolean moveRight = false;
boolean shooting = false;
boolean gameOver = false;

void setup() {
  size(600, 400);
  frameRate(60);

  spaceshipImage = loadImage("ship.png");
  enemyImage = loadImage("enemy.png");

  shootSound = new SoundFile(this, "laser.mp3");
  file = new SoundFile(this, "background_music.mp3");
  file.loop();
  file.amp(0.05);

  loadHighScore();

  ship = new Spaceship(width / 2, height - 40);
  bullets = new ArrayList<Bullet>();
  enemies = new ArrayList<Enemy>();

  for (int i = 0; i < starX.length; i++) {
    starX[i] = random(width);
    starY[i] = random(height);
    starSpeed[i] = random(1, 3);
  }
}

void draw() {
  if (flashing) {
    int currentTime = millis();
    if (currentTime - lastFlashTime >= flashDelay) {
      flashCount++;
      lastFlashTime = currentTime;

      if (flashCount % 2 == 0) {
        background(0);
      } else {
        background(255, 255, 0);
      }

      if (flashCount >= 6) {
        flashing = false;
      }
    }
  } else {
    background(0);
  }

  drawStarsWithGlow();

  if (gameOver) {
    displayGameOverScreen();
    return;
  }

  ship.update();
  ship.display();

  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();

    if (b.offScreen()) {
      bullets.remove(i);
    } else {
      for (int j = enemies.size() - 1; j >= 0; j--) {
        Enemy e = enemies.get(j);
        if (b.hits(e)) {
          bullets.remove(i);
          enemies.remove(j);
          score++;
          break;
        }
      }
    }
  }

  if (frameCount % 60 == 0) {
    float spawnX = random(5 + enemyImage.width / 2, width - 5 - enemyImage.width / 2);
    enemies.add(new Enemy(spawnX, 0));
  }

  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
    e.display();

    if (e.y > height) {
      endGame();
    }
  }

  if (!gameOver) {
    displayScore();
  }

  if (score >= 10 * (lastScoreMilestone + 1)) {
    lastScoreMilestone = score / 10;
    flashing = true;
    flashCount = 0;
    lastFlashTime = millis();
    milestoneMessage = getMilestoneMessage(lastScoreMilestone);
    milestoneMessageTime = millis();
  }

  if (!milestoneMessage.isEmpty() && millis() - milestoneMessageTime < 1000) {
    displayMilestoneMessage(milestoneMessage);
  }
}

void drawStarsWithGlow() {
  noStroke();
  blendMode(ADD);

  for (int i = 0; i < starX.length; i++) {
    float size = random(1, 3);
    float alpha = random(60, 120);

    fill(255, 255, 100, alpha);
    ellipse(starX[i], starY[i], size * 2, size * 2);

    fill(255, 255, 255, 255);
    ellipse(starX[i], starY[i], size, size);

    starY[i] += starSpeed[i];
    if (starY[i] > height) {
      starY[i] = 0;
      starX[i] = random(width);
    }
  }

  blendMode(BLEND);
}

class Spaceship {
  float x, y;
  float w = 64, h = 64;
  float speed = 8;

  Spaceship(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    if (moveLeft) {
      x -= speed;
    }
    if (moveRight) {
      x += speed;
    }

    x = constrain(x, w / 2, width - w / 2);

    if (shooting) {
      shoot();
      shooting = false;
    }
  }

  void display() {
    image(spaceshipImage, x - w / 2, y - h / 2, w, h);
  }

  void shoot() {
    bullets.add(new Bullet(x, y - 20));
    shootSound.play();
  }
}

class Bullet {
  float x, y;
  float w = 5, h = 10;

  Bullet(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void update() {
    y -= 10;
  }

  void display() {
    fill(255, 255, 0);
    noStroke();
    rect(x - w / 2, y, w, h);
  }

  boolean offScreen() {
    return y < 0;
  }

  boolean hits(Enemy e) {
    return (x > e.x - e.w / 2 && x < e.x + e.w / 2 && y > e.y - e.h / 2 && y < e.y + e.h / 2);
  }
}

class Enemy {
  float x, y;
  float w = 50, h = 50;
  PImage enemyImg;

  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
    enemyImg = enemyImage;
  }

  void update() {
    y += 2;
  }

  void display() {
    image(enemyImg, x - w / 2, y - h / 2, w, h);
  }
}

void keyPressed() {
  if (keyCode == LEFT) {
    moveLeft = true;
  }
  if (keyCode == RIGHT) {
    moveRight = true;
  }
  if (key == ' ' || key == 's' || key == 'S') {
    shooting = true;
  }
  if (key == 'r' || key == 'R') {
    if (gameOver) {
      restartGame();
    }
  }
}

void keyReleased() {
  if (keyCode == LEFT) {
    moveLeft = false;
  }
  if (keyCode == RIGHT) {
    moveRight = false;
  }
}

void endGame() {
  if (score > highScore) {
    highScore = score;
    saveHighScore();
  }
  gameOver = true;
}

void displayGameOverScreen() {
  fill(255, 0, 0);
  textSize(62);
  textAlign(CENTER, CENTER);
  text("GAME OVER", width / 2, height / 2 - 20);
  textSize(32);
  text("Press 'R' to Restart", width / 2, height / 2 + 20);
}

void displayScore() {
  textAlign(LEFT, TOP);
  fill(255);
  textSize(18);
  text("Score: " + score, 10, 20);

  textAlign(RIGHT, TOP);
  text("High Score: " + highScore, width - 10, 20);
}

void restartGame() {
  score = 0;
  enemies.clear();
  bullets.clear();
  ship = new Spaceship(width / 2, height - 40);
  gameOver = false;
}

void loadHighScore() {
  String[] lines = loadStrings("highscore.txt");
  if (lines != null && lines.length > 0) {
    highScore = int(lines[0]);
  }
}

void saveHighScore() {
  saveStrings("highscore.txt", new String[]{str(highScore)});
}

String getMilestoneMessage(int milestone) {
  switch (milestone) {
    case 1: return "Newbie";
    case 2: return "Keep Going";
    case 3: return "Killing spree";
    case 4: return "Rampage";
    case 5: return "Unstoppable";
    case 6: return "Dominating";
    case 7: return "Godlike";
    default: return "Legendary";
  }
}

void displayMilestoneMessage(String message) {
  fill(255, 0, 0);
  textSize(36);
  textAlign(CENTER, CENTER);
  text(message, width / 2, height / 2);
}
