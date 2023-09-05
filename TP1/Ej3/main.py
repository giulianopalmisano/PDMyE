# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 3
# Giuliano Palmisano

'''
Este programa realiza la lectura y almacenamiento de datos de los 3 convertidores A/D.
Para iniciar la lectura, se debe ingresar el comando 'r' por la terminal.
Para detener la lectura, se debe ingresar el comando 's' por la terminal.
Mientras este activa la lectura, se toman y almacenan mediciones cada 200ms.
'''

### LIBRERIAS ###
import sys, uselect, machine, time
from machine import Pin, ADC, RTC

# Inicialización del reloj en tiempo real (RTC)
rtc = RTC()

# Configurar un objeto de selección (poll) para monitorear la entrada estándar (terminal)
spoll = uselect.poll()
spoll.register(sys.stdin, uselect.POLLIN)

# Configuración de los pines de entrada analógica
adc_A0_pin = 26 # Corresponde a la entrada A0
adc_A0 = ADC(adc_A0_pin)
adc_A1_pin = 27 # Corresponde a la entrada A1
adc_A1 = ADC(adc_A1_pin)
adc_A2_pin = 28 # Corresponde a la entrada A2
adc_A2 = ADC(adc_A2_pin)

# Apertura del archivo para almacenar datos
file = open('data/data.txt','w')

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

# Función para leer comandos desde la terminal
def read_com():
    return(sys.stdin.readline(1) if spoll.poll(0) else None)

print("Ingrese 'r' para comenzar la lectura y 's' para detenerla. \n")
lect = False # Flag para controlar la lectura

# Main loop
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