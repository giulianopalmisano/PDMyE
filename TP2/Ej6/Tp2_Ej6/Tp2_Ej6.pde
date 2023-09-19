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
boolean run = false;
boolean stop = true;
boolean settingTs = false;
boolean confTs = false;

boolean buf = false;
boolean started = false;
int BUT_H = 40;
int BUT_W = 120;
int BUT_STA_Y = 3*WIN_H/4-BUT_H/2;
int BUT_STA_X = WIN_W/4-BUT_W/2;
int BUT_STO_Y = 3*WIN_H/4-BUT_H/2;
int BUT_STO_X = 2*WIN_W/4-BUT_W/2;
int BUT_DW_Y = 3*WIN_H/4-BUT_H/2;
int BUT_DW_X = 3*WIN_W/4-BUT_W/2;
int CONT_TS_W = WIN_W/2;
int CONT_TS_H = WIN_H/4;
int CONT_TS_X = WIN_W/4;
int CONT_TS_Y = WIN_H/16;
int BUT_TS_X = CONT_TS_X+CONT_TS_W/2-CONT_TS_W/6;
int BUT_TS_Y = CONT_TS_Y+CONT_TS_H/2;
int BUT_DEL_W = CONT_TS_W/15;
int BUT_DEL_H = CONT_TS_W/15;
int BUT_DEL_X = CONT_TS_X+CONT_TS_W-BUT_DEL_W-5;
int BUT_DEL_Y = CONT_TS_Y+CONT_TS_H/4-BUT_DEL_H/2; 
int ts;
String tsAux="";
int contKey=0;
String ans, aux;
float val;
String[] spans;
float[] acum = {0};
int index = 0;

/// SETUP ///
void settings(){
  // Configura la ventana
  size(WIN_W, WIN_H);
}

void setup() {
  //String portName = "COM4";

  //// Abre el puerto serie
  //port = new Serial(this, portName, 57600);
  //port.bufferUntil(86); // ASCII de V

}

/// MAIN LOOP ///
void draw() {
  background(40);
  noStroke();
  // Configuración del Ts
  fill(color(100));
  rect(CONT_TS_X, CONT_TS_Y, CONT_TS_W, CONT_TS_H,10);
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Sampling time [sec] (>30s): " + tsAux, CONT_TS_X+CONT_TS_W/2, CONT_TS_Y+CONT_TS_H/4);
  fill(color(190,190,190));
  rect(BUT_TS_X, BUT_TS_Y, BUT_W, BUT_H,10);//CONT_TS_W/3, CONT_TS_H/3);
  fill(0);
  if (settingTs){
    text("Confirm", BUT_TS_X+BUT_W/2,BUT_TS_Y+BUT_H/2);
    stroke(color(255,0,0));
    fill(color(255,0,0));
    rect(BUT_DEL_X, BUT_DEL_Y, BUT_DEL_W, BUT_DEL_H);
    stroke(255);
    strokeWeight(4);
    line(BUT_DEL_X, BUT_DEL_Y,BUT_DEL_X+BUT_DEL_W, BUT_DEL_Y+BUT_DEL_H);
    line(BUT_DEL_X, BUT_DEL_Y+BUT_DEL_H,BUT_DEL_X+BUT_DEL_W, BUT_DEL_Y);
  }
  else if (confTs){
    fill(100);
    rect(BUT_TS_X, BUT_TS_Y, BUT_W, BUT_H,10);
    fill(0);
    text("Confirmed!", BUT_TS_X+BUT_W/2,BUT_TS_Y+BUT_H/2);
  }
  else{
    text("Set Ts", BUT_TS_X+BUT_W/2,BUT_TS_Y+BUT_H/2);
  }
  stroke(235);
  strokeWeight(2);
  // Dibuja botones fill(ledOn ? color(0, 255, 0) : color(255, 0, 0));
  fill(color(200, 60, 60));
  rect(BUT_STO_X, BUT_STO_Y, BUT_W, BUT_H, 10);
  fill(0);
  text("STOP", BUT_STO_X+BUT_W/2, BUT_STO_Y+BUT_H/2);
  
  fill(color(80, 200, 80));
  rect(BUT_STA_X, BUT_STA_Y, BUT_W, BUT_H, 10);
  fill(0);
  text("START", BUT_STA_X+BUT_W/2, BUT_STA_Y+BUT_H/2);
  
  fill(color(20, 20, 200));
  rect(BUT_DW_X, BUT_DW_Y, BUT_W, BUT_H, 10);
  fill(0);
  text("DOWNLOAD", BUT_DW_X+BUT_W/2, BUT_DW_Y+BUT_H/2);


//  if (buf) {
//    //spans=split(ans,"$");
//    //ans = spans[0];
//    fill(0);
//    textSize(20);
//    textAlign(CENTER, CENTER);
//    text("Valor A0: " + aux, width/2, height/2+100);
//    val = float(aux);
//    float[] valAux = {PLOT_H-val*UNIT_Y, index*UNIT_X};
//    float[] acumAux = acum;
//    acum = concat(acumAux, valAux);
//    println(acum.length);

//    buf=false;
//  }
}

/// FUNCIONES ///
void mousePressed() {
  // Verifica si se hizo clic en el botón
  // START PRESSED
  if (mouseX > BUT_STA_X && mouseX< BUT_STA_X + BUT_W && mouseY > BUT_STA_Y && mouseY < BUT_STA_Y + BUT_H) {
    //port.write("start\n\r");
    run = true;
  }
  // STOP PRESSED
  if (mouseX > BUT_STO_X && mouseX< BUT_STO_X + BUT_W && mouseY > BUT_STO_Y && mouseY < BUT_STO_Y + BUT_H) {
    //port.write("stop\n\r");
    stop = true;
  }
  // DOWNLOAD PRESSED
  if (mouseX > BUT_DW_X && mouseX< BUT_DW_X + BUT_W && mouseY > BUT_DW_Y && mouseY < BUT_DW_Y + BUT_H) {
    //port.write("download\n\r");
  }
  // SET PRESSED
  if (mouseX > BUT_TS_X && mouseX< BUT_TS_X + BUT_W && mouseY > BUT_TS_Y && mouseY < BUT_TS_Y + BUT_H) {
    if(settingTs){
      if (int(tsAux)>=30){
        //port.write(tsAux+"\n\r");
        confTs = true;
        settingTs=false;
      }
    } 
    else {
      settingTs = true;
    }
  }
  if (mouseX > BUT_DEL_X && mouseX< BUT_DEL_X + BUT_DEL_W && mouseY > BUT_DEL_Y && mouseY < BUT_DEL_Y + BUT_DEL_H) {
    if(settingTs){
      tsAux="";
    } 
  }
}

void serialEvent(Serial p) {
  ans = p.readString();
  spans = split(ans, "$");
//  if (ask) {
//    ans = p.readString();
//    //print(ans);

//    int i0 = ans.indexOf("$");
//    int i1 = ans.indexOf(" ");
//    //println(str(i0),str(i1));
//    aux = ans.substring(i0+1, i1);
//    //print(aux);
//    index += 1;
//    //spans = split(ans, "$");
//    //print(spans[1]);
//    //val = split(spans[0], "\n\r");
//    //print(val[0]);
//    buf = true;
//  }
}

void keyReleased(){
  if (settingTs){
    tsAux += key;
  }
}
