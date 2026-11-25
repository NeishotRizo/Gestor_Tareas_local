# gestor_tareas_local

A new Flutter project.

Tecnologia de persistencia usada
Usaré drift y drift_flutter para una base de datos Sqlite local.
Vi que esta tecnologia soporta multiplataforma para web, escritorio y movil, entre otras.

drift es para las operaciones CRUD, las consultas asincras y la interaccion entre dart y SQLite
cada app maneja su base de datos local entonces no se comparten 


Escritorio: Crud y persistencia probados
Chrome: Crud y persistencia probados
movil: Crud y persistencia 

Funcionalidades:

Registrar tareas
consultar tareas almacenadas
editar titulos
marcar tareas 
eliminar
validar titulos vacios
Persistencia

Tecnologias:
SQLite
Drift
Drift_flutter
WebAssembly
build_runner

Instrucciones:

flutter pub get
dart run build_runner build


Ejecutar:
flutter run -d linux

web:
flutter run -d chrome --web-port=8081

Android:
flutter devices
flutter run -d ID_DEL_DISPOSITIVO

Pruebas:
flutter test


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


