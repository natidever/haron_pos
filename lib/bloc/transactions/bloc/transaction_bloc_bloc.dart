import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transaction_bloc_event.dart';
part 'transaction_bloc_state.dart';

class TransactionBlocBloc extends Bloc<TransactionBlocEvent, TransactionBlocState> {
  TransactionBlocBloc() : super(TransactionBlocInitial()) {
    on<TransactionBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
