// Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
// Trabajo práctico 2
// Ejercicio 5
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
boolean rec = false;
boolean started = false;
int but_h = 40;
int but_y = 2*WIN_H/3-but_h/2;
int but_w = 120;
int but_x = WIN_W/2-but_w/2;
String ans, aux;
FloatList points;
float val;
String[] spans;
float[] acum = {0};
int index = 0;
String date; 

// Variables para graficos
PGraphics pg1, pg2;
int PLOT_W = WIN_W/2-WIN_W/8;
int PLOT_H = WIN_H/2; 
float PLOT_X = WIN_W/15;
float PLOT_Y = WIN_H/15;
float X_AX = WIN_W/20;
float Y_AX = PLOT_Y+PLOT_H;
int N_PUNTOS = 10;
float PLOT_YMAX = 4;
float UNIT_Y = PLOT_H/PLOT_YMAX;
float UNIT_X = PLOT_W/N_PUNTOS;

/// SETUP ///
void settings(){
  // Configura la ventana
  size(WIN_W, WIN_H);  
}
void setup() { 
  String portName = "COM4";
  
  // Abre el puerto serie
  port = new Serial(this, portName, 57600);
  port.bufferUntil(37); // ASCII de %

  pg1 = createGraphics(PLOT_W, PLOT_H);
  pg2 = createGraphics(PLOT_W, PLOT_H);
  
  points = new FloatList();
}

/// MAIN LOOP ///
void draw() {
  background(60);
  if(!started){
  // Dibuja el botón
    fill(60);
    stroke(255);
    rect(but_x, but_y, but_w, but_h, 10);
    
    fill(255);
    textSize(16);
    textAlign(CENTER, CENTER);
    text("Start", width/2, height/2+75);
  }

  else{     
    fill(255);
    textSize(16);
    textAlign(CENTER, CENTER);
    text("Inicio: "+ date, width/2, height/2+75);
    
    textSize(10); // Para ejes de los graficos
    fill(150);
    // Grafico 1 - Curva
    pg1.beginDraw();
    pg1.noStroke();
    pg1.background(255);
    pg1.stroke(color(200,100,0));
    pg1.beginShape();
    
    // Dibujo uniendo lineas, y en el punto agrego un circulo
    if (points.size()==1){
      pg1.fill(150);
      pg1.circle(0, points.get(0), 5);
      text(0, PLOT_X, Y_AX+10);
    }
    if (points.size()>1){
      pg1.fill(150);
      pg1.circle(0, points.get(0), 5);
      text(0, PLOT_X, Y_AX+10);
      for (int i=1; i<points.size();i++){
        pg1.line((i-1)*UNIT_X, points.get(i-1), i*UNIT_X, points.get(i));
        pg1.fill(150);
        pg1.circle(i*UNIT_X, points.get(i), 5);
        if (i%5==0){
          text(int(i)*5, PLOT_X+i*UNIT_X, Y_AX+10);
        }
      }
    }  
    pg1.endShape();
    pg1.endDraw();
    
    // Gráfico 2 - Barras
    pg2.beginDraw();
    pg2.noStroke();
    pg2.background(255);
    pg2.stroke(150);
    pg2.fill(200,100,0);
    pg2.beginShape();
    for (int i=0; i<points.size();i++){ 
      pg2.rect(i*UNIT_X, PLOT_H, UNIT_X, -PLOT_H+points.get(i));
      if (i%5==0){
        text(int(i)*5, WIN_W/2+PLOT_X+i*UNIT_X+UNIT_X/2, Y_AX+10);
      }
    }
    pg2.endShape();
    pg2.endDraw();
    
    image(pg1, PLOT_X, PLOT_Y); 
    image(pg2, WIN_W/2+PLOT_X, PLOT_Y);
    
    // Ejes
    stroke(150);
    line(PLOT_X, PLOT_Y, PLOT_X, PLOT_Y+PLOT_H); // Eje Y plot1
    line(PLOT_X, PLOT_Y+PLOT_H, PLOT_X+PLOT_W, PLOT_Y+PLOT_H); // Eje X plot1
    line(WIN_W/2+PLOT_X, PLOT_Y, WIN_W/2+PLOT_X, PLOT_Y+PLOT_H); // Eje Y plot2  
    line(WIN_W/2+PLOT_X, PLOT_Y+PLOT_H, WIN_W/2+PLOT_X+PLOT_W, PLOT_Y+PLOT_H); // Eje X plot2
    
    for (int j=0; j<=PLOT_YMAX; j+=1){ 
      text(j, X_AX, Y_AX-UNIT_Y*j); // Eje Y plot1
      text(j, WIN_W/2+X_AX, Y_AX-UNIT_Y*j); // Eje Y plot2
    }
    // CREAR NUEVAS VARIABLES PARA GRAFICO 2
    // Etiquetas de los ejes
    text("V", X_AX, PLOT_Y-10);
    text("secs", PLOT_X+PLOT_W/2, Y_AX+20);
    text("V", WIN_W/2+X_AX, PLOT_Y-10);
    text("secs", WIN_W/2+PLOT_X+PLOT_W/2, Y_AX+20);
  }
}

/// FUNCIONES ///
void mousePressed() {
  // Verifica si se hizo clic en el botón
  if (mouseX > but_x && mouseX< but_x + but_w && mouseY > but_y && mouseY < but_y + but_h) {
      port.write("start\n\r");
      started = true;
      date = str(day())+"/"+str(month())+"/"+str(year())+", "+str(hour())+":"+str(minute())+":"+str(second()); 
  }  
}

void serialEvent(Serial p) {
  if (started){
    rec = true;
    
    ans = p.readString(); 
    int i0 = ans.indexOf("$");
    int i1 = ans.indexOf("%");
    aux = ans.substring(i0+1, i1);
    //println(aux);
    
    if (points.size()>=10){
      N_PUNTOS++;
      UNIT_X = PLOT_W/N_PUNTOS;
    }
    val = float(aux);
    points.append(PLOT_H-val*UNIT_Y);
    //index += 1;
    println(points);
  }
} 
