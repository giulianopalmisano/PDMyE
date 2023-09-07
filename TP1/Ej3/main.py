# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 1
# Ejercicio 3
# Giuliano Palmisano

'''
Este programa realiza la lectura y almacenamiento de datos de los 3 convertidores A/D.
Para iniciar la lectura, se debe ingresar el comando 'start' por la terminal.
Para detener la lectura, se debe ingresar el comando 'stop' por la terminal.
Mientras este activa la lectura, se toman y almacenan mediciones cada 5 seg.
'''

### LIBRERIAS ###
from machine import Timer, Pin, ADC, RTC

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

# Creación del timer
timer_lect = Timer(-1)

lect = False # Booleano para controlar la lectura
writing = False # Booleano para controlar la escritura del archivo

### FUNCIONES ###
# Función para la lectura de los canales ADC
def lectura_ADCs(timer):
    global writing
    if writing:
        print("Lectura fallida.")
    else:
        # Lectura e impresión por consola de los datos
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
    global lect, timer_lect, T_MUESTREO_MS
    if fcom == "start":
        lect = True
        timer_lect.init(period=T_MUESTREO_MS, mode=Timer.PERIODIC, callback=lectura_ADCs) # Configuración del timer
        print("Comenzando lectura...")
    elif fcom == "stop":
        lect = False
        timer_lect.deinit() # Se deshabilita el timer
        print("Lectura pausada.")
        print("Ingrese 'start' para reiniciarla.")
    else:
        print("Comando desconocido.\n")
        print("Ingrese 'start' si desea iniciar la lectura.\n")
        print("Ingrese 'stop' si desea detener la lectura.\n")
        
print("Ingrese 'start' para inciar la lectura y 'stop' para detenerla.")

### MAIN LOOP ###
# Espera comandos del usuario
while True:
    com = input(">:")
    procesar_com(com)