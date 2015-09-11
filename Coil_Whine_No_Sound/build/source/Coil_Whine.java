import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Coil_Whine extends PApplet {

int n;
boolean inc;
final int COPPER_WIRE = 0xffDA8A67;
final float ANGLE = TWO_PI/(float)360;

public void setup() {
  background(255);
  
  n = 1;
}

public float xpos(float i, float n) { return n * sin(ANGLE * i) + width/2; }
public float ypos(float i, float n) { return n * cos(ANGLE * i) + height/2; }

public void draw() {
  background(255);
  stroke(0);
  strokeWeight(10);
  ellipse( width/2
         , height/2
         , 75
         , 75 );
  stroke(COPPER);
  strokeWeight(2);
  for (int i = 0; i < n; i += 4) {
    line( xpos(i, 25)
        , ypos(i, 25)
        , xpos(i, 50)
        , ypos(i, 50)
        );
  }
 n = (n == 360) ? 0 : n + 1 ;
 // n = inc ? n + 1 : n - 1;
 // if (n == 360 || n == 0) inc = !inc;
}
enum Alchemical { GOLD        // Sol
                , COPPER      // Venus
                , IRON        // Mars
                , QUICKSILVER // Mercury
                , MAGNESIUM
                , SILVER      // Luna
                };

class Symbol {
    final Alchemical metal;
    final int x, y;

    Symbol(int x, int y, Alchemical metal) {
        this.x     = x;
        this.y     = y;
        this.metal = metal;
    }
}
  public void settings() {  size(640,800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Coil_Whine" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
