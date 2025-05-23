from machine import Pin, PWM, ADC, time_pulse_us
import dht
import time
import network
import urequests
import ujson
from Wifi_lib import wifi_init  # Usa tu propia librería para conectar al WiFi

# ------------------ CONFIGURACIÓN WIFI ------------------
wifi_init()

# Pines de conexión
pin_dht = 4       # DHT22
pin_humedad = 34  # ADC para humedad del suelo
trig_pin = 5      # Trigger del ultrasónico
echo_pin = 18     # Echo del ultrasónico

# Configurar sensores
dht_sensor = dht.DHT22(Pin(pin_dht))
humedad_adc = ADC(Pin(pin_humedad))
humedad_adc.atten(ADC.ATTN_11DB)  # Rango 0-3.3V
trig = Pin(trig_pin, Pin.OUT)
echo = Pin(echo_pin, Pin.IN)

SOUND_SPEED = 0.034  # cm/us

def leer_dht22():
    dht_sensor.measure()
    temperatura = dht_sensor.temperature()
    humedad_aire = dht_sensor.humidity()
    return temperatura, humedad_aire

def leer_humedad_tierra():
    valor = humedad_adc.read()  # 0 a 4095
    porcentaje = 100 - ((valor / 4095) * 100)
    return max(0, min(porcentaje, 100))  # Limita entre 0 y 100

def leer_agua():
    trig.value(0)
    time.sleep_us(2)
    trig.value(1)
    time.sleep_us(10)
    trig.value(0)
    duration = time_pulse_us(echo, 1, 30000)  # Timeout 30ms
    distancia_cm = duration * SOUND_SPEED / 2
    return distancia_cm

def enviar_datos(temperatura, humedad_tierra, humedad_aire, agua, id_planta):
    url = "http://192.168.56.1/feria.php?accion=insertar"
    headers = {'Content-Type': 'application/json'}
    data = {
        "temperatura": temperatura,
        "humedad_tierra": humedad_tierra,
        "humedad_aire": humedad_aire,
        "agua": agua,
        "id_planta": id_planta
    }
    try:
        response = urequests.post(url, data=ujson.dumps(data), headers=headers)
        print("Respuesta del servidor:", response.text)
        response.close()
    except Exception as e:
        print("Error al enviar datos:", e)

# ------------------ BUCLE PRINCIPAL ------------------
id_planta = 1

while True:
    try:
        temperatura, humedad_aire = leer_dht22()
        humedad_tierra = leer_humedad_tierra()
        agua = leer_agua()

        print("Temperatura: {:.2f}°C | Humedad Tierra: {:.2f}% | Humedad Aire: {:.2f}% | Agua: {:.2f}cm".format(
            temperatura, humedad_tierra, humedad_aire, agua))

        enviar_datos(temperatura, humedad_tierra, humedad_aire, agua, id_planta)

    except OSError as e:
        print("Error al leer sensores:", e)

    time.sleep(5)  # Cada 5 segundos
