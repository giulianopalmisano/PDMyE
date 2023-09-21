/* 
Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
Trabajo práctico 2
Ejercicio 2
Giuliano Palmisano
*/

/* 
Al clickear en el boton "Cambiar fondo" se alterna entre un fondo negro y uno blanco.
*/

int but_h = 40;
int but_y = 480/2-but_h/2;
int but_w = 120;
int but_x = 640/2-but_w/2;

int val = 0;

void setup() {
  size(640, 480); // Establece el tamaño de la ventana
  background(val);
}

void draw(){
  background(val);
  // Creo boton
  fill(color(150,150,150));
  rect(but_x, but_y, but_w, but_h, 10);
  fill(0);
  textSize(16);
  textAlign(CENTER,CENTER);
  text("Cambiar fondo", width/2, height/2);
  if (mouseX > but_x && mouseX< but_x + but_w && mouseY > but_y && mouseY < but_y + but_h){
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
}

// Al clickear el boton se alterna el fondo.
void mouseClicked(){
  if (mouseX > but_x && mouseX< but_x + but_w && mouseY > but_y && mouseY < but_y + but_h){
    if (val==0){
      val = 255;
    } else {
      val = 0;
    }
  }
}
