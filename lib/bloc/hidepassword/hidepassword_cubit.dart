// Create a new file: hidepassword_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class HidepasswordCubit extends Cubit<HidepasswordState> {
  HidepasswordCubit() : super(HidepasswordState(hidepassword: true));

  void hidepassword(bool currentState) {
    emit(HidepasswordState(hidepassword: !currentState));
  }
}

class HidepasswordState {
  final bool hidepassword;
  HidepasswordState({required this.hidepassword});
}
