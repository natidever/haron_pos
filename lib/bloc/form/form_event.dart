part of 'form_bloc.dart';

@immutable
sealed class FormEvent {}

class TogglePasswordVisibilityEvent extends FormEvent {}
