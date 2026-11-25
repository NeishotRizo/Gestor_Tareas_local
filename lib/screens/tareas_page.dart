import 'package:flutter/material.dart';

import '../models/tarea.dart';
import '../data/database.dart';

// Pantalla base SIN persistencia ni operaciones CRUD implementadas.
// Conserva las indicaciones TODO para orientar tu trabajo.
class TareasPage extends StatefulWidget {
  const TareasPage({super.key});

  @override
  State<TareasPage> createState() => _TareasPageState();
}

class _TareasPageState extends State<TareasPage> {
  final TextEditingController _tituloController = TextEditingController();

  final List<Tarea> _tareas = [];
  final AppDatabase _db = AppDatabase();

  @override
  void initState() {
    super.initState();
    _cargarTareas();
  }

  Future<void> _cargarTareas() async {
    try {
      final registros = await _db.obtenerTareas();

      if (!mounted) return;

      setState(() {
        _tareas.clear();

        _tareas.addAll(
          registros.map(
            (registro) => Tarea(
              id: registro.id,
              titulo: registro.titulo,
              completada: registro.completada,
            ),
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;
      _pendiente('Error al cargar las tareas');
    }
  }

  Future<void> _agregarTarea() async {
    final titulo = _tituloController.text.trim();

    if (titulo.isEmpty) {
      _pendiente('El título no puede estar vacío');
      return;
    }

    try {
      await _db.agregarTarea(titulo);

      if (!mounted) return;

      _tituloController.clear();

      await _cargarTareas();
    } catch (e) {
      if (!mounted) return;
      _pendiente('Error al guardar la tarea');
    }
  }

  Future<void> _alternarCompletada(Tarea tarea, bool completada) async {
    try {
      await _db.cambiarEstado(tarea.id, completada);
      await _cargarTareas();
    } catch (e) {
      if (!mounted) return;
      _pendiente('Error al actualizar la tarea');
    }
  }

  Future<void> _editarTarea(Tarea tarea) async {
    String nuevoTitulo = tarea.titulo;

    final resultado = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar tarea'),
          content: TextFormField(
            initialValue: tarea.titulo,
            autofocus: true,
            onChanged: (valor) {
              nuevoTitulo = valor;
            },
            decoration: const InputDecoration(
              labelText: 'Título de la tarea',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, nuevoTitulo.trim());
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (!mounted || resultado == null) return;

    if (resultado.isEmpty) {
      _pendiente('El título no puede estar vacío');
      return;
    }

    try {
      await _db.editarTarea(tarea.id, resultado);
      await _cargarTareas();
    } catch (e) {
      if (!mounted) return;
      _pendiente('Error al editar la tarea');
    }
  }

  Future<void> _eliminarTarea(Tarea tarea) async {
    try {
      await _db.eliminarTarea(tarea.id);
      await _cargarTareas();
    } catch (e) {
      if (!mounted) return;
      _pendiente('Error al eliminar la tarea');
    }
  }

  void _pendiente(String mensaje) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _db.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestor de tareas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _agregarTarea,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
            const SizedBox(height: 12),
            const Text('Mis tareas', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Expanded(
              child: _tareas.isEmpty
                  ? const Center(child: Text('Todavía no hay tareas guardadas'))
                  : ListView.builder(
                      itemCount: _tareas.length,
                      itemBuilder: (context, index) {
                        final tarea = _tareas[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: tarea.completada,
                              onChanged: (valor) {
                                if (valor != null) {
                                  _alternarCompletada(tarea, valor);
                                }
                              },
                            ),
                            title: Text(tarea.titulo),
                            subtitle: Text('ID: ${tarea.id}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Editar',
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _editarTarea(tarea),
                                ),
                                IconButton(
                                  tooltip: 'Eliminar',
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _eliminarTarea(tarea),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
