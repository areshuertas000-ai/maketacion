# Validación de la entrega

Entorno: Flutter 3.44.9 stable y Dart 3.12.2 en Windows.

| Comprobación | Resultado |
| --- | --- |
| Análisis estático de Dart | Sin errores ni advertencias |
| `flutter test --reporter expanded` | 11 pruebas aprobadas |
| Login, registro y cierre de sesión | Navegación y datos compartidos verificados |
| Recuperación completa | Correo, casillas, foco, contador, reenvío y éxito verificados |
| Nueva contraseña | Tres requisitos en tiempo real y coincidencia verificados |
| Adaptación de las seis pantallas | Sin desbordamientos a 320 × 568, 390 × 844 y 430 × 932 |
| Barras nativas y teclado Android | Sin duplicar barras del sistema; formularios adaptables con teclado |
| Capturas de widgets | Seis imágenes generadas en `docs/pantallas/` |
| Compilación web | `flutter build web --no-wasm-dry-run` completada |
| Revisión en navegador | Login y Registro revisados a 390 × 844 |
| Compilación de APK Android | `flutter build apk --debug --target-platform android-arm64` completada |
| Instalación y apertura en Android | APK instalado y abierto en emulador Pixel 6 con Android 17 |
| Navegación en Android | Login → Home con el correo ingresado → Cerrar sesión → Login, verificados en el emulador |

Las pruebas funcionales se encuentran en `test/`. La generación de capturas es una herramienta separada en `tool/capture_screens.dart`.

El instalador de entrega es `Login_Registro_Android_ARM64.apk`, versión 1.0.0, paquete `com.taller.login_registro`. Requiere Android 7.0 (API 24) o superior en un dispositivo ARM64; el SDK de destino es API 36. La prueba de instalación y navegación se realizó en un emulador; no se probó en un teléfono físico.

Capturas tomadas directamente de Android: [Login](android-login.png) y [Home](android-home.png).

Repositorio de entrega: [areshuertas000-ai/maketacion](https://github.com/areshuertas000-ai/maketacion). Los instaladores y el proyecto comprimido se encuentran en la [versión v1.0.0](https://github.com/areshuertas000-ai/maketacion/releases/tag/v1.0.0).
