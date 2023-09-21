// Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
// Trabajo práctico 2
// Ejercicio 4
// Giuliano Palmisano

/*
Este programa implementa una interfaz para visualizar el valor del
conversor AD0 de la Raspberry Pi Pico W  a través del puerto serie.
Al clickear en "Actualizar", se refresca el valor.
*/

/// LIBRERIAS ///
import processing.serial.*;

/// VARIABLES ///
Serial port;
boolean ask = false;
boolean buf = false;

int but_h = 40;
int but_y = 480/2-but_h/2;
int but_w = 120;
int but_x = 640/2-but_w/2;

String ans, aux;

/// SETUP ///
void setup() { 
  String portName = "COM4";
  
  // Abre el puerto serie
  port = new Serial(this, portName, 57600);
  port.bufferUntil(37); // ASCII de %
  
  // Configura la ventana
  size(640, 480);
}

/// MAIN LOOP ///
void draw() {
  background(40);
  
  // Dibuja el botón
  fill(40);
  stroke(255);
  rect(but_x, but_y, but_w, but_h, 10);
  // Texto del boton
  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Actualizar", width/2, height/2);
  // Muestro el valor en caso que ya se haya solicitado al menos una vez
  if (ask){
    textSize(20);
    textAlign(CENTER,CENTER);
    text("Valor A0: " + aux, width/2, height/2+75); 
  }
}

/// FUNCIONES ///
void mousePressed() {
  // Verifica si se hizo clic en el botón
  if (mouseX > but_x && mouseX< but_x + but_w && mouseY > but_y && mouseY < but_y + but_h) {
      port.write("read\n\r");
      ask = true;
  }  
}

// Función que se activa cuando llega al buffer el caracter "%" (ver linea 33)
void serialEvent(Serial p) { 
  if (ask){
    ans = p.readString(); // Leo el string
    //println(ans);
    int i0 = ans.indexOf("$");
    int i1 = ans.indexOf("%");
    aux = ans.substring(i0+1,i1);  // Lo divido segun los caracteres de inicio y fin
    //print(aux);
  }
} 
