import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    on<ForgotPasswordEvent>((event, emit) {});
    _sendPasswordResetLink();
  }

  _sendPasswordResetLink() {
    return on<SendResetPasswordLinkEvent>(
      (event, emit) async {
        try {
          emit(SendPasswordResetLinkLoadingState());
          FirebaseAuth firebaseAuth = FirebaseAuth.instance;
          await firebaseAuth.sendPasswordResetEmail(email: event.email);
          emit(SendPasswordResetLinkCompletedState(
              successMessage: "Link has been Sent"));
        } on FirebaseAuthException catch (e) {
          emit(SendPasswordResetLinkErrorState(errorMessage: e.message ?? ""));
        }
      },
    );
  }
}
