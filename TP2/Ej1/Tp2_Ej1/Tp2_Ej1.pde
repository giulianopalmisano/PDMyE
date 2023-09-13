/* 
Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
Trabajo práctico 2
Ejercicio 1
Giuliano Palmisano
*/

/* 
El programa establece un fondo gris sobre el que se desplaza una línea blanca horizontal de 400px de ancho.
*/

int WIN_W = 640;
int WIN_H = 480;
int LINE_W = 400;

void setup() {
  size(640, 480); // Establece el tamaño de la ventana
}

// Posición inicial de la línea
int y = WIN_H; 
int x0 = (WIN_W-LINE_W)/2;

void draw() {
  background(150); // Establece el fondo gris
  
  // Dibuja la línea en la posición actual
  stroke(255); // Color de la línea (blanco)
  line(x0, y, x0+LINE_W, y); // Dibuja la línea horizontal

  // Actualiza la posición de la línea para el próximo frame
  y = y - 1; // Desplaza la línea hacia arriba

  // Si la línea llega a la parte superior de la ventana, vuelve a la posición inicial
  if (y < 0) {
    y = 480;
  }
}
