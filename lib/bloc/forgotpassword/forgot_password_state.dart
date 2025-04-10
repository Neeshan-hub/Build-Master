part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class SendPasswordResetLinkLoadingState extends ForgotPasswordState {}

class SendPasswordResetLinkErrorState extends ForgotPasswordState {
  final String errorMessage;
  SendPasswordResetLinkErrorState({required this.errorMessage});
}

class SendPasswordResetLinkCompletedState extends ForgotPasswordState {
  final String successMessage;
  SendPasswordResetLinkCompletedState({required this.successMessage});
}
