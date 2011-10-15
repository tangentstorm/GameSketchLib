/* @pjs preload="/static/uploaded_resources/p.1181/invaders.png"; */
/*
 * InvaderSketch!
 *     by Michal J Wallace
 *     twitter: @tangentstorm
 *
 * Live demo at studio.sketchpad.cc:
 *
 *     http://studio.sketchpad.cc/sp/pad/view/ro.9bi5HFOFBWaAa/latest
 * 
 * Created with GameSketchLib, an open-source game engine for processing.
 *
 *     http://gamesketchlib.org/
 *
 * Video lessons about this game:
 *
 *     http://www.youtube.com/playlist?list=PL9164D8831A48D0DE&feature=viewall
 *
 * This game was inspired by the legendary arcade classic,
 * "Space Invaders" by Tomohiro Nishikado (Taito, 1978)
 *
 *     http://en.wikipedia.org/wiki/Space_Invaders
 *
 */

String PJS_URL = "/static/uploaded_resources/p.1181";

void setup()
{
    DEBUG = true;
    
    SHEET = new GameSheet("invaders.png", 50, 50, PJS_URL);
    
    Game.size(640, 480);
    Game.init(DEBUG ? new PlayState()
                    : new MenuState());
}


class CrazyText extends GameText
{
    CrazyText(String label, float x, float y, color c, int fontSize)
    {
        super(label, x, y, c, fontSize);
    }
    
    private GameTimer mCrazyTimer = new GameTimer(SECONDS/10);
    public void render()
    {
       if (mCrazyTimer.checkReady()) 
           this.textColor = color(127 + random(127), 127 + random(127), 127 + random(127));
       super.render();               
    }
}


class MenuState extends GameState
{
   GameLink mLink;
   
   void create()
   {
       add(new CrazyText("InvaderSketch!", Game.bounds.w /2, 100, #FFFFFF, 48));
       add(new GameText("Part of the GameSketchLib Tutorial Series",
                        Game.bounds.w /2, 150, #CCCCCC, 12));
   
       mLink = (GameLink) add(new GameLink(
              "www.GameSketchLib.org",
              "http://gamesketchlib.org",
              Game.bounds.w /2, 200, #9999FF, 18));
              
       add(new GameText("Use the Arrow Keys to Move, Space to Shoot",
                        Game.bounds.w / 2, 300, #FFFFFF, 18));
                        
       add(new GameText("Press Space to Start",
                        Game.bounds.w / 2, 360, #CCCCCC, 18));
   }
   
   void update()
   {
       if (Game.keys.justPressed(SPACE))
       {
           Game.switchState(new PlayState());
       }
   }
   
   void mouseMoved()
   {
       mLink.hover = mLink.bounds.containsPoint(mouseX, mouseY);
       cursor( mLink.hover ? HAND : ARROW );
   }
   
   void mousePressed()
   {
       if (mLink.hover) mLink.click();
   }
   
}


class GameOverState extends GameState
{
   void create()
   {
       add(new GameText("Game Over!",
                        Game.bounds.w /2, 100, #FFFFFF, 18));
                        
       add(new GameText("Press space to Restart",
                        Game.bounds.w / 2, 150, #CCCCCC, 12));
   }
   
   void update()
   {
       if (Game.keys.justPressed(SPACE))
       {
           Game.switchState(new MenuState());
       }
   }
}



class WinState extends GameOverState
{
   void create()
   {
       add(new GameText("You Won!",
                        Game.bounds.w /2, 100, #FFFFFF, 18));
                        
       add(new GameText("Press space to Restart",
                        Game.bounds.w / 2, 150, #CCCCCC, 12));
   }
}


//== PlayState ========================================================

class PlayState extends GameState
{
  
    GameGroup mInvaders = new GameGroup();
    GameGroup mShipInvaders = new GameGroup();
    GameGroup mHeroBullets = new GameGroup();
    GameGroup mEnemyBullets = new GameGroup();
    GameGroup mShields = new GameGroup();
    
    // There's no GameGroup.overlap(GameSprite) yet:
    GameGroup mHeroGroup = new GameGroup();
    HeroSprite mHero;
    final float kHeroSpeed = 3.5;
    final int kBulletCount = 3;
    final float kBulletSpeed = -1.75;
    int mBulletsLeft = kBulletCount;
    int kBulletW = 10;
    int kBulletH = 50;
    
    void create()
    {
      
       // create the hero and put him in his group       
       mHero = new HeroSprite(Game.bounds.w/2 - 25, Game.bounds.h - 50);
       mHeroGroup.add(mHero);
       
       // our bullets and fixed ammo display from BulletDemo
       createHeroBullets();

       // generate the enemies:
       int row = 0;
       for (int y = 25; y < Game.bounds.h - 100; y += 75, row++)
       {
         for (int x = 65; x < Game.bounds.w - 50; x += 75)
         {
             switch(row)
             {
               case 0:
                 mInvaders.add(mShipInvaders.add(new ShipInvader(x, y)));
                 break;
               case 1:
               case 3:
                 mInvaders.add(new SpinInvader(x, y));
                 break;
               case 2:
                 mInvaders.add(new JellInvader(x, y));
                 break;
               default:
                 // only do 4 rows
             }
         }
       }
       
       // create the shields:
       int[] shieldXs = new int[] { 50, 100, 150, 250, 300, 350, 450, 500, 550 };
       for (int i = 0; i < shieldXs.length; ++i)
       {
           mShields.add(new Shield(shieldXs[i], Game.bounds.h - 125));
       }
       
       
       // add the groups to the state:
       // add the bullets first so they appear behind when shooting
       add(mHeroBullets);
       add(mEnemyBullets);
       add(mHeroGroup);
       add(mShields);
       add(mInvaders);
    }
    
    void createHeroBullets()
    {  
        for (int i = 0; i < kBulletCount; ++i)
        {
            Bullet b = (Bullet) mHeroBullets.add(new Bullet(0,0));
            b.dy = kBulletSpeed;
        }
    }
    
    
    void update()
    {
        super.update();
        
        if (Game.keys.justPressed(SPACE)) { shoot(); }
        if (Game.keys.goW()) { mHero.x -= kHeroSpeed; }
        if (Game.keys.goE()) { mHero.x += kHeroSpeed; }
        mHero.x = GameMath.clamp(mHero.x, 0, Game.bounds.w - mHero.w);
        
        if (Game.keys.justPressed('r'))
        {
            GameSprite g = (GameSprite) mShipInvaders.atRandom();
            g.degrees = (int) random(360);
        }
        
        updateHeroBullets();
        updateInvaders();
        enemyFire();
        updateShields();
        
        // checkForWin:    
        if (mInvaders.firstAlive() == null) { Game.switchState(new WinState()); }
    }
    
    void shoot()
    {
        if (mBulletsLeft > 0)
        {
            mBulletsLeft--;
            Bullet b = (Bullet) mHeroBullets.firstDead();
            b.fire(mHero.x, mHero.y);
        }
    }
    
    void updateHeroBullets()
    {
         mHeroBullets.overlap(mInvaders);
         mHeroBullets.overlap(mShields);
         
         int bulletsLeft = 0;
         for (int i = 0; i < kBulletCount; ++i)
         {
             Bullet b = (Bullet) mHeroBullets.get(i);
             b.update();
             if (! b.overlaps(Game.bounds)) b.alive = false;
             if (! b.alive)
             {
                 b.x = kBulletW * bulletsLeft++;
                 b.y = Game.bounds.h - kBulletH;
             }
         }
         mBulletsLeft = bulletsLeft;
    }
    
    
    GameTimer mShiftTimer = new GameTimer(0.1 * SECONDS);
    int mShiftCount = 0;
    int mDriftX = 0;
    int mFleetSpeedX = 2;  // pixels per tick
    int mFleetSpeedY = 10; // pixels every time they switch x directions
    void updateInvaders()
    {
         mInvaders.removeDead();
         mShipInvaders.removeDead();
         
         // left and right shift:
         mShiftTimer.update();
         if (mShiftTimer.ready)
         {
             // move the whole fleet left or right:
             for (int i = 0; i < mInvaders.size(); ++i)
             {
                 GameSprite g = (GameSprite) mInvaders.get(i);
                 g.x += mFleetSpeedX;
             }
             mDriftX += mFleetSpeedX;
             
             // when they hit the edge...
             if (mDriftX > 50 || mDriftX < -50)
             {
                 // turn around:
                 mFleetSpeedX *= -1;
                 
                 // and move down:
                 for (int i = 0; i < mInvaders.size(); ++i)
                 {
                     GameSprite g = (GameSprite) mInvaders.get(i);
                     g.y += mFleetSpeedY;
                     
                     // game over if one gets within 100px of the bottom
                     if (g.y >= Game.bounds.h - g.h * 2) Game.switchState(new GameOverState());
                 }
             }
         }
    }
    
    
    GameTimer mEnemyShotTimer = new GameTimer(4 * SECONDS, true);
    void enemyFire()
    {
         mEnemyBullets.removeDead();
         mEnemyBullets.overlap(mHeroGroup);
         mEnemyBullets.overlap(mShields);

        // only the orange ships at the top shoot
        if (mShipInvaders.size() == 0) return;
        
        if (mEnemyShotTimer.checkReady())
        {
            // randomize the time between shots:
            mEnemyShotTimer.randomize();
            
            // wait a bit to start shooting:
            if (mEnemyShotTimer.tickCount == 1) return;
            
            // pretty much the same as shoot()
            ShipInvader aShip = (ShipInvader) mShipInvaders.atRandom();
            EnemyBullet b = new EnemyBullet(aShip.x, aShip.y);
            b.dy = -kBulletSpeed;
            mEnemyBullets.add(b);
        }        
    }
    
    void updateShields()
    {
        mShields.removeDead();
    }
    
}


class ShipInvader extends GameSprite
{
    ShipInvader(int x, int y)
    {
        super(x, y);
        sheetFrames(new int[] { 1 });
    }    
}



class SpinInvader extends GameSprite
{
    float angleDelta = 2.5;
    
    SpinInvader(int x, int y)
    {
        super(x, y);
        sheetFrames(new int[] { 2, 3 });
        randomize();
        this.degrees = (int) random(-60, 60);
    }
    
    void update()
    {
        super.update();
        
        this.degrees += angleDelta;
        if (this.degrees > 60 || this.degrees < -60)
        {
          angleDelta *= -1;
        }
        
    }
} 

class JellInvader extends GameSprite
{
    float yDrift = 0;
    
    JellInvader(int x, int y)
    {
        super(x, y);
        sheetFrames(new int[] { 8, 9, 10, 11 });
        randomize();
        this.dy = 1;
        this.yDrift = random(-10, 10);
        this.y += yDrift;
    }
    
    void update()
    {
        super.update();
        this.y += dy;
        this.yDrift += dy;
        if (this.yDrift > 10 || this.yDrift < -10)
        {
            this.dy *= -1;
        }
    }
}

class Shield extends GameSprite
{

    Shield(float x, float y)
    {
        super(x, y);
        sheetFrames(new int[] { 12, 13, 14  });
        this.animated = false;
        this.health = 3;
    }
    
    void hurt()
    {
        super.hurt();
        if (alive) frame++; 
    }
}

class HeroSprite extends GameSprite
{
    HeroSprite(float x, float y)
    {
       super(x, y);
       sheetFrames(new int[] { 0 });
    }
    
    void onDeath()
    {
        Game.switchState(new GameOverState());
    }
}


 class Bullet extends GameSprite
 {
     GameObject trueBounds = new GameObject();

     Bullet(float x, float y)
     {
         super(x, y);
         sheetFrames(new int[] { 4 });
         alive = false;
     }
  

     void update()
     {
         if (this.alive)
         {
             y += dy;
             x += dx;
         }
         this.trueBounds.reset(x + 20, y + 20, 10, 15);
         if (! this.trueBounds.overlaps(Game.bounds))
         {
             this.alive = false;
         }
     }

     void fire(float x, float y)
     {
         this.x = x;
         this.y = y;
         this.alive = true;
     }

     boolean overlaps(GameObject other)
     {
         return this.trueBounds.overlaps(other);
     }
     
     void onOverlap(GameObject other)
     {
         this.alive = false;
         other.hurt();
     }
 }

class EnemyBullet extends Bullet
{
     EnemyBullet(float x, float y)
     {
         super(x, y);
         sheetFrames(new int[] { 5 });
         alive = true;
     }
}
