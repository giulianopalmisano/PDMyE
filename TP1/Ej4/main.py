# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 4
# Giuliano Palmisano

'''
Este programa realiza la lectura y almacenamiento de datos de los 3 convertidores A/D.
Puede configurarse para realizar la lectura y almacenamiento cada cierto tiempo (mode 0),
o para activar y desactivar la lectura mediante comandos (mode 1).
Mode 0. Una vez configurado el intervalo deseado, no puede cambiarse a menos que se reinicie el programa.
Mode 1. Mientras este activa la lectura, se toman y almacenan mediciones cada 200ms.
'''

### LIBRERIAS ###
import sys, uselect, machine, time
from machine import Pin, ADC, RTC, Timer

# Inicialización del reloj en tiempo real (RTC)
rtc = RTC()

# Configuración de los pines de entrada analógica
adc_A0_pin = 26 # Corresponde a la entrada A0
adc_A0 = ADC(adc_A0_pin)
adc_A1_pin = 27 # Corresponde a la entrada A1
adc_A1 = ADC(adc_A1_pin)
adc_A2_pin = 28 # Corresponde a la entrada A2
adc_A2 = ADC(adc_A2_pin)

# Apertura del archivo para almacenar datos
file = open('data/data.txt','w')
lect = False

# Función para la lectura de los canales ADC
def lectura_ADCs():
    # Lectura e impresión por consola de los datos
    adc_A0_value = adc_A0.read_u16()
    #volt = (3.3/65535)*adc_value
    print("Valor A0: " + str(adc_A0_value))
    adc_A1_value = adc_A1.read_u16()
    print("Valor A1: " + str(adc_A1_value))
    adc_A2_value = adc_A2.read_u16()
    print("Valor A2: " + str(adc_A2_value))
    
    # Obtencion y formateo de la fecha y hora
    date = rtc.datetime()
    date_str = str(date[2])+"/"+str(date[1])+"/"+str(date[0])+", "+str(date[4])+":"+str(date[5])+":"+str(date[6])
    
    # Escribir los valores en el archivo
    file.write(date_str + " A0: " + str(adc_A0_value) + "\n")
    file.write(date_str + " A1: " + str(adc_A1_value) + "\n")
    file.write(date_str + " A2: " + str(adc_A2_value) + "\n")
    
    file.flush()

# Función para la configuración del modo de lectura
def config_mode():
    global mode
    conf = False # Booleano que es verdadero una vez se elige el modo
    while not conf:
        init = input("Desea configurar un intervalo de lectura (y/n)? ")
        if init == "y":
            # Modo de lectura mediante interrupciones
            global per_seg
            mode = 0 
            per_seg = int(input("Ingrese el intervalo de lectura en segundos (minimo 30 seg): "))
            while per_seg < 30:
                per_seg = int(input("Ingrese un intervalo mayor a 30 segundos: "))
            print("Intervalo de "+ str(per_seg) +" seg configurado.")
            conf = True
        elif init == "n":
            # Modo de lectura mediante comandos
            mode = 1 
            print("La lectura entonces se ejecuta mediante comandos.\n")
            print("Ingrese 'r' para comenzar la lectura y 's' para detenerla. \n")
            conf = True
        else:
            print("Error. Ingrese 'y' si desea configurar un intervalo de lectura o 'n' en caso contrario.\n")

# Función para leer comandos desde la terminal
def read_com():
    return(sys.stdin.readline(1) if spoll.poll(0) else None)

# Función de interrupción de temporizador
def timer_int(timer):
    global lect
    lect = True

# Configuración inicial y programa principal
config_mode()
if mode == 0:
    per_ms = per_seg*1000
    timer_lect_A0 = Timer(mode=Timer.PERIODIC, period=per_ms, callback=timer_int)
    while True:
        if lect:
            lectura_ADCs()
            lect = False
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