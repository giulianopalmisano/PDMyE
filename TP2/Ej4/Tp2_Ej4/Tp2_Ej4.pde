// Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
// Trabajo práctico 2
// Ejercicio 4
// Giuliano Palmisano

/*
Este programa implementa una interfaz para visualizar el valor del
conversor AD0 de la Raspberry Pi Pico W  a través del puerto serie.
COMANDO:
    -'read' para refrescar el valor.
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
String[] val;
String[] spans;

/// SETUP ///
void setup() { 
  String portName = "COM4";
  
  // Abre el puerto serie
  port = new Serial(this, portName, 57600);
  port.bufferUntil(86); // ASCII de V
  // Configura la ventana
  size(640, 480);
}

/// MAIN LOOP ///
void draw() {
  background(220);
  
  // Dibuja el botón
  fill(color(100,20,100));
  rect(but_x, but_y, but_w, but_h, 10);
  
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Actualizar", width/2, height/2);
  
  if (buf){
    //spans=split(ans,"$");
    //ans = spans[0];
    fill(0);
    textSize(20);
    textAlign(CENTER,CENTER);
    text("Valor A0: " + spans[1], width/2, height/2+75);
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

void serialEvent(Serial p) { 
  if (ask){
    ans = p.readString();
    print(ans);
 
    //int i0 = ans.indexOf("$");
    //int i1 = ans.indexOf(" ");
    //println(str(i0),str(i1));
    //aux = ans.substring(i0+1,i1);
    //print(aux);
    
    spans = split(ans, "$");
    print(spans[1]);
    //val = split(spans[0], "\n\r");
    //print(val[0]);
    buf = true;
  }
} 
