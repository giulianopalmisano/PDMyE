# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 1
# Giuliano Palmisano

### LIBRERIAS ###
from machine import Timer, Pin

# Configuración del pin del LED
led = Pin(25, mode=Pin.OUT) 

# Función de interrupción del timer
def timer_int(timer):
    led.value(not led.value()) # Cambio de estado del LED
    
# Configuración del timer
timer_led = machine.Timer(mode=Timer.PERIODIC, period=1000, callback=timer_int)
