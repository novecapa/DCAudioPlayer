# DCAudioPlayer

Este proyecto en Swift permite importar y reproducir archivos de audio. Los archivos de audio se mantienen organizados en una vista principal, donde el usuario puede buscar fácilmente entre ellos. El reproductor de audio permite la reproducción en segundo plano, lo que significa que los usuarios pueden escuchar música mientras navegan por otras aplicaciones.

## Funcionalidades

- **Importación de archivos de audio**: Permite agregar archivos de audio desde el dispositivo.
- **Reproducción de audio**: Soporta la reproducción de archivos de audio con controles estándar (play, pause, stop).
- **Vista principal organizada**: Muestra una lista de archivos de audio de manera organizada y accesible.
- **Buscador**: Incluye una barra de búsqueda para que el usuario pueda filtrar los archivos por nombre.
- **Reproducción en segundo plano**: Permite seguir escuchando el audio aunque el usuario esté navegando en otras aplicaciones.

## Requisitos

- **Xcode**: Requiere Xcode 15 o superior.
- **Swift**: El proyecto está desarrollado en Swift 5.3 o superior.
- **iOS 17+**: Requiere iOS 17.0 o superior.

## Instalación

1. Clona este repositorio a tu máquina local:

```bash
git clone https://github.com/tuusuario/proyecto-reproductor-audio.git
```

2. Abre el proyecto en Xcode:

```bash
open ProyectoReproductorAudio.xcworkspace
```

3. Ejecuta la aplicación en el simulador o dispositivo físico.

## Uso

1. **Importar Archivos de Audio**: Puedes importar archivos de audio y se añadirá a la lista.

2. **Buscar Archivos**: Usa la barra de búsqueda para encontrar rápidamente el archivo que deseas reproducir.

3. **Reproducir Audio**: Toca sobre cualquier archivo en la lista para comenzar la reproducción. Los controles básicos de reproducción (play, pause, stop) estarán disponibles.

4. **Reproducción en Segundo Plano**: Al iniciar la reproducción de un archivo de audio, podrás seguir escuchando mientras navegas por otras aplicaciones. La música se seguirá reproduciendo incluso si la aplicación no está en primer plano.

## Tecnologías Usadas

- **Swift**: El lenguaje de programación utilizado para desarrollar la aplicación.
- **SwiftUI**: Para la creación de la interfaz de usuario.
- **AVFoundation**: Para manejar la reproducción de archivos de audio.
- **Realm**: Para gestionar el almacenamiento de archivos de audio y su organización en la aplicación.

## Contribución

Las contribuciones son bienvenidas. Si tienes ideas para mejorar el proyecto o has encontrado un error, por favor abre un _issue_ o crea una _pull request_.

- Haz un fork de este repositorio a tu cuenta de GitHub.
- Clona el repositorio a tu máquina local.
- Haz los cambios o añade las características que consideres necesarias.
- Commit y push tus cambios a tu repositorio.
- Crea una Pull Request (PR) desde tu repositorio hacia este repositorio.

## Licencia

Este proyecto está licenciado bajo la [MIT License](LICENSE).

