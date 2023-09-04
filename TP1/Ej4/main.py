# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 4
# Giuliano Palmisano

import sys, uselect, machine, time
from machine import Pin, ADC, RTC, Timer

rtc = RTC()

adc_A0_pin = 26 # Corresponde a la entrada A0
adc_A0 = ADC(adc_A0_pin)
adc_A1_pin = 27 # Corresponde a la entrada A1
adc_A1 = ADC(adc_A1_pin)
adc_A2_pin = 28 # Corresponde a la entrada A2
adc_A2 = ADC(adc_A2_pin)

file = open('data/data.txt','w')
lect = False

def lectura_ADCs():
    adc_A0_value = adc_A0.read_u16()
    #volt = (3.3/65535)*adc_value
    print("Valor A0: " + str(adc_A0_value))
    adc_A1_value = adc_A1.read_u16()
    print("Valor A1: " + str(adc_A1_value))
    adc_A2_value = adc_A2.read_u16()
    print("Valor A2: " + str(adc_A2_value))
    
    date = rtc.datetime()
    date_str = str(date[2])+"/"+str(date[1])+"/"+str(date[0])+", "+str(date[4])+":"+str(date[5])+":"+str(date[6])
    
    file.write(date_str + " A0: " + str(adc_A0_value) + "\n")
    file.write(date_str + " A1: " + str(adc_A1_value) + "\n")
    file.write(date_str + " A2: " + str(adc_A2_value) + "\n")
    
    file.flush()

def config():
    global mode
    conf = False
    while not conf:
        init = input("Desea configurar un intervalo de lectura (y/n)? ")
        if init == "y":
            global per_seg
            mode = 0 #Lectura mediante interrupciones
            per_seg = int(input("Ingrese el intervalo de lectura en segundos (minimo 30 seg): "))
            while per_seg < 30:
                per_seg = int(input("Ingrese un intervalo mayor a 30 segundos: "))
            print("Intervalo de "+ str(per_seg) +" seg configurado.")
            conf = True
        elif init == "n":
            mode = 1 #Lectura mediante comandos
            print("La lectura entonces se ejecuta mediante comandos.\n")
            print("Ingrese 'r' para comenzar la lectura y 's' para detenerla. \n")
            conf = True
        else:
            print("Error. Ingrese 'y' si desea configurar un intervalo de lectura o 'n' en caso contrario.\n")

def read_com():
    return(sys.stdin.readline(1) if spoll.poll(0) else None)

def timer_int(timer):
    lectura_ADCs()
    
#if __name__ == "__main__":
config()
if mode == 0:
#     per_ms = per_seg*1000
#     timer_lect_A0 = Timer(mode=Timer.PERIODIC, period=per_ms, callback=timer_int)
    while True:
        lectura_ADCs()
        time.sleep(per_seg)
elif mode == 1:
    spoll = uselect.poll()
    spoll.register(sys.stdin, uselect.POLLIN)
    while True:
        data = read_com()
        if data != None:
            if data == "r":
                lect = True
                print("Comenzando lectura...")
            elif data == "s":
                lect = False
                print("Lectura detenida.\nPresione 'r' para registrar los datos.")
            else:
                print("Comando inexistente.\nIngrese 'r' para comenzar la lectura o 's' para detenerla.")
        if lect:
            lectura_ADCs()
        time.sleep_ms(200)
file.close()