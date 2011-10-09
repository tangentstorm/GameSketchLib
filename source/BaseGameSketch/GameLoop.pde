

void draw()
{
    Game.state.update();
    Game.state.render();
}

void mousePressed()  { Game.state.mousePressed();  }
void mouseReleased() { Game.state.mouseReleased(); }
void mouseMoved()    { Game.state.mouseMoved();    }
void keyPressed()    { Game.state.keyPressed();    }
void keyReleased()   { Game.state.keyReleased();   }

