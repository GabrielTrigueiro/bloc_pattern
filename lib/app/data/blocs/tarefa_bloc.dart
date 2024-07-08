import 'package:bloc_pattern/app/data/blocs/tarefa_event.dart';
import 'package:bloc_pattern/app/data/blocs/tarefa_state.dart';
import 'package:bloc_pattern/app/data/models/tarefa_model.dart';
import 'package:bloc_pattern/app/data/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TarefaBloc extends Bloc<TarefaEvent, TarefaState> {
  final _repository = TarefaRepository();

  TarefaBloc() : super(TarefaInitialState()) {
    on(_mapEventToState);
  }
  // ? trata os eventos
  void _mapEventToState(TarefaEvent event, Emitter emit) async {
    List<TarefaModel> tarefas = [];

    emit(TarefaLoadingState());

    if (event is GetTarefas) {
      tarefas = await _repository.getTarefas();
    } else if (event is PostTarefa) {
      tarefas = await _repository.postTarefa(tarefa: event.tarefa);
    } else if (event is DeleteTarefa) {
      tarefas = await _repository.deleteTarefa(tarefa: event.tarefa);
    }

    emit(TarefaLoadedState(tarefas: tarefas));
  }
}
  