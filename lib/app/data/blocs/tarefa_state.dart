import 'package:bloc_pattern/app/data/models/tarefa_model.dart';

abstract class TarefaState {
  final List<TarefaModel> tarefas;

  TarefaState({required this.tarefas});
}

class TarefaInitialState extends TarefaState {
  TarefaInitialState() : super(tarefas: []);
}

class TarefaLoadingState extends TarefaState {
  TarefaLoadingState() : super(tarefas: []);
}

class TarefaLoadedState extends TarefaState {
  TarefaLoadedState({required List<TarefaModel> tarefas}) : super(tarefas: tarefas);
}

class TarefaErrorState extends TarefaState {
  final Exception exception;

  TarefaErrorState({required this.exception}) : super(tarefas: []);
}