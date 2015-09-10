
import beads.*;

final float ANGLE       = TWO_PI/(float)360;
final float DIAM        = 75;
final color COPPER_WIRE = #DA8A67;

static enum Alchemical { NONE        (0,0)
                       , GOLD        (79, 196.9665) // Sol
                       , COPPER      (29, 63.546)   // Venus
                       , IRON        (26, 55.845)   // Mars
                       , QUICKSILVER (80, 200.592)  // Mercury
                       , MAGNESIUM   (12, 24.305)
                       , SILVER      (47, 107.8682) // Luna
                       ;
                       
  final float atomic_weight;
  final float atomic_number;
  
  Alchemical(float atomic_number, float atomic_weight) {
    this.atomic_number = atomic_number;
    this.atomic_weight = atomic_weight;
  }
                       };

class Symbol {
  final Alchemical metal;
  Glide sineFrequency;
  Gain sineGain;
  WavePlayer sineTone;
  
  Symbol(Alchemical metal, int f) { this.metal = metal; 
                                    sineFrequency 
                                      = new Glide( ac
                                                 , metal.atomic_weight
                                                 , 30 );
                                    sineTone 
                                      = new WavePlayer( ac
                                                      , sineFrequency
                                                      , Buffer.SINE );
                                    sineGain
                                      = new Gain( ac
                                                , 1
                                                , 1.0);
                                    sineGain.addInput(sineTone);
                                    masterGain.addInput(sineGain);
                                  }

  float xpos(float i, float n, int x) {
    return n * sin(ANGLE * i) + (float)x;
  }

  float ypos(float i, float n, int y) {
    return n * cos(ANGLE * i) + (float)y;
  }

  void draw(int coil, int x, int y) {
    noFill();
    stroke(rune_color);
    strokeWeight(10);
    ellipseMode(CENTER);
    ellipse( x, y, DIAM, DIAM );
    switch (this.metal) {
      case GOLD: fill(rune_color);
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
      case QUICKSILVER: strokeCap(SQUARE);
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
                 line( xpos(145, DIAM/2, x)
                     , ypos(145, DIAM/2, y)
                     , xpos(145, DIAM/2 + 35, x)
                     , ypos(145, DIAM/2 + 35, y)
                     );
                  // arrow bit
                  line( xpos(145, DIAM/2 + 35, x) + 5
                      , ypos(145, DIAM/2 + 35, y)
                      , xpos(145, DIAM/2 + 35, x) - 25
                      , ypos(145, DIAM/2 + 35, y)
                      );
                  line( xpos(145, DIAM/2 + 35, x) + 3
                      , ypos(145, DIAM/2 + 35, y) - 5
                      , xpos(145, DIAM/2 + 35, x) + 3
                      , ypos(145, DIAM/2 + 35, y) + 25
                      );
                  break;
      default: break;
    }
    // wire it up
    stroke(COPPER_WIRE);
    strokeWeight(2);
    for (int i = 0; i < coil; i += 4) {
      line( xpos(i, 25, x)
          , ypos(i, 25, y)
          , xpos(i, 50, x)
          , ypos(i, 50, y)
          );
    }
  }
}
// DEAR COMPUTOR PLS MK ME A ART THANK YOU