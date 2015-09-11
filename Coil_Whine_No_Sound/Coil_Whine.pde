import java.util.List;
import java.util.ArrayList;

static enum Mode { NONE
                 , GREAT_SEAL
                 , JEWELRY_BOX
                 }

int coil;
Mode mode;
Symbol[] symbols;

void setup() {
  background(255);
  size(640,800);
  mode = Mode.NONE;
  symbols = new Symbol[]
     { new Symbol( width/5
                 , height/2
                 , Alchemical.QUICKSILVER
                 )
     , new Symbol( 2 * (width/5)
                 , height/2
                 , Alchemical.GOLD
                 )
     , new Symbol( 3 * (width/5)
                 , height/2
                 , Alchemical.COPPER
                 )
     , new Symbol( 4 * (width/5)
                 , height/2
                 , Alchemical.IRON
                 )
     };
}

void great_seal(int saturation) {
  // change color mode to HSV so we can change
  // the color of the seal based on a single number
  float hue = (millis() / 100) % 255;
  colorMode(HSB);
  stroke( hue
        , saturation
        , 255
        );
  strokeWeight(5);
  ellipse( width/2  // draw the circle for the Great Seal
         , height/2
         , width - 100
         , width - 100
         );
  triangle( 90 //  Draw the triangle within the Great Seal
          , height/3
          , width - 90
          , height/3
          , width/2
          , height - 135
          );
  // return color mode to RGB because every other
  // draw function expects this
  colorMode(RGB);
}

void draw() {
  background(255);

  switch (mode) {     // draw the Great Seal
    case GREAT_SEAL:  great_seal( (height - mouseY) /
                                  (height / 255) );
                      break;
                      // draw the jewelry box (eventually)
    case JEWELRY_BOX: break;
    default:          break;
  }

  // draw each planetary symbol
  for (Symbol symbol : symbols)
    symbol.draw(coil);
}

void mouseMoved() { coil = mouseX % 360; }

void mouseClicked() {
  Mode[] vals = Mode.values();
  mode = vals[(mode.ordinal() + 1) % (vals.length - 1)];
}
