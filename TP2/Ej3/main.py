# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 2
# Ejercicio 3
# Giuliano Palmisano

'''
Este programa recibe comandos a través del puerto serie
para manejar el LED autocontenido de la Raspberry Pi Pico W.
COMANDOS:
    -'on' para prenderlo.
    -'off' para apagarlo.
'''

### LIBRERIAS ###
from machine import Pin
import time

### FUNCIONES ###
# Función para prender o apagar el LED según el comando
def procesar_com(cmd):
    if cmd == "on":
        print("on")
        Led.on()
    if cmd == "off":
        print("off")
        Led.off()
    
### SETUP ###
Led=Pin("LED",Pin.OUT)
# Encendido del LED para identificar inciación del programa
Led.on()
time.sleep(3)
Led.off()

### MAIN LOOP ###
# Se espera hasta que llegue algún comando
while True:
    cmd=input(">:")
    procesar_com(cmd)    
    