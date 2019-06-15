String FILE = "myImage.tmg";

boolean writing = false;
boolean erasing = false;

int defaultWriterSize = 1;
int writerSize = defaultWriterSize;
int writerSizeStep = 1;
int maxWriterSize = 50;

int defaultEraserSize = 20;
int eraserSize = defaultEraserSize;
int eraserSizeStep = 5;
int maxEraserSize = 50;

int prevMouseX, prevMouseY;

void updateTitle()
{
  surface.setTitle("TinyImage (" + width + ", " + height + ") [W=" + writerSize + " E=" + eraserSize + "]");
}

void setup()
{
  size(512, 512);
  background(255);
  noFill();
  
  updateTitle();
}

void draw()
{
  if (writing)
  {
    stroke(0);
    strokeWeight(writerSize);
    line(prevMouseX, prevMouseY, mouseX, mouseY);
    prevMouseX = mouseX;
    prevMouseY = mouseY;
  }
  if (erasing)
  {
    stroke(255);
    strokeWeight(eraserSize);
    line(prevMouseX, prevMouseY, mouseX, mouseY);
    prevMouseX = mouseX;
    prevMouseY = mouseY;
  }
}

void mousePressed()
{
  prevMouseX = mouseX;
  prevMouseY = mouseY;
  
  if (mouseButton == LEFT)
    writing = true;
  if (mouseButton == RIGHT)
    erasing = true;
}

void mouseReleased()
{
  if (mouseButton == LEFT)
    writing = false;
  if (mouseButton == RIGHT)
    erasing = false;
}

void keyPressed()
{
  if (key == 's')
    saveTinyImage();
  else if (key == 'l')
    loadTinyImage();
  else if (key == 'x')
    invertScreen();
  else if (key == 'c')
    clearScreen();
  else if (key == '+')
    eraserSize += eraserSizeStep;
  else if (key == '-')
    eraserSize -= eraserSizeStep;
  else if (key == '=')
    eraserSize = defaultEraserSize;
  else if (key == 'e')
    writerSize += writerSizeStep;
  else if (key == 'q')
    writerSize -= writerSizeStep;
  else if (key == 'w')
    writerSize = defaultWriterSize;
    
  eraserSize = constrain(eraserSize, 5, maxEraserSize);
  writerSize = constrain(writerSize, 1, maxWriterSize);
  
  updateTitle();
}

void saveTinyImage()
{
  byte[] bytes = new byte[height * width / 8];
  
  loadPixels();
  
  for (int i = 0; i < height * width / 8; i++)
  {
    byte current = 0;
    
    for (int j = 0; j < 8; j++)
      if (brightness(pixels[i * 8 + j]) != 255)
        current += pow(2, j);
    
    bytes[i] = current;
  }
  
  updatePixels();
  
  saveBytes(FILE, bytes);
}

void loadTinyImage()
{
  try
  {
    byte[] bytes = loadBytes(FILE);
    
    loadPixels();
    
    if (bytes.length == height * width / 8)
    {  
      for (int i = 0; i < height * width / 8; i++)
      {
        int current = bytes[i];
        
        if (current < 0)
          current += 256;
        
        for (int j = 7; j >= 0; j--)
        {
          if (current < pow(2, j))
            pixels[i * 8 + j] = color(255);
          else
          {
            pixels[i * 8 + j] = color(0);
            current -= pow(2, j);
          }
        }
      }
    }
    
    updatePixels();
  }
  catch(Exception e)
  {
  }
}

void invertScreen()
{
  loadPixels();
  
  for (int i = 0; i < height * width; i++)
  {
    if (brightness(pixels[i]) != 255)
      pixels[i] = color(255);
    else
      pixels[i] = color(0);
  }
  
  updatePixels();
}

void clearScreen()
{
  background(255);
}