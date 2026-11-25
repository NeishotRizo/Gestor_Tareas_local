import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:gestor_tareas_local/data/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('Agregar y consultar tarea', () async {
    await db.agregarTarea('Estudiar Flutter');

    final tareas = await db.obtenerTareas();

    expect(tareas.length, 1);
    expect(tareas.first.titulo, 'Estudiar Flutter');
    expect(tareas.first.completada, false);
  });

  test('Editar titulo', () async {
    final id = await db.agregarTarea('Titulo original');

    await db.editarTarea(id, 'Titulo actualizado');

    final tareas = await db.obtenerTareas();

    expect(tareas.first.titulo, 'Titulo actualizado');
  });

  test('Cambiar estado de tarea', () async {
    final id = await db.agregarTarea('Estudiar SQLite');

    await db.cambiarEstado(id, true);

    final tareas = await db.obtenerTareas();

    expect(tareas.first.completada, true);
  });

  test('Eliminar tarea', () async {
    final id = await db.agregarTarea('Tarea temporal');

    await db.eliminarTarea(id);

    final tareas = await db.obtenerTareas();

    expect(tareas, isEmpty);
  });
}
