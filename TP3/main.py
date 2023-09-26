# Programación de dispositivos móviles y embebidos - 2do cuatrimestre 2023 
# Trabajo práctico 3
# Giuliano Palmisano

### LIBRERIAS ###
import network   # handles connecting to WiFi
import urequests # handles making and servicing network requests
import time
import socket
from machine import ADC, Timer

### VARIABLES ###
T_MUESTREO_MS = 15000   # Configura el tiempo cada cuanto se envia la temperatura
SSID =  "galvez casa" # Datos de la red utilizada
PASSWORD = "galvez104"
SV_ADDRESS = ('190.124.196.46', 40002)   # Dirección IP y puerto del server

### FUNCIONES ###
# Funcion para establecer la conexion WiFi
def connectWifi():
    global wlan
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(SSID, PASSWORD)
    while wlan.isconnected() == False:
        print('Waiting for connection...')
        time.sleep(1)
        
# Funcion para conectarse al servidor
def connectServer():
    global connection
    connection = socket.socket()
    connection.connect(SV_ADDRESS)
    
# Funcion para medir la temperatura
def tempCPU():
    adc = machine.ADC(4) 
    ADC_voltage = adc.read_u16() * (3.3 / (65536))   # Lectura y conversion del valor a voltaje
    tempC = 27 - (ADC_voltage - 0.706)/0.001721   # Conversion del voltaje a grados celsius
    return tempC

# Funcion para enviar los datos
def sendTemp(timer):
    connectWifi()   # Conectar al wifi
    connectServer()   # Conectar al servidor
    data = str(tempCPU())+"\n"   # Sensar la temperatura
    connection.sendall(data.encode())   # Enviar la informacion
    connection.close()    # Cerrar la conexion
    wlan.active(False)   # Apagar el modulo
    
### SETUP ###
TIMER_TEMP = Timer(period=T_MUESTREO_MS, mode=Timer.PERIODIC, callback=sendTemp)