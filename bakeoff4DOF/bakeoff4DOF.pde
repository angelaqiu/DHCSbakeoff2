import java.util.ArrayList;
import java.util.Collections;
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.Point;
import java.awt.MouseInfo;

//these are variables you should probably leave alone
int index = 0;
int trialCount = 3; //this will be set higher for the bakeoff
float border = 0; //have some padding from the sides
int trialIndex = 0; //what trial are we on
int errorCount = 0;  //used to keep track of errors
float errorPenalty = 0.5f; //for every error, add this to mean time
int startTime = 0; // time starts when the first click is captured
int finishTime = 0; //records the time of the final click
boolean userDone = false;

final int screenPPI = 72; //what is the DPI of the screen you are using
//you can test this by drawing a 72x72 pixel rectangle in code, and then confirming with a ruler it is 1x1 inch. 

//These variables are for my example design. Your input code should modify/replace these!
float screenTransX = 0;
float screenTransY = 0;
float screenRotation = 0;
float screenZ = 50f;

boolean pressed = false;
color currColor = color(150, 150, 150);

// TEST CONTROL BOX
float bx;
float by;
int buttonSize = 10;
boolean overBox = false;
boolean locked = false;
float xOffset = 0.0; 
float yOffset = 0.0; 

int windowX, windowY, absMouseX, absMouseY;  // for mouse positioning

float sizeButtonLeft, sizeButtonTop, sizeButtonRight, sizeButtonBottom;
float sizeControlLength = 300;
float sizeControlLength2 = 300;

float sizeControlDefaultX;
float sizeControlDefaultY;

// TEST ORIENTATION CONTROL
float bx2;
float by2;
boolean overBox2 = false;
boolean locked2 = false;
float xOffset2 = 0.0; 
float yOffset2 = 0.0; 

float sizeButtonLeft2, sizeButtonTop2, sizeButtonRight2, sizeButtonBottom2;

float sizeControlDefaultX2;
float sizeControlDefaultY2;

float distanceBetweenControls = 50;

//===============Mainbox : Madhur===============
float bx3 = screenTransX;
float by3 = screenTransY;
boolean overBox3 = false;
boolean locked3 = false;
float xOffset3 = 0.0; 
float yOffset3 = 0.0; 
//===============Mainbox : Madhur===============

// Checkbox 
//===============Calvin===============
float cbx1;
float cby1;
float cbx2;
float cby2;
float cbx3;
float cby3;
//===============Calvin===============

// Paras for sidebar
//===============Calvin===============
int sidebarWidth = 400;
float totalWidth = 880.0;
//===============Calvin===============


// Target class

private class Target
{
  float x = 0;
  float y = 0;
  float rotation = 0;
  float z = 0;
}


ArrayList<Target> targets = new ArrayList<Target>();

float inchesToPixels(float inch)
{
  return inch*screenPPI;
}

void setup() {
  // Adjusted size
  //===============Calvin===============
  size(1100,700); // WAS 800
  //===============Calvin===============

  rectMode(CENTER);
  textFont(createFont("Arial", inchesToPixels(.2f))); //sets the font to Arial that is .3" tall
  textAlign(CENTER);

  //don't change this! 
  border = inchesToPixels(.3f); //padding of 0.2 inches

  for (int i=0; i<trialCount; i++) //don't change this! 
  {
    Target t = new Target();
    //===============Limit the area of target===============
    //===============Calvin===============
    t.x = random(-width/2+border, width/2-border-sidebarWidth); //set a random x with some padding
    t.y = random(-height/2+border, height/2-border-sidebarWidth); //set a random y with some padding
    //===============Calvin===============
    t.rotation = random(0, 360); //random rotation between 0 and 360
    int j = (int)random(20);
    t.z = ((j%20)+1)*inchesToPixels(.15f); //increasing size from .15 up to 3.0" 
    targets.add(t);
    println("created target with " + t.x + "," + t.y + "," + t.rotation + "," + t.z);
  }

  Collections.shuffle(targets); // randomize the order of the button; don't change this.
  
  //===========TEST CONTROL BOX STUFF=================
  
  bx = totalWidth - inchesToPixels(.2f) * 10;
  by = inchesToPixels(.2f) * 12;
  sizeControlDefaultX = bx;
  sizeControlDefaultY = by;
  sizeButtonLeft = bx - buttonSize;
  sizeButtonRight = bx + buttonSize;
  sizeButtonTop = by - buttonSize;
  sizeButtonBottom = by + buttonSize;
    
  bx2 = totalWidth - inchesToPixels(.2f) * 10;
  by2 = inchesToPixels(.2f) * 12 + distanceBetweenControls;
  sizeControlDefaultX2 = bx2;
  sizeControlDefaultY2 = by2;
  sizeButtonLeft2 = bx2 - buttonSize;
  sizeButtonRight2 = bx2 + buttonSize;
  sizeButtonTop2 = by2 - buttonSize;
  sizeButtonBottom2 = by2 + buttonSize;
  
  ellipseMode(RADIUS);
  
  cbx1 = totalWidth - inchesToPixels(.5f);
  cby1 = inchesToPixels(.5f) * 8;
  cbx2 = totalWidth - inchesToPixels(.5f);
  cby2 = inchesToPixels(.5f) * 9;
  cbx3 = totalWidth - inchesToPixels(.5f);
  cby3 = inchesToPixels(.5f) * 10;
}



void draw() {
  
  background(60); //background is dark grey

  fill(200);
  noStroke();
  


  //shouldn't really modify this printout code unless there is a really good reason to
  if (userDone)
  {
    text("User completed " + trialCount + " trials", width/2, inchesToPixels(.2f));
    text("User had " + errorCount + " error(s)", width/2, inchesToPixels(.2f)*2);
    text("User took " + (finishTime-startTime)/1000f/trialCount + " sec per target", width/2, inchesToPixels(.2f)*3);
    text("User took " + ((finishTime-startTime)/1000f/trialCount+(errorCount*errorPenalty)) + " sec per target inc. penalty", width/2, inchesToPixels(.2f)*4);
    return;
  }

  //===========DRAW TARGET SQUARE=================
  pushMatrix();
  translate(width/2, height/2); //center the drawing coordinates to the center of the screen
  Target t = targets.get(trialIndex);


  translate(t.x, t.y); //center the drawing coordinates to the center of the screen
  rotate(radians(t.rotation));
  fill(255, 0, 0); //set color to semi translucent
  rect(0, 0, t.z, t.z);
  popMatrix();

  //===========DRAW CURSOR SQUARE=================
  
  // Test if the cursor is over the box 
  //print(width, totalWidth, sidebarWidth, "\n");
  if (mouseX > screenTransX-screenZ+(width/2) && mouseX < screenTransX+screenZ+(width/2) && 
      mouseY > screenTransY-screenZ+(height/2) && mouseY < screenTransY+screenZ+(height/2)) {
    overBox3 = true;  
    if(locked3) { 
    overBox3 = false;
    }
  }
  else
  {
    overBox3 = false;
  }
  print(overBox3, "\n");
  //print(overBox3, screenTransX, screenTransY, screenZ, "\n");
  pushMatrix();
  translate(width/2, height/2); //center the drawing coordinates to the center of the screen
  translate(screenTransX, screenTransY);
  rotate(radians(screenRotation));
  noFill();
  strokeWeight(3f);
  stroke(currColor);
  rect(0,0, screenZ, screenZ);
  popMatrix();
  
  
  fill(105,105,105);
  rect(900, 400, sidebarWidth, 800);
  


  //===========DRAW EXAMPLE CONTROLS=================
  fill(255);
  scaffoldControlLogic(); //you are going to want to replace this!
  text("Trial " + (trialIndex+1) + " of " +trialCount, width/2, inchesToPixels(.5f));
  
  
  //===============Checkbox============
  //===============Calvin===============  
  if (checkForSuccessDist()) {
    fill(0, 255, 0);
    text("[  x  ]  Location", cbx1, cby1);
  } else {
    fill(255);
    text("[     ]  Location", cbx1, cby1);
  }

  if (checkForSuccessZ()) {
    fill(0, 255, 0);
    text("[  x  ]  Size      ", cbx2, cby2);
  } else {
    fill(255);
    text("[     ]  Size      ", cbx2, cby2);
  }
  
  if (checkForSuccessRotation()) {
    fill(0, 255, 0);
    text("[  x  ]  Rotation", cbx3, cby3);
  } else {
    fill(255);
    text("[     ]  Rotation", cbx3, cby3);
  }
    
  fill(255);
  //===============Calvin===============  

  

  
  //===========DRAW SIZE CONTROL =================
      
    // Test if the cursor is over the box 
    if (mouseX > bx-buttonSize && mouseX < bx+buttonSize && 
        mouseY > by-buttonSize && mouseY < by+buttonSize) {
      overBox = true;  
      if(!locked) { 
        stroke(255); 
        //fill(0,255,0);
        //bx = sizeControlDefaultX;
        //by = sizeControlDefaultY;
      } 
    } 
    else {
      stroke(153);
      //fill(0,255,0);
      overBox = false;
    }
    
    // Draw the line
    fill(255,0,0);
    strokeWeight(10);
    line(sizeControlDefaultX-buttonSize, sizeControlDefaultY, 
         sizeControlDefaultX+sizeControlLength, sizeControlDefaultY);
         
    // Draw the control
    fill(0,255,0);
    ellipse(bx, by, buttonSize, buttonSize);
    
   //===========DRAW SIZE CONTROL =================
      
    // Test if the cursor is over the box 
    if (mouseX > bx2-buttonSize && mouseX < bx2+buttonSize && 
        mouseY > by2-buttonSize && mouseY < by2+buttonSize) {
      overBox2 = true;  
      if(!locked2) { 
        stroke(255); 
        //fill(0,255,0);
        //bx = sizeControlDefaultX;
        //by = sizeControlDefaultY;
      } 
    } 
    else {
      stroke(153);
      //fill(0,255,0);
      overBox2 = false;
    }
    
    // Draw the line
    fill(255,0,0);
    strokeWeight(10);
    line(sizeControlDefaultX2-buttonSize, sizeControlDefaultY2, 
         sizeControlDefaultX2+sizeControlLength, sizeControlDefaultY2);
         
    // Draw the control
    fill(0,255,0);
    ellipse(bx2, by2, buttonSize, buttonSize);
    
    
    //=========== CONSTRAIN MOUSE WITHIN WINDOW =================
    MouseInfo.getPointerInfo();
    Point pt = MouseInfo.getPointerInfo().getLocation();
    absMouseX = (int)pt.getX();
    absMouseY = (int)pt.getY();
    if(mouseX > 50 && mouseX < width-50 && mouseY > 50 && mouseY < height-50
                    && abs(mouseX-pmouseX) == 0 && abs(mouseY-pmouseY) == 0) {
      windowX = (int)(absMouseX-mouseX);
      windowY = (int)(absMouseY-mouseY);
    }
    int x = -1, y = -1;
    if(absMouseX < windowX)
      x = windowX;
    else if(absMouseX > windowX+width)
      x = windowX + width;
    if(absMouseY < windowY)
      y = windowY;
    else if(absMouseY > windowY+height)
      y = windowY + height;
    if(!(x == -1 && y == -1))
      try {
        Robot bot = new Robot();
        bot.mouseMove(x == -1 ? absMouseX : x, y == -1 ? absMouseY : y);
      }
      catch (AWTException e) {}
}

//my example design for control, which is terrible
void scaffoldControlLogic()
{
  if(locked)
    screenZ = (bx - sizeControlDefaultX + buttonSize)*inchesToPixels(.02f);
  
  // finer size control buttons
  float buffer = 15;
  text("+", sizeControlDefaultX+sizeControlLength + buffer, sizeControlDefaultY + 5);
  if (mousePressed && dist(sizeControlDefaultX+sizeControlLength + buffer, 
                           sizeControlDefaultY + 5, 
                           mouseX, mouseY) < inchesToPixels(.2f))
  {  
    if (pressed == false) {
      pressed = true;
      screenZ += inchesToPixels(.02f);
    }
  }
    
    
  text("-", sizeControlDefaultX+sizeControlLength + buffer *2, sizeControlDefaultY + 5);
  if (mousePressed && dist(sizeControlDefaultX+sizeControlLength + buffer*2, 
                           sizeControlDefaultY + 5, 
                           mouseX, mouseY) < inchesToPixels(.2f))                        
  {
    if (pressed == false) {
      pressed = true;
      screenZ -= inchesToPixels(.02f);
    }
  }

  if(locked2)
    screenRotation = (bx2 / (sizeButtonRight2 - sizeControlDefaultX2)) * 6;   

  // finer orientation control buttons
  text("⤾", sizeControlDefaultX2+sizeControlLength + buffer, sizeControlDefaultY2 + 5);
  if (mousePressed && dist(sizeControlDefaultX2+sizeControlLength + buffer, 
                           sizeControlDefaultY2 + 5, 
                           mouseX, mouseY) < inchesToPixels(.2f)) 
  {
    if (pressed == false) {
      pressed = true;
      screenRotation++;
    }
  }    
  text("⤿", sizeControlDefaultX2+sizeControlLength + buffer *2, sizeControlDefaultY2 + 5);
  if (mousePressed && dist(sizeControlDefaultX2+sizeControlLength + buffer*2, 
                           sizeControlDefaultY2 + 5, 
                           mouseX, mouseY) < inchesToPixels(.2f))                        
  {
    if (pressed == false) {
      pressed = true;
      screenRotation--;
    }
  }      
  //left middle, move left
  text("left", 1000-inchesToPixels(.2f) * 12, inchesToPixels(.2f) * 6);
  if (mousePressed && dist(1000-inchesToPixels(.2f) * 12, inchesToPixels(.2f) * 6, mouseX, mouseY)<inchesToPixels(.5f))
  {
    if (pressed == false) {
      pressed = true;
      screenTransX-=inchesToPixels(.02f);
    }
  }

  text("right", 1000-inchesToPixels(.2f) * 6, inchesToPixels(.2f) * 6);
  if (mousePressed && dist(1000-inchesToPixels(.2f) * 6, inchesToPixels(.2f) * 6, mouseX, mouseY)<inchesToPixels(.5f))
  {
    if (pressed == false) {
      pressed = true;
      screenTransX+=inchesToPixels(.02f);
    }
  }
  
  text("up", 1000-inchesToPixels(.2f) * 9, inchesToPixels(.2f) * 3);
  if (mousePressed && dist(1000-inchesToPixels(.2f) * 9, inchesToPixels(.2f) *3, mouseX, mouseY)<inchesToPixels(.5f))
  {
    if (pressed == false) {
      pressed = true;
      screenTransY-=inchesToPixels(.02f);
    }
  }
  
  text("down", 1000-inchesToPixels(.2f) * 9, inchesToPixels(.2f) * 9);
  if (mousePressed && dist(1000-inchesToPixels(.2f) * 9, inchesToPixels(.2f) * 9, mouseX, mouseY)<inchesToPixels(.5f))
  {  
    if (pressed == false) {
      pressed = true;
      screenTransY+=inchesToPixels(.02f);
    }
  }
}


void mousePressed()
{
    if (startTime == 0) //start time on the instant of the first user click
    {
      startTime = millis();
      println("time started!");
    }
    
    // SIZE CONTROL BOX
    if(overBox) { 
      locked = true; 
      fill(255, 255, 255);
    } else {
      locked = false;
    }
    xOffset = mouseX-bx; 
    yOffset = mouseY-by; 
    
    
    // ORIENTATION CONTROL BOX
    if(overBox2) { 
      locked2 = true; 
      fill(255, 255, 255);
    } else {
      locked2 = false;
    }
    xOffset2 = mouseX-bx2; 
    yOffset2 = mouseY-by2; 
    
    // Main Box
    if(overBox3) { 
    locked3 = true;
    } else {
      locked3 = false;
    }
    xOffset3 = mouseX-screenTransX; 
    yOffset3 = mouseY-screenTransY; 

}


void mouseReleased()
{
  pressed = false;
  if (checkForSuccess()) 
  {
    currColor = color(0, 255, 0);
  }
  else
  {
    currColor = color(150, 150, 150);
  }
  //check to see if user clicked middle of screen within 3 inches
  if (dist(width/2, height/2, mouseX, mouseY)<inchesToPixels(3f))
  {
    if (userDone==false && !checkForSuccess())
      errorCount++;

    //and move on to next trial
    trialIndex++;
    
    if (trialIndex==trialCount && userDone==false)
    {
      userDone = true;
      finishTime = millis();
    }
  }
  
  // SIZE AND ORIENTATION CONTROL BOXES
  locked = false;
  locked2 = false;
  locked3 = false;
}

void mouseDragged() {
  
  // SIZE CONTROL
  if(locked) {
    
    // Button restrained
    if(mouseX - xOffset >= sizeButtonLeft && mouseX - xOffset <= sizeButtonLeft + sizeControlLength)
      bx = mouseX-xOffset; 
      
    // Mouse restrained
    MouseInfo.getPointerInfo();
    Point pt = MouseInfo.getPointerInfo().getLocation();
      
    absMouseX = (int)pt.getX();
    absMouseY = (int)pt.getY();
    if(mouseX > 50 && mouseX < width-50 && mouseY > 50 && mouseY < height-50
                    && abs(mouseX-pmouseX) == 0 && abs(mouseY-pmouseY) == 0) {
      windowX = (int)(absMouseX-mouseX);
      windowY = (int)(absMouseY-mouseY);
    }
    float x = -1, y = -1;

    float buffer = 10;
    if(absMouseY < sizeButtonTop - buffer)
      y = windowY + sizeButtonTop;
    else if(absMouseY > sizeButtonBottom + buffer)
      y = windowY + sizeButtonBottom;
    if(!(x == -1 && y == -1))
      try {
        Robot bot = new Robot();
        bot.mouseMove(x == -1 ? (int)absMouseX : (int)x, y == -1 ? (int)absMouseY : (int)y);
      }
      catch (AWTException e) {}
  }
  
  // ORIENTATION CONTROL
  if(locked2) {
    
    // Button restrained
    if(mouseX - xOffset2 >= sizeButtonLeft2 && mouseX - xOffset2 <= sizeButtonLeft2 + sizeControlLength)
      bx2 = mouseX-xOffset2; 
      
    // Mouse restrained
    MouseInfo.getPointerInfo();
    Point pt = MouseInfo.getPointerInfo().getLocation();
      
    absMouseX = (int)pt.getX();
    absMouseY = (int)pt.getY();
    if(mouseX > 50 && mouseX < width-50 && mouseY > 50 && mouseY < height-50
                    && abs(mouseX-pmouseX) == 0 && abs(mouseY-pmouseY) == 0) {
      windowX = (int)(absMouseX-mouseX);
      windowY = (int)(absMouseY-mouseY);
    }
    float x = -1, y = -1;

    float buffer = 10;
    if(absMouseY < sizeButtonTop2 - buffer)
      y = windowY + sizeButtonTop2;
    else if(absMouseY > sizeButtonBottom2 + buffer)
      y = windowY + sizeButtonBottom2;
    if(!(x == -1 && y == -1))
      try {
        Robot bot = new Robot();
        bot.mouseMove(x == -1 ? (int)absMouseX : (int)x, y == -1 ? (int)absMouseY : (int)y);
      }
      catch (AWTException e) {}
  }
  
  // Main box
   if(locked3) {
    screenTransX = mouseX-xOffset3; 
    screenTransY = mouseY-yOffset3; 
  }
}


public boolean checkForSuccessDist()
{
  Target t = targets.get(trialIndex);  
  boolean closeDist = dist(t.x,t.y,screenTransX,screenTransY)<inchesToPixels(.05f); //has to be within .1"
  return closeDist;  
}

public boolean checkForSuccessRotation()
{
  Target t = targets.get(trialIndex);  
  boolean closeRotation = calculateDifferenceBetweenAngles(t.rotation,screenRotation)<=5;  
  
  return closeRotation;  
}

public boolean checkForSuccessZ()
{
  Target t = targets.get(trialIndex);  
  boolean closeZ = abs(t.z - screenZ)<inchesToPixels(.05f); //has to be within .1"  
 
  return closeZ;  
}


//probably shouldn't modify this, but email me if you want to for some good reason.
public boolean checkForSuccess()
{
	Target t = targets.get(trialIndex);	
	boolean closeDist = dist(t.x,t.y,screenTransX,screenTransY)<inchesToPixels(.05f); //has to be within .1"
  boolean closeRotation = calculateDifferenceBetweenAngles(t.rotation,screenRotation)<=5;
	boolean closeZ = abs(t.z - screenZ)<inchesToPixels(.05f); //has to be within .1"	
	
  println("Close Enough Distance: " + closeDist + " (cursor X/Y = " + t.x + "/" + t.y + ", target X/Y = " + screenTransX + "/" + screenTransY +")");
  println("Close Enough Rotation: " + closeRotation + " (rot dist="+calculateDifferenceBetweenAngles(t.rotation,screenRotation)+")");
 	println("Close Enough Z: " +  closeZ + " (cursor Z = " + t.z + ", target Z = " + screenZ +")");
	
	return closeDist && closeRotation && closeZ;	
}

//utility function I include
double calculateDifferenceBetweenAngles(float a1, float a2)
  {
     double diff=abs(a1-a2);
      diff%=90;
      if (diff>45)
        return 90-diff;
      else
        return diff;
 }