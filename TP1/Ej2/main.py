# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 2
# Giuliano Palmisano

'''
Este programa lee e imprime en la consola el valor del conversor A/D cada 5 segundos.
'''

### LIBRERIAS ###
import machine
from machine import Timer, Pin, ADC

### SETUP ###
# Configuración de ADC
adc_pin = 26 # Corresponde a la entrada A0
adc_A0 = ADC(adc_pin)

# Función de interrupción del timer
def timer_int(timer):
    adc_A0_value = adc_A0.read_u16()
    print(adc_A0_value) 
    
# Configuración del timer
timer_lect_A0 = Timer(mode=Timer.PERIODIC, period=5000, callback=timer_int)
    