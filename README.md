# Lobizon

Motor: Godot 4.3

## Objetos

### Puertas

Las puertas se encuentran en `scenes/rooms/doors`. Actualmente existen dos tipos:

1. Door With Trigger: se abren y cierran con una acción de input ("interact") cuando el personaje esta cerca de ellas.
1. Door with switch: se abren y cierran cuando se "activa" un switch (se coloca un "cuerpo" encima de la misma)

Para la puerta con switch, es necesario agregar un Area2D (el switch) a la puerta al momento de agregarla.
