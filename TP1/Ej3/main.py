# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 3
# Giuliano Palmisano

#import machine
from machine import Pin, ADC, RTC, UART

rtc = RTC()

uart = UART(1, baudrate=9600, tx=Pin(4), rx=Pin(5))
uart.init(bits=8, parity=None, stop=2)

adc_A0_pin = 26 # Corresponde a la entrada A0
adc_A0 = ADC(adc_A0_pin)
adc_A1_pin = 27 # Corresponde a la entrada A1
adc_A1 = ADC(adc_A1_pin)
adc_A2_pin = 28 # Corresponde a la entrada A2
adc_A2 = ADC(adc_A2_pin)

file = open("data/data.txt", "w")

def lectura_ADCs():
    adc_A0_value = adc_A0.read_u16()
    print("Valor A0" + adc_A0_value)
    adc_A1_value = adc_A1.read_u16()
    print("Valor A1" + adc_A1_value)
    adc_A2_value = adc_A2.read_u16()
    print("Valor A2" + adc_A2_value)
    
    file.write(rtc.datetime() + " A0: " + str(adc_A0_value) + "\n")
    file.write(rtc.datetime() + " A1: " + str(adc_A1_value) + "\n")
    file.write(rtc.datetime() + " A2: " + str(adc_A2_value) + "\n")
    
    file.flush()

while True:
    if uart.any():
        data = uart.read()
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