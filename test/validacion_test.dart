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

  test('Rechazar titulo vacio', () async {
    await expectLater(db.agregarTarea(''), throwsArgumentError);

    expect(await db.obtenerTareas(), isEmpty);
  });

  test('Rechazar titulo compuesto por espacios', () async {
    await expectLater(db.agregarTarea('   '), throwsArgumentError);

    expect(await db.obtenerTareas(), isEmpty);
  });
}
