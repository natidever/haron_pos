import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, CustomFormState> {
  FormBloc() : super(CustomFormState(isPasswordVisible: false)) {
    on<TogglePasswordVisibilityEvent>((event, emit) {
      emit(CustomFormState(isPasswordVisible: !state.isPasswordVisible));
    });
  }
}
