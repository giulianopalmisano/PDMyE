# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 2
# Ejercicio 6
# Giuliano Palmisano

'''
Este programa realiza la lectura y almacenamiento de datos de los 3 convertidores A/D.
Para iniciar la lectura, se debe ingresar el comando 'start' por la terminal.
Para detener la lectura, se debe ingresar el comando 'stop' por la terminal.
Para descargar los datos, se debe ingresar el comando 'download' por la terminal.
Mientras este activa la lectura, se toman y almacenan mediciones con un intervalo de tiempo configurable.
Los comandos enviados comienzan con "$" y terminan con "%".
'''

### LIBRERIAS ###
from machine import Timer, Pin, ADC, RTC
import time

### PARAMETROS ###
CONV_ADC = 3.3/65535 # Factor de converision del ADC
T_MUESTREO_MS = 5000 # Tiempo de muestreo y almacenamiento
# Pines de los ADC
ADC0_PIN = 26
ADC1_PIN = 27
ADC2_PIN = 28

### SETUP ###
# Inicialización del reloj en tiempo real (RTC)
rtc = RTC()

# Configuración de los pines de entrada analógica
adc_A0 = ADC(ADC0_PIN)
adc_A1 = ADC(ADC1_PIN)
adc_A2 = ADC(ADC2_PIN)

# Apertura del archivo para almacenar datos
file = open('data/data.txt','w')

# Creación del timer (se configura una vez iniciada la lectura)
timer_lect = Timer(-1)

lect = False # Booleano para controlar la lectura
writing = False # Booleano para controlar la escritura del archivo

### FUNCIONES ###
# Función para la lectura de los canales ADC
def lectura_ADCs(timer):
    global writing, lect, file
    # Compruebo que esté activada la lectura y no interrumpir el proceso de escritura
    if lect:
        if writing:
            pass
        else:
            # Lectura de los datos
            adc_A0_value = CONV_ADC*adc_A0.read_u16()
            adc_A1_value = CONV_ADC*adc_A1.read_u16()
            adc_A2_value = CONV_ADC*adc_A2.read_u16()
            
            # Obtencion y formateo de la fecha y hora
            date = rtc.datetime()
            date_str = str(date[2])+"/"+str(date[1])+"/"+str(date[0])+", "+str(date[4])+":"+str(date[5])+":"+str(date[6])
            
            # Escribir los valores en el archivo
            writing = True
            file.write(date_str + " A0: " + str(adc_A0_value) + "\n")
            file.write(date_str + " A1: " + str(adc_A1_value) + "\n")
            file.write(date_str + " A2: " + str(adc_A2_value) + "\n")
            file.flush()
            writing = False

# Función para analizar el comando introducido
def procesar_com(fcom):
    global lect, timer_lect, T_MUESTREO_MS, rtc
    if fcom == "start":
        lect = True
        timer_lect.init(period=T_MUESTREO_MS, mode=Timer.PERIODIC, callback=lectura_ADCs) # Configuración del timer
        print("$ok-sta%")
    elif fcom == "stop":
        lect = False
        timer_lect.deinit() # Se deshabilita el timer
        print("$ok-sto%")
    elif fcom == "download":
        # Se abre el archivo en modo lectura y se muestra linea por linea
        print("$ok-dw%")
        with open('data/data.txt', 'r') as data_file:
            for line in data_file:
                print("$"+line.strip()+"%")
        print("$finish%")
    else:
        date = tuple(map(int, fcom.split(" "))) + (0,)
        rtc.datetime(date)
        print("$ok-tim%")

# Función para configurar el intervalo de muestreo
def config():
    t_seg = int(input())
    return t_seg*1000

### INICIO DEL PROGRAMA ###
Led=Pin("LED",Pin.OUT)
# Encendido del LED para identificar inciación del programa
Led.on()
time.sleep(1)
Led.off()
# Configuración del intervalo de muestreo
T_MUESTREO_MS = config()
print("$ok-ts%")

### MAIN LOOP ###
# Se esperan los comandos del usuario
while True:
    com = input(">:")
    procesar_com(com)
file.close()