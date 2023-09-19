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
int WIN_H = 480;
int WIN_W = 640;
boolean ask = false;
boolean buf = false;
boolean started = false;
int but_h = 40;
int but_y = 2*WIN_H/3-but_h/2;
int but_w = 120;
int but_x = WIN_W/2-but_w/2;
String ans, aux;
float val;
String[] spans;
float[] acum = {0};
int index = 0;

PGraphics pg1, pg2;
int PLOT_W = WIN_W/2-WIN_W/8;
int PLOT_H = WIN_H/2; 
float PLOT_X = WIN_W/15;
float PLOT_Y = WIN_H/15;
float X_AX = WIN_W/20;
float Y_AX = PLOT_Y+PLOT_H;
int N_PUNTOS = 20;
float PLOT_YMAX = 4;
float UNIT_Y = PLOT_H/PLOT_YMAX;
float UNIT_X = PLOT_W/N_PUNTOS;

/// SETUP ///
void setup() { 
  String portName = "COM4";
  
  // Abre el puerto serie
  port = new Serial(this, portName, 57600);
  port.bufferUntil(86); // ASCII de V
  // Configura la ventana
  size(640, 480);
  pg1 = createGraphics(PLOT_W, PLOT_H);
  pg2 = createGraphics(PLOT_W, PLOT_H);
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
  text("Actualizar", width/2, height/2+75);
  
  if (buf){
    //spans=split(ans,"$");
    //ans = spans[0];
    fill(0);
    textSize(20);
    textAlign(CENTER,CENTER);
    text("Valor A0: " + aux, width/2, height/2+100);
    val = float(aux);
    float[] valAux = {PLOT_H-val*UNIT_Y, index*UNIT_X};
    float[] acumAux = acum;
    acum = concat(acumAux, valAux);
    println(acum.length);
        
    buf=false;
  }
  textSize(10); // Para ejes de los graficos
  pg1.beginDraw();
  pg1.background(255);
  pg1.stroke(0);
  pg1.beginShape();
  if (acum.length>4){
    for (int i=2; i<acum.length-1;i+=2){
      pg1.line(acum[i-2],acum[i-1],acum[i],acum[i+1]);
      pg1.ellipse(acum[i],acum[i+1],5,5);
      text(int(acum[i]/UNIT_X), PLOT_X+acum[i], Y_AX+15);
    }
  }
  if (acum.length>1){
    pg1.ellipse(acum[0],acum[1],5,5);
  }
  pg1.endShape();
  pg1.endDraw();
  
  pg2.beginDraw();
  pg2.background(255);
  pg2.stroke(0);
  pg2.fill(200,100,0);
  pg2.beginShape();
  for (int i=0; i<acum.length-1;i+=2){
    pg2.rect(acum[i],PLOT_H,UNIT_X,-PLOT_H+acum[i+1]);
    text(int(acum[i]/UNIT_X), WIN_W/2+PLOT_X+acum[i]+UNIT_X/2, Y_AX+15);
  }
  pg2.endShape();
  pg2.endDraw();
  image(pg1, PLOT_X, PLOT_Y); 
  image(pg2, WIN_W/2+PLOT_X, PLOT_Y);
  // Plot 1
  line(PLOT_X,PLOT_Y,PLOT_X,PLOT_Y+PLOT_H); // Y axis
  line(PLOT_X,PLOT_Y+PLOT_H, PLOT_X+PLOT_W, PLOT_Y+PLOT_H); // X axis
  for (int j=0; j<=PLOT_YMAX; j+=1){ 
    text(j, X_AX, Y_AX-UNIT_Y*j); // EJE Y plot1
    text(j, WIN_W/2+X_AX, Y_AX-UNIT_Y*j); // Eje Y plot2
  }
  // CREAR NUEVAS VARIABLES PARA GRAFICO 2
  // Plot 2
  line(WIN_W/2+PLOT_X,PLOT_Y,WIN_W/2+PLOT_X,PLOT_Y+PLOT_H); // Y axis
  line(WIN_W/2+PLOT_X,PLOT_Y+PLOT_H, WIN_W/2+PLOT_X+PLOT_W, PLOT_Y+PLOT_H); // X axis
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
    //print(ans);
 
    int i0 = ans.indexOf("$");
    int i1 = ans.indexOf(" ");
    //println(str(i0),str(i1));
    aux = ans.substring(i0+1,i1);
    //print(aux);
    index += 1;
    //spans = split(ans, "$");
    //print(spans[1]);
    //val = split(spans[0], "\n\r");
    //print(val[0]);
    buf = true;
  }
} 
