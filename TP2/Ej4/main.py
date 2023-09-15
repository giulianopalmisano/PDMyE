# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 2
# Ejercicio 4
# Giuliano Palmisano

'''
Este programa realiza la lectura y envío a través
del puerto serie del valor del canal analógico A0.
El comando para leer y enviar el dato es 'read'.
'''

### LIBRERIAS ###
from machine import Pin, ADC
import time

### PARAMETROS ###
CONV_ADC = 3.3/65535 # Factor de conversión del ADC
ADC0_PIN = 26 # Pin del A0

### SETUP ###
adc_A0 = ADC(ADC0_PIN) # Configuración del canal A0

Led=Pin("LED",Pin.OUT)
# Encendido del LED para identificar inciación del programa
Led.on()
time.sleep(3)
Led.off()

### FUNCIONES ###
# Función para la lectura y envío del valor del canal A0
def lectura_ADC():
    adc_A0_value = CONV_ADC*adc_A0.read_u16()
    print("$"+str(adc_A0_value)+" V")       

# Función para analizar el comando recibido
def procesar_com(com):
    if com == "read":
        lectura_ADC()       
        
### MAIN LOOP ###
# Espera comandos 
while True:
    com = input()
    procesar_com(com)