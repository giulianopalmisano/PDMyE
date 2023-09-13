# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 2
# Ejercicio 3
# Giuliano Palmisano

from machine import UART, Pin

### SETUP ###

uart0 = UART(0, baudrate=9600, tx=Pin(16), rx=Pin(17))
Led = Pin(25,Pin.OUT)

### MAIN LOOP ###
while True:
    if uart0.any() != 0:
        instr = uart0.readline()
        if instr == "ON":
            Led.on()
        elif instr == "OFF":
            Led.off()
        