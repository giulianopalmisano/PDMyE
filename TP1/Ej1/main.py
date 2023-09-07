# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 1
# Giuliano Palmisano

'''
Este programa hace parpadear un LED cada 1 seg.
'''

### LIBRERIAS ###
from machine import Timer, Pin

### SETUP ###
# Configuración del pin del LED
led = Pin(25, mode=Pin.OUT) 

# Función de interrupción del timer
def timer_int(timer):
    led.toggle() # Cambio de estado del LED
    
# Configuración del timer
timer_led = machine.Timer(mode=Timer.PERIODIC, period=1000, callback=timer_int)
