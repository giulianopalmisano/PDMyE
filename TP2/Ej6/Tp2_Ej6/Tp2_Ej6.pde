// Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023
// Trabajo práctico 2
// Ejercicio 6
// Giuliano Palmisano

/*
Este programa implementa una interfaz para controlar un adquisidor de datos.

CONFIGURACIÓN DEL TIEMPO DE MUESTREO:
El tiempo de muestreo debe configurarse al comienzo mediante los siguientes pasos:
  1. Click en el botón "Set Ts".
  2. Ingresar mediante el teclado el tiempo deseado en segundos. Debe ser mayor que 30seg.
  3. En caso de precisar borrar lo ingresado, presionar el botón rojo que contiene una cruz blanca,
  e ingresar el número deseado.
  4. Click en el botón "Confirm".
  5. Si el valor es menor a 30s, el botón "Confirm" no surtirá efecto.
  
Para configurar la hora de la Raspberry Pi Pico: click en el botón "SET TIME".
Para iniciar la lectura de datos: click en el botón "START".
Para detener la lectura de datos: click en el botón "STOP".
Para descargar los datos adquiridos:
  1. Debe estar pausada la lectura.
  2. Click en el botón "DOWNLOAD".
 */

/// LIBRERIAS ///
import processing.serial.*;

/// VARIABLES ///
Serial port;
// Medidas de la ventana
int WIN_H = 480;
int WIN_W = 640;

boolean run = false;
boolean stop = true;
boolean settingTs = false;
boolean confTs = false;
boolean confDate = false;
boolean downloading = false;
boolean finish = false;

String tsAux="";
String ans, aux;
StringList lines;

// Variables para layout
int BUT_H = 40;
int BUT_W = 120;
int BUT_STA_Y = WIN_H/16;
int BUT_STA_X = WIN_W/5-BUT_W/2;
int BUT_STO_Y = WIN_H/16+5*BUT_H/4;
int BUT_STO_X = WIN_W/5-BUT_W/2;
int BUT_DW_Y = WIN_H/16+5*BUT_H/2;
int BUT_DW_X = WIN_W/5-BUT_W/2;
int BUT_HS_X = WIN_W/5-BUT_W/2;
int BUT_HS_Y = WIN_H/16+15*BUT_H/4;
int CONT_TS_W = WIN_W/2;
int CONT_TS_H = WIN_H/4;
int CONT_TS_X = 2*WIN_W/5;
int CONT_TS_Y = WIN_H/16+(BUT_HS_Y+BUT_H-BUT_STA_Y-CONT_TS_H)/2;
int BUT_TS_X = CONT_TS_X+CONT_TS_W/2-CONT_TS_W/6;
int BUT_TS_Y = CONT_TS_Y+CONT_TS_H/2;
int BUT_DEL_W = CONT_TS_W/15;
int BUT_DEL_H = CONT_TS_W/15;
int BUT_DEL_X = CONT_TS_X+CONT_TS_W-BUT_DEL_W-5;
int BUT_DEL_Y = CONT_TS_Y+CONT_TS_H/4-BUT_DEL_H/2; 
int CONT_DW_W = WIN_W-4;
int CONT_DW_H = WIN_H/2-4;
int CONT_DW_X = 2;
int CONT_DW_Y = WIN_H/2;

/// SETUP ///
void settings(){
  // Configura la ventana
  size(WIN_W, WIN_H);
}

void setup() {
  String portName = "COM4";

  // Abre el puerto serie
  port = new Serial(this, portName, 57600);
  port.bufferUntil(37); // 37 ASCII de % - 86 ASCII de V
  
  lines = new StringList();

}

/// MAIN LOOP ///
void draw() {
  background(40);

  // Entorno para configuración del tiempo de muestreo
  fill(20);
  stroke(255);
  rect(CONT_TS_X, CONT_TS_Y, CONT_TS_W, CONT_TS_H,10);
  fill(255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Sampling time [sec] (>30s): " + tsAux, CONT_TS_X+CONT_TS_W/2, CONT_TS_Y+CONT_TS_H/4);
  //fill(40);
  //rect(BUT_TS_X, BUT_TS_Y, BUT_W, BUT_H,10);//CONT_TS_W/3, CONT_TS_H/3);
  //fill(255);
  if (settingTs){ // Mientras se ingresa el Ts
    fill(20);
    rect(BUT_TS_X, BUT_TS_Y, BUT_W, BUT_H,10);//CONT_TS_W/3, CONT_TS_H/3);
    fill(255);
    text("Confirm", BUT_TS_X+BUT_W/2,BUT_TS_Y+BUT_H/2);
    // Boton para borrar el Ts que se está ingresando
    stroke(color(255,0,0));
    fill(color(255,0,0));
    rect(BUT_DEL_X, BUT_DEL_Y, BUT_DEL_W, BUT_DEL_H);
    stroke(255);
    strokeWeight(2);
    line(BUT_DEL_X, BUT_DEL_Y,BUT_DEL_X+BUT_DEL_W, BUT_DEL_Y+BUT_DEL_H);
    line(BUT_DEL_X, BUT_DEL_Y+BUT_DEL_H,BUT_DEL_X+BUT_DEL_W, BUT_DEL_Y);
    strokeWeight(1);
  }
  else if (confTs){  // Una vez que se ingresó el Ts 
    fill(20);
    noStroke();
    rect(BUT_TS_X, BUT_TS_Y, BUT_W, BUT_H,10);
    fill(255);
    text("Confirmed!", BUT_TS_X+BUT_W/2,BUT_TS_Y+BUT_H/2);
  }
  else{  // Antes de ingresar Ts
    fill(20);
    rect(BUT_TS_X, BUT_TS_Y, BUT_W, BUT_H,10);//CONT_TS_W/3, CONT_TS_H/3);
    fill(255);
    text("Set Ts", BUT_TS_X+BUT_W/2,BUT_TS_Y+BUT_H/2);
  }

  // Dibujo boton STOP
  //fill(confTs ? color(200, 60, 60) : 40);
  fill(40);
  stroke((stop || !confTs) ? 150 : 255);
  rect(BUT_STO_X, BUT_STO_Y, BUT_W, BUT_H, 10);
  fill((stop || !confTs) ? 150 : 255);
  text("STOP", BUT_STO_X+BUT_W/2, BUT_STO_Y+BUT_H/2);
  
  // Dibujo boton START
  //fill(confTs ? color(80, 200, 80) : 40);
  fill(40);
  stroke((run || !confTs) ? 150 : 255);
  rect(BUT_STA_X, BUT_STA_Y, BUT_W, BUT_H, 10);
  fill((run || !confTs) ? 150 : 255);
  text("START", BUT_STA_X+BUT_W/2, BUT_STA_Y+BUT_H/2);
  
  // Dibujo boton DOWNLOAD
  //fill(confTs ? color(80, 80, 200) : 40);
  fill(40);
  stroke((run || !confTs) ? 150 : 255);
  rect(BUT_DW_X, BUT_DW_Y, BUT_W, BUT_H, 10);
  fill((run || !confTs) ? 150 : 255);
  text("DOWNLOAD", BUT_DW_X+BUT_W/2, BUT_DW_Y+BUT_H/2);
  
  // Dibujo boton SET TIME
  //fill(confTs ? color(200, 80, 200) : 40);
  fill(40);
  stroke((!confTs || confDate) ? 150 : 255);
  rect(BUT_HS_X, BUT_HS_Y, BUT_W, BUT_H, 10);
  fill((!confTs || confDate) ? 150 : 255);
  text(confDate ? "SET TIME" : "DONE!", BUT_HS_X+BUT_W/2, BUT_HS_Y+BUT_H/2);
  
  // Área para mostrar archivo via download.
  fill(255);
  rect(CONT_DW_X, CONT_DW_Y, CONT_DW_W, CONT_DW_H);
  // Si ya se recibieron todas las lineas del archivo
  fill(0);
  textAlign(LEFT,TOP);
  if (finish){
    for (int i=0; i<lines.size();i++){
      text(lines.get(i), CONT_DW_X+2,CONT_DW_Y+16*i+2);
    }
  }
}

/// FUNCIONES ///
void mousePressed() {
  // Verifica si se hizo clic en algún botón
  // START PRESSED
  if (mouseX > BUT_STA_X && mouseX< BUT_STA_X + BUT_W && mouseY > BUT_STA_Y && mouseY < BUT_STA_Y + BUT_H) {
    port.write("start\n\r");
  }
  // STOP PRESSED
  if (mouseX > BUT_STO_X && mouseX< BUT_STO_X + BUT_W && mouseY > BUT_STO_Y && mouseY < BUT_STO_Y + BUT_H) {
    port.write("stop\n\r");
  }
  // DOWNLOAD PRESSED
  if (mouseX > BUT_DW_X && mouseX< BUT_DW_X + BUT_W && mouseY > BUT_DW_Y && mouseY < BUT_DW_Y + BUT_H) {
    port.write("download\n\r");
  }
  // SET PRESSED
  if (mouseX > BUT_TS_X && mouseX< BUT_TS_X + BUT_W && mouseY > BUT_TS_Y && mouseY < BUT_TS_Y + BUT_H) {
    if(settingTs){
      if (int(tsAux)>=30){
        port.write(tsAux+"\n\r");
      }
    } 
    else {
      settingTs = true;
    }
  }
  // DEL PRESSED
  if (mouseX > BUT_DEL_X && mouseX< BUT_DEL_X + BUT_DEL_W && mouseY > BUT_DEL_Y && mouseY < BUT_DEL_Y + BUT_DEL_H) {
    if(settingTs){
      tsAux="";
    } 
  }
  // SET TIME PRESSED
  if (mouseX > BUT_HS_X && mouseX< BUT_HS_X + BUT_W && mouseY > BUT_HS_Y && mouseY < BUT_HS_Y + BUT_H) {
    String date = str(year())+" "+str(month())+" "+str(day())+" 3 "+str(hour())+" "+str(minute())+" "+str(second()); // 
    port.write(date + "\n\r");
    println(date);
  }
}

// Lectura del puerto serie
void serialEvent(Serial p) {
  ans = p.readString();
  // Busco primer y ultimo caracter del mensaje
  int i0 = ans.indexOf("$");
  int i1 = ans.indexOf("%");
  // Separo el mensaje
  aux = ans.substring(i0+1, i1);
  println(aux);
  // Proceso el mensaje
  switch (aux){
    case "finish":
      finish = true;
      downloading = false;   
      println("1");
      break;
    case "ok-sta":  // Inicio de lectura
      run = true;
      stop = false;
      println("2");
      break;
    case "ok-sto":  // Lectura en pausa
      run = false;
      stop = true;
      println("3");
      break;
    case "ok-dw":  // Inicio de descarga
      downloading = true;
      finish = false;
      println("4");
      break;
    case "ok-ts":  // Tiempo de sampleo configurado
      confTs = true;
      settingTs = false;
      println("5");
      break;
    case "ok-tim":  // Fecha configurada
      confDate = true;
      println("6");
    default:  
      if (downloading){  // Información del datalogger
        lines.append(aux);
        println(aux);
      }
      break;
  }
}

// Función para tomar las teclas presionadas para ingresar el tiempo de muestreo
void keyReleased(){
  if (settingTs){
    tsAux += key;
  }
}
