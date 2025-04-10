part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class SendResetPasswordLinkEvent extends ForgotPasswordEvent {
  final String email;
  SendResetPasswordLinkEvent({required this.email});
}
