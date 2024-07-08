import 'dart:async';

import 'package:bloc_pattern/app/data/blocs/tarefa_event.dart';
import 'package:bloc_pattern/app/data/blocs/tarefa_state.dart';
import 'package:bloc_pattern/app/data/models/tarefa_model.dart';
import 'package:bloc_pattern/app/data/repositories/user_repository.dart';

class TarefaBloc {
  final _repository = TarefaRepository();

  // ? entrada de eventos
  final StreamController<TarefaEvent> _inputTarefaController =
      StreamController<TarefaEvent>();
  // ? saida de estados
  final StreamController<TarefaState> _outputTarefaController =
      StreamController<TarefaState>();

  // ? expor get
  Sink<TarefaEvent> get inputTarefa => _inputTarefaController
      .sink; // permite que a view envie eventos para o bloc
  // ? expor saida de dados
  Stream<TarefaState> get outputTarefa => _outputTarefaController
      .stream; // permite que o bloc envie dados para a view

  // ? escuta todos os eventos que são enviados para a classe
  TarefaBloc() {
    _inputTarefaController.stream.listen(_mapEventToState);
  }
  // ? trata os eventos
  void _mapEventToState(TarefaEvent event) async {
    List<TarefaModel> tarefas = [];

    _outputTarefaController.add(TarefaLoadingState());

    if(event is GetTarefas){
      tarefas = await _repository.getTarefas();
    } else if(event is PostTarefa){
      tarefas = await _repository.postTarefa(tarefa: event.tarefa);
    } else if(event is DeleteTarefa){
      tarefas = await _repository.deleteTarefa(tarefa: event.tarefa);
    }

    _outputTarefaController.add(TarefaLoadedState(tarefas: tarefas));
  }
}
