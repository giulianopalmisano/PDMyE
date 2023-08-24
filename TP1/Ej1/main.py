# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 1
# Giuliano Palmisano

import machine
from machine import Timer, Pin

led = Pin(25, mode=Pin.OUT) # Definicion del pin del LED

def timer_int(timer):
    led.value(not led.value()) # Cambio de estado del LED
    
while True:
    timer_led = Timer(mode=Timer.PERIODIC, period=1000, callback=timer_int)
