static enum Alchemical { NONE
                       , GOLD        // Sol
                       , COPPER      // Venus
                       , IRON        // Mars
                       , QUICKSILVER // Mercury
                       , MAGNESIUM
                       , SILVER      // Luna
                       };

final float ANGLE       = TWO_PI/(float)360;
final float DIAM        = 75;
final color COPPER_WIRE = #DA8A67;

class Symbol {
    final Alchemical metal;
    final int x, y;
    int coil;

  Symbol(int x, int y, Alchemical metal) {
    this.x     = x;
    this.y     = y;
    this.metal = metal;
    this.coil  = 1;
  }

    Symbol(int x, int y) {
        this.x     = x;
        this.y     = y;
        this.metal = Alchemical.values()[(int)random(6)];
        this.coil  = 1;
    }

  float xpos(float i, float n) { return n * sin(ANGLE * i) + x; }
  float ypos(float i, float n) { return n * cos(ANGLE * i) + y; }

  void draw(int n) {
    fill(255);
    stroke(0);
    strokeWeight(10);
    ellipseMode(CENTER);
    ellipse( x, y, DIAM, DIAM );
    switch (this.metal) {
      case GOLD: fill(0);
                 strokeWeight(0);
                 ellipse( x, y, 25, 25 );
                 break;
      case COPPER: strokeCap(SQUARE);
                   // line bit
                   line( x
                       , y + DIAM/2
                       , x
                       , y + DIAM/2 + 35 );
                   // cross bit
                   line( x - 15
                       , y + DIAM/2 + (35/2)
                       , x + 15
                       , y + DIAM/2 + (35/2) );
                   break;
      case QUICKSILVER: noFill();
                        strokeCap(SQUARE);
                        // line bit
                        line( x
                            , y + DIAM/2
                            , x
                            , y + DIAM/2 + 35 );
                        // cross bit
                        line( x - 15
                            , y + DIAM/2 + (35/2)
                            , x + 15
                            , y + DIAM/2 + (35/2) );
                        ellipseMode(CORNERS);
                        arc( x - DIAM/2
                           , y - DIAM
                           , x + DIAM/2
                           , y - DIAM/2
                           , 0
                           , PI
                           , OPEN );
                        break;
      case IRON: strokeCap(SQUARE);
                 // line bit
                 line( xpos(145, DIAM/2)
                     , ypos(145, DIAM/2)
                     , xpos(145, DIAM/2 + 35)
                     , ypos(145, DIAM/2 + 35)
                     );
                  // arrow bit
                  line( xpos(145, DIAM/2 + 35) + 5
                      , ypos(145, DIAM/2 + 35)
                      , xpos(145, DIAM/2 + 35) - 25
                      , ypos(145, DIAM/2 + 35)
                      );
                  line( xpos(145, DIAM/2 + 35) + 3
                      , ypos(145, DIAM/2 + 35) - 5
                      , xpos(145, DIAM/2 + 35) + 3
                      , ypos(145, DIAM/2 + 35) + 25
                      );
                  break;
      default: break;
    }
    // wire it up
    stroke(COPPER_WIRE);
    strokeWeight(2);
    for (int i = 0; i < n; i += 4) {
      line( xpos(i, 25)
          , ypos(i, 25)
          , xpos(i, 50)
          , ypos(i, 50)
          );
    }
    //coil = (coil + 1) % 360;
  }
}

// DEAR COMPUTOR PLS MK ME A ART THANK YOU
