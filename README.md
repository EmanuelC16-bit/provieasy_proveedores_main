# ProvyEasy Flutter App

Este proyecto es una aplicación Flutter para gestionar usuarios, inicio de sesión y navegación entre pantallas como Home, Login, Registro y Recuperación de Contraseña.

## 🚀 Pasos para correr la app en local

1. Instala las dependencias del proyecto:
```bash
flutter pub get
```

2. Genera las localizaciones de la app:
```bash
flutter gen-l10n
```

3. Selecciona el dispositivo en el que quieres correr la app:

```bash
flutter devices
```

O en Visual Studio Code / Android Studio:

* Abre el selector de dispositivo (arriba a la derecha) y elige uno disponible.

4. Ejecuta la app:

```bash
flutter run -d <device_id>
```

---

## 📌 Información importante para devs

* El punto de entrada de la app (`main.dart`) está en:

  ```dart
  lib/main.dart
  ```

* La app usa:

  * **Material3**
  * **logger** para logs
  * **permission\_handler** para permisos de notificaciones
  * Rutas configuradas:

    * `/login`
    * `/home`
    * `/sign_up`
    * `/forgotPw`

* La clase principal es `ProvyEasyApp` que verifica si la sesión del usuario es válida y redirige a Home o Login según corresponda.

---

## ⚠️ Notas adicionales

* Si agregas nuevos paquetes, corre siempre:

  ```bash
  flutter pub get
  ```

* Si agregas nuevos localizaciones, usa:

  ```bash
  flutter gen-l10n
  ```

* Si agregas nuevos dispositivos, usa:

  ```bash
  flutter devices
  ```

* Si necesitas limpiar la app:

  ```bash
  flutter clean
  flutter pub get
  flutter gen-l10n
  ```

---
