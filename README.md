# Proyecto Godot: Moonveil

## Funcionamiento

Este proyecto es un juego tipo Hollow Knight hecho en Godot 4.4.1. Para jugar:

- **Escena principal:** `mainlevel.tscn` (abre y ejecuta esta escena para iniciar el juego)
- **Controles:**
  - **WASD:** Mover al personaje
  - **Shift:** Dash
  - **Click Izquierdo:** Atacar

Al iniciar el juego, el jugador aparecerá en el nivel principal y podrá moverse, saltar, atacar y esquivar enemigos como la mantis.

## Estructura
- `scenes/`: Contiene todas las escenas del juego, incluyendo enemigos, jugador y niveles.
- `assets/`: Sprites, sonidos y recursos visuales.

## Notas
- El sistema de daño y colisiones está optimizado para que el jugador reciba daño solo cuando el hitbox de un enemigo colisiona con su hurtbox.
- Si tienes problemas con colisiones, revisa las capas y máscaras de los nodos `AttackHitbox` y `Hurtbox`.
- De momento no se implementaron sonidos es para un futuro 

Realizado por :
-
- Adrián Coello 
- Ariana Cordero
