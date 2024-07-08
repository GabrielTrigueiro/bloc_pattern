import 'package:bloc_pattern/app/data/blocs/tarefa_bloc.dart';
import 'package:bloc_pattern/app/data/blocs/tarefa_event.dart';
import 'package:bloc_pattern/app/data/blocs/tarefa_state.dart';
import 'package:bloc_pattern/app/data/models/tarefa_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    _tarefaBloc.add(GetTarefas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bloc Pattern')),
      body: BlocBuilder<TarefaBloc, TarefaState>(
          bloc: _tarefaBloc,
          builder: (context, state) {
            if (state is TarefaLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TarefaLoadedState) {
              final list = state.tarefas;
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
                      onPressed: () {_tarefaBloc.add(DeleteTarefa(tarefa: list[index]));},
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
          _tarefaBloc.add(PostTarefa(tarefa: TarefaModel(nome: "xablua")));
        },
      ),
    );
  }

  @override
  void dispose() {
    _tarefaBloc.close();
    super.dispose();
  }
}