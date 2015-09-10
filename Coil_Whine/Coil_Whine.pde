import beads.*;

static enum Mode { NONE
                 , GREAT_SEAL
                 , JEWELRY_BOX
                 }

PFont helvetica35
    , helvetica75
    , pragmata150;
PImage jewelry_box;
boolean rotate_spell = false
      , invert_spell = false;
int visible_symbols;
int bg_color         = 255
  , rune_color       = 0
  , tri_rot          = 0
  , title_fade       = 255
  , loneliness       = 3600;
Mode mode;
Symbol[] symbols;
final float GREAT_SEAL_RADIUS = 50;
final float GREAT_SEAL_ANGLE  = 3;
// Audio stuff
AudioContext ac;
Gain masterGain;
Glide gainGlide;
final float BASE_FREQUENCY = 50.0f;

void setup() {
  // this makes it look less bad on Retina but it also makes it slow
  //pixelDensity(2);
  pragmata150 = loadFont("PragmataPro-Bold-150.vlw");
  helvetica75 = loadFont("HelveticaNeue-CondensedBold-75.vlw");
  helvetica35 = loadFont("HelveticaNeue-Bold-35.vlw");
  jewelry_box = loadImage("jewelry_box.png");
  background(bg_color);
  size(1000,800);
  mode = Mode.NONE;
  visible_symbols = 1;
  tri_rot = 0;
  // create the audio stuff
  ac = new AudioContext();
  gainGlide  = new Glide(ac, 0.0, 50.0);
  masterGain = new Gain(ac, 1, gainGlide);
  // create the alchemical symbols
  symbols = new Symbol[]
     { new Symbol(Alchemical.COPPER, 1)
     , new Symbol(Alchemical.GOLD, 2)
     , new Symbol(Alchemical.QUICKSILVER, 1)
     , new Symbol(Alchemical.IRON, 4)
     };
   ac.out.addInput(masterGain);
   ac.start();
}


void great_seal(int saturation) {
  // RESET EVERYTHING
  ellipseMode(CENTER);
  noFill();
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
         , width - width/4
         , width - width/4
         );

  if (tri_rot > 0) {
    translate(width/2, height/2);
    rotate(radians(tri_rot));
    translate(-width/2, -height/2);
    //  Draw the triangle within the Great Seal
    triangle( width/2
            , 26
            , width/6      + 11
            , 3*(height/4) - 11
            , 5*(width/6)  - 10
            , 3*(height/4) - 10
            );
    translate(width/2, height/2);
    rotate(radians(-tri_rot));
    translate(-width/2, -height/2);
    tri_rot = (tri_rot + 1) % 360;
  } else {
    //  Draw the triangle within the Great Seal
    triangle( width/2
            , 26
            , width/6      + 11
            , 3*(height/4) - 11
            , 5*(width/6)  - 10
            , 3*(height/4) - 10
            );
  }
  // return color mode to RGB because every other
  // draw function expects this
  colorMode(RGB);
}

void title() {
  textFont(helvetica35, 35);
  colorMode(RGB);
  fill(255 - title_fade);
  text( "Eliza's House of Discount Electrical Equipment"
      , 10
      , 30);
  text( "proudly presents:"
      , 10
      , 65);
  textFont(helvetica75, 67);
  text( "Sigil No. 01"
      , 10
      , 125);
  textFont(pragmata150, 150);
  text( "COIL"
      , 310
      , 165);
  text( "WHINE"
      , 310
      , 285);

  if (loneliness < 3600 && title_fade > 0)
    title_fade--;
}

void make_me_lonely() { mode       = Mode.NONE;
                        title_fade = 255;
                        bg_color   = 255;
                        rune_color = 0;
                      }

void draw() { //<>// //<>//
  background(bg_color);

  if (loneliness >= 3600)     make_me_lonely();
  else if (loneliness < 3600) loneliness++;

  switch (mode) {
    case GREAT_SEAL:  // draw the Great Seal
                      great_seal( (height - mouseY) /
                                  (height / 255) );
                      break;

    case JEWELRY_BOX: image(jewelry_box, 0, 0, width, height);
                      break;
    case NONE:        title();
    default:          break;
  }
  // figure out how big the coil is
  int coil = (width - mouseX) / (width / 360);
  // draw each planetary symbol
  for (int i = 1; i <= visible_symbols; i++)
    symbols[i - 1].draw( coil
                , i * (width / (visible_symbols + 1))
                , height / 2 );

  symbols[visible_symbols - 1]
        .sineFrequency
        .setValue( (visible_symbols * 500) +
                   (mouseY * (height/400) ));
  gainGlide.setValue( ((width - mouseX) / (float)width));
}
void mouseMoved() { loneliness = 0; }

void mouseClicked() { loneliness = 0;
                      int v_prime = (visible_symbols + 1) %
                                    (symbols.length + 1);
                      visible_symbols = (v_prime == 0) ? 1 : v_prime;
                    }
void mouseDragged() {
  loneliness = 0;
  // handle spells!
  if (mouseX > pmouseX && mouseX > 3 * (width/4)
                       && !rotate_spell)
  { // started the rotate spell
    rotate_spell = true;
  } else if (mouseY < pmouseY && mouseX > 3 * (width/4)
                              && rotate_spell)
  { // finished the rotate spell
    rotate_spell = false;
    tri_rot = (tri_rot == 0)? 1 : tri_rot;
  } else if (mouseX < pmouseX && mouseX < (width/4)
                              && !invert_spell)
  { // started the invert spell
    invert_spell = true;
  } else if (mouseY > pmouseY && mouseX < (width/4)
                              && invert_spell)
  { // finished the invert spell
    invert_spell = false;
    bg_color   = (bg_color == 0)? 255 : 0;
    rune_color = (rune_color == 0)? 255 : 0;
  }
  else if (mouseX - pmouseX > 100 && abs(mouseY - pmouseY) < 50
                                  && mode != Mode.GREAT_SEAL)
  { // conjure the great seal
    mode = Mode.GREAT_SEAL;
  }
  else if (mouseX - pmouseX < -100 && abs(mouseY - pmouseY) < 50
                                   && mode != Mode.JEWELRY_BOX)
  { // conjure the jewelry box
    mode = Mode.JEWELRY_BOX;
  }
}
