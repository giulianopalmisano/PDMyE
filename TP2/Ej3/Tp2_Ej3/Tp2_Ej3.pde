import processing.serial.*;

Serial port;
boolean ledOn = false;

int but_h = 40;
int but_y = 480/2-but_h/2;
int but_w = 120;
int but_x = 640/2-but_w/2;

void setup() {
  // Enumera los puertos seriales disponibles
  //println(Serial.list());
  
  // Selecciona el puerto correcto (debes cambiar esto según tu configuración)
  String portName = "COM7"; // Cambia el nombre del puerto según tu sistema
  
  // Abre el puerto serie
  //port = new Serial(this, portName, 9600);
  
  // Configura la ventana
  size(640, 480);
}

void draw() {
  background(220);
  
  // Dibuja el botón
  fill(ledOn ? color(0, 255, 0) : color(255, 0, 0));
  rect(but_x, but_y, but_w, but_h, 10);
  
  // Muestra el estado del LED
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text(ledOn ? "LED Encendido" : "LED Apagado", width/2, height/2);
}

void mousePressed() {
  // Verifica si se hizo clic en el botón
  if (mouseX > but_x && mouseX< but_x + but_w && mouseY > but_y && mouseY < but_y + but_h) {
    // Cambia el estado del LED
    ledOn = !ledOn;
    
    // Envía el comando al Pico a través del puerto serie
    //if (ledOn) {
    //  port.write("ON\n");
    //} else {
    //  port.write("OFF\n");
    //}
  }
}
