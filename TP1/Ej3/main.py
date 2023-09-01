# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 3
# Giuliano Palmisano

#import machine
import sys, uselect
from machine import Pin, ADC, RTC

rtc = RTC()

spoll = uselect.poll()
spoll.register(sys.stdin, uselect.POLLIN)

adc_A0_pin = 26 # Corresponde a la entrada A0
adc_A0 = ADC(adc_A0_pin)
adc_A1_pin = 27 # Corresponde a la entrada A1
adc_A1 = ADC(adc_A1_pin)
adc_A2_pin = 28 # Corresponde a la entrada A2
adc_A2 = ADC(adc_A2_pin)

file = open("data/data.txt", "w")

def lectura_ADCs():
    adc_A0_value = adc_A0.read_u16()
    #volt = (3.3/65535)*adc_value
    print("Valor A0" + adc_A0_value)
    adc_A1_value = adc_A1.read_u16()
    print("Valor A1" + adc_A1_value)
    adc_A2_value = adc_A2.read_u16()
    print("Valor A2" + adc_A2_value)
    
    file.write(rtc.datetime() + " A0: " + str(adc_A0_value) + "\n")
    file.write(rtc.datetime() + " A1: " + str(adc_A1_value) + "\n")
    file.write(rtc.datetime() + " A2: " + str(adc_A2_value) + "\n")
    
    file.flush()

print("Ingrese 'r' para comenzar la lectura y 's' para detenerla. \n")
lect = False

while True:
    if spoll.poll(0):
        data = sys.stdin.read()
        if data == "r":
            lect = True
            lectura_ADCs()
        elif data == "s":
            lect = False
            print("Lectura detenida.\n Presione 'r' para registrar los datos.")
        else:
            print("Comando inexistente.\n Ingrese 'r' para comenzar la lectura o 's' para detenerla.")
    elif lect:
        lectura_ADCs()