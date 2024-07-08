import 'package:bloc_pattern/app/data/blocs/tarefa_bloc.dart';
import 'package:bloc_pattern/app/data/blocs/tarefa_event.dart';
import 'package:bloc_pattern/app/data/blocs/tarefa_state.dart';
import 'package:bloc_pattern/app/data/models/tarefa_model.dart';
import 'package:flutter/material.dart';

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  late final TarefaBloc _tarefaBloc;

  @override
  void initState() {
    super.initState();
    _tarefaBloc = TarefaBloc();
    _tarefaBloc.inputTarefa.add(GetTarefas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc Pattern')),
      body: StreamBuilder<TarefaState>(
          stream: _tarefaBloc.outputTarefa,
          builder: (context, state) {
            if (state.data is TarefaLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state.data is TarefaLoadedState) {
              final list = state.data?.tarefas ?? [];
              return ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                itemCount: list.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Center(child: Text(list[index].nome[0])),
                    ),
                    title: Text(list[index].nome),
                    trailing: IconButton(
                      onPressed: () {_tarefaBloc.inputTarefa.add(DeleteTarefa(tarefa: list[index]));},
                      icon: const Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              );
            }
            else {
              return const Center(
                child: Text('Nenhuma tarefa cadastrada'),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _tarefaBloc.inputTarefa.add(PostTarefa(tarefa: TarefaModel(nome: "xablua")));
        },
      ),
    );
  }

  @override
  void dispose() {
    _tarefaBloc.inputTarefa.close();
    super.dispose();
  }
}