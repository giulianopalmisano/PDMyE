# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 1
# Giuliano Palmisano

import machine
from machine import Timer, Pin

led = Pin(25, mode=Pin.OUT)

def timer_int(timer):
    led.value(not led.value())
    
while True:
    timer_led = Timer(mode=Timer.PERIODIC, period=1000, callback=timer_int)
