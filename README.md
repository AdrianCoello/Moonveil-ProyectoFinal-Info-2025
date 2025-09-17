#  Proyecto Final – **Moonveil**

| <img width="800" height="228" alt="image" src="https://github.com/user-attachments/assets/f3c93103-4f59-4402-8f17-83596beff010" />|
---

**Materia:** Infografía 2025
**Fecha de Presentación:** 17 de septiembre 2025  

---

## 1.  

| **Proyecto** | **Moonveil** |
|--------------|--------------|
| **Integrantes** | Adrián Coello – 77258  <br> Ariana Cordero – 77095 |
| **Motor** | Godot 4.4.1 |
| **Inspiración** | *Hollow Knight* y *Fez Game* |
| **Docente** | JOSE EDUARDO LARUTA ESPEJO|
| **Gestión** | 2 / 2025|

---

## 2. Introducción  

**Moonveil** es un videojuego del género **Metroidvania/Plataformas** desarrollado en **Godot Engine**. Inspirado en *Hollow Knight* y *Fez Game*, su propuesta se centra en la **originalidad visual, una interfaz pulida y mecánicas de juego fluidas**.  

El jugador controla a un explorador en un entorno místico, lleno de enemigos, plataformas y secretos, utilizando movimientos básicos, ataques y habilidades especiales como el **dash**.  

---

## 3. Motivación y antecedentes  

El proyecto surge de la necesidad de **aplicar de forma práctica** los conocimientos adquiridos en clase. La idea fue no solo crear un prototipo funcional, sino un juego con **identidad propia**, destacando en gráficos, interfaz y experiencia de usuario.  

**Inspiraciones principales:**  
- *Hollow Knight*: atmósfera inmersiva, exploración no lineal, estilo artístico 2D oscuro.  
- *Fez Game*: innovación visual, mundos dinámicos y experimentales.  

Ambos proyectos marcaron la visión de **Moonveil**, pero buscamos aportar un toque de **originalidad en la interfaz, paleta de colores, ambientación y jugabilidad** que queríamos mostrar en este examen como resultado.  


| <img width="3800" height="1700" alt="image" src="https://github.com/user-attachments/assets/f35251a9-94fb-437a-9091-8d58e83a7057" />|
---


| <img width="1100" height="500" alt="image" src="https://github.com/user-attachments/assets/0ea5018a-2a4d-4ca9-a153-2439209c10dc" /> |
---

---

## 4. Objetivos  

| Tipo | Objetivo |
|------|----------|
| **General** | Desarrollar un videojuego en **Godot** que combine exploración, combate y estética distintiva. |
| **Técnicos** | - Implementar **sistema de colisiones optimizado**. <br> - Uso de **Tilemaps** para escenarios modulares. <br> - **Sistema de físicas en 2D** para movimientos y combate. <br> - Animaciones fluidas en personajes y enemigos. |
| **Funcionales** | - Movimiento libre con **WASD**. <br> - **Dash** con tecla *Shift*. <br> - **Ataque con click izquierdo**. <br> - Sistema de daño con **Hitbox/Hurtbox**. |

---

## 5. Descripción del proyecto  

### 5.1 Arquitectura del sistema  

```

 Moonveil
┣ 📂 assets/           # Sprites, sonidos y recursos visuales
┣ 📂 scenes/           # Escenas principales (jugador, enemigos, niveles)
┣ 📂 scripts/          # Código en GDScript
┣ 📜 project.godot     # Configuración del proyecto
┗ 📜 mainlevel.tscn    # Escena principal del juego

````

### 5.2 Diagrama general de componentes  

```plaintext
                 ┌─────────────────────┐
                 │       Jugador        │
                 │  (Player.gd, FSM)   │
                 └─────────┬───────────┘
                           │
            ┌──────────────┴──────────────┐
            │                             │
    ┌───────▼─────────┐          ┌────────▼────────┐
    │   Movimiento    │          │     Combate     │
    │ (Input WASD,    │          │ (Ataque, daño,  │
    │  Dash, salto)   │          │  Hitbox/Hurtbox)│
    └───────┬─────────┘          └────────┬────────┘
            │                             │
    ┌───────▼─────────┐          ┌────────▼────────┐
    │  Físicas 2D     │          │  Enemigos AI    │
    │ (Colisiones,    │          │ (Pathfinding,   │
    │ gravedad)       │          │ persecución)    │
    └─────────────────┘          └─────────────────┘
````

### 5.3 Patrones de diseño aplicados

* **Observer (Signals):** Comunicación entre jugador, enemigos y UI.
* **State Machine:** Manejo de estados del jugador (idle, walk, attack, dash).
* **Entity-Component:** Separación de visual, lógica y físicas.

### 5.4 Algoritmos y mecánicas

* **Game Loop** integrado en Godot.
* **Colisiones** con máscaras y capas específicas para optimizar rendimiento.
* **Pathfinding** básico en enemigos para seguimiento al jugador.
* **Tilemaps** para escenarios modulares y escalables.

### 5.5 Controles

| Acción | Tecla               |
| ------ | ------------------- |
| Mover  | **WASD**            |
| Dash   | **Shift**           |
| Atacar | **Click Izquierdo** |

---

## 6. Capturas de pantalla

| Escenario                                        | Jugador vs Enemigos                    |
| ------------------------------------------------ | -------------------------------------- |
| <img width="1354" height="766" alt="image" src="https://github.com/user-attachments/assets/eb490914-eeee-4691-9b43-daa59ea993ad" /> | <img width="831" height="706" alt="image" src="https://github.com/user-attachments/assets/1b2459f6-ab55-492c-85db-461325c3df59" />  |

 ---

## Capturas y Diseño Visual Oficial  

En esta sección se documentan los elementos gráficos más representativos creados para **Moonveil**.  
A diferencia de otros recursos externos, estos corresponden al **trabajo original del equipo** y definen la identidad visual del proyecto.  

---

###  Sprite del Personaje Principal  

El personaje fue diseñado por nosotros, tomando como base la fusión de ideas de nuestros juegos de referencia.  
Su estética mezcla **minimalismo oscuro** con detalles estilizados para reflejar la atmósfera misteriosa de *Moonveil*.  

| Personaje Principal |
|---------------------|
| <img width="619" height="344" alt="image" src="https://github.com/user-attachments/assets/2f99bc6c-0b55-4961-9d06-af14fee638a4" /> |

---

###  Diseño del Mapa  

El mapa se desarrolló en **Godot** utilizando **Tilemaps**, lo que permitió modularidad y escalabilidad.  
Este diseño combina **plataformas**, **zonas verticales** y **espacios abiertos**, inspirados en *Hollow Knight*, pero con un enfoque visual más luminoso y ornamental.  

| Vista del Mapa Diseñado |
|--------------------------|
| <img width="1423" height="504" alt="image" src="https://github.com/user-attachments/assets/a494023c-6ada-4840-9d6b-84ab3933eb68" /> |

---

###  Estilo Visual y Fondo con Parallax  

Para la ambientación se definió un **estilo artístico oscuro y atmosférico**, reforzado con fondos en **efecto Parallax**, que aportan **profundidad y dinamismo** al escenario.  

| Fondo con Parallax | Fondo con Paralax nuestro |
|--------------------|------------------|
| <img width="740" height="200" alt="image" src="https://github.com/user-attachments/assets/2b2396a2-ddbb-41d7-9a8e-62c1375c39ee" /> | <img width="1352" height="395" alt="image" src="https://github.com/user-attachments/assets/1d485d4a-325c-49a7-9cbf-53132afb0a6a" /> |

---

## 7. Contenido de clase aplicado

| Semana | Tema                                        | Aplicación en Moonveil                                 |
| ------ | ------------------------------------------- | ------------------------------------------------------ |
| 14–15  | **Motores de videojuegos, Godot, GameLoop** | Implementación del bucle principal del juego en Godot. |
| 16–17  | **Scripting, GDScript, Observer, Signals**  | Sistema de comunicación entre UI y entidades.          |
| 18–19  | **Físicas en Godot**                        | Colisiones optimizadas (Hitbox/Hurtbox).               |
| 20–21  | **Tilemaps**                                | Creación modular de escenarios.                        |
| 22–23  | **IA y Path Planning**                      | Enemigos persiguen al jugador.                         |
| 25–27  | **Pipelines de renderizado y Ray Tracing**  | Inspiración para shaders y mejoras gráficas.           |
| 28–30  | **IA Generativa**                           | Posible uso futuro para generación de assets.          |
| 31–33  | **Proyecto final**                          | Desarrollo completo de *Moonveil*.                     |

---

## 8. Lecciones aprendidas

* La importancia de **estructurar el proyecto** desde el inicio.
* Cómo los **Signals en Godot** facilitan la comunicación entre objetos.
* Los **Tilemaps** son esenciales para construir niveles escalables.
* El **debug de colisiones** es clave para una experiencia fluida.

---

## 9. Conclusiones

El desarrollo de **Moonveil** permitió aplicar conocimientos de **arquitectura de videojuegos, scripting en GDScript, físicas, IA básica y diseño visual**.

Si bien existen futuras mejoras posibles (integración de sonido, expansión de niveles, jefes con IA avanzada), el proyecto cumple con su meta principal: un videojuego **funcional, original y atractivo visualmente**.

---

## 10. Futuras mejoras

* Implementación de **sistema de sonido y música dinámica**.
* Añadir **sistema de progresión** (vidas, inventario, mejoras).
* Integración de **IA generativa** para creación de assets dinámicos.
* Expansión del **mundo del juego** con más niveles y jefes.

---

#  CONTINUIDAD DEL PROYECTO  

## Este juego **NO termina aquí**  
Se seguirá **mejorando y expandiendo** con más dedicación y tiempo por amor al arte.


---

> [!IMPORTANT]  
> **Nota de desarrollo:**  
> Todas las **nuevas características** y **mejoras** se trabajarán en la rama **`develop`**,  
> antes de integrarse a la rama principal.  
>  
> Esto asegura **orden, estabilidad** y un **flujo de trabajo profesional**.  


