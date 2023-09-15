// Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
// Trabajo práctico 2
// Ejercicio 3
// Giuliano Palmisano

/*
Este programa implementa una interfaz gráfica para manejar el LED 
autocontenido de la Raspberry Pi Pico W  a través del puerto serie.
*/

/// LIBRERIAS ///
import processing.serial.*;

/// VARIABLES ///
Serial port;
boolean ledOn = false;

int but_h = 40;
int but_y = 480/2-but_h/2;
int but_w = 120;
int but_x = 640/2-but_w/2;
int ans;

/// SETUP ///
void setup() { 
  String portName = "COM4";
  
  // Abre el puerto serie
  port = new Serial(this, portName, 57600);
  
  // Configura la ventana
  size(640, 480);
}

/// MAIN LOOP ///
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

/// FUNCIONES ///
void mousePressed() {
  // Verifica si se hizo clic en el botón
  if (mouseX > but_x && mouseX< but_x + but_w && mouseY > but_y && mouseY < but_y + but_h) {
    // Cambia el estado del LED
    ledOn = !ledOn;
    
    // Envía el comando a través del puerto serie
    if (ledOn) {
      port.write("on\n\r");
    } else {
      port.write("off\n\r");
    }
  }
}
