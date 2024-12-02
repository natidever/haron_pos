part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

class InitTheme extends ThemeEvent {}

class ToggleTheme extends ThemeEvent {}
