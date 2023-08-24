# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 2
# Giuliano Palmisano

import machine
from machine import Timer, Pin, ADC

adc_pin = 26 # Corresponde a la entrada A0
adc_A0 = ADC(adc_pin)

def timer_int(timer):
    adc_A0_value = adc_A0.read_u16()
    print(adc_A0_value) 
    
if __name__=="__main__":
    timer_lect_A0 = Timer(mode=Timer.PERIODIC, period=1000, callback=timer_int)
    