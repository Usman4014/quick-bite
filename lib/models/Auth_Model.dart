// ignore_for_file: file_names

import 'package:quick_bite/enums/Auth_Status.dart';

class AuthModel {
  final AuthStatus status;
  final String? verificationId;
  final String? phoneNumber;
  final String? email;
  final String? errorMessage;
  final String? errorTopic;

  const AuthModel({
    this.status = AuthStatus.initial,
    this.verificationId,
    this.phoneNumber,
    this.email,
    this.errorMessage,
    this.errorTopic
  });

  AuthModel copyWith({
    AuthStatus? status,
    String? verificationId,
    String? phoneNumber,
    String? email,
    String? errorMessage,
     String? errorTopic,
  }) {
    return AuthModel(
      status: status ?? this.status,
      verificationId: verificationId ?? this.verificationId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    errorTopic: errorTopic ?? this.errorTopic
    );
  }

  bool get isLoading => status == AuthStatus.loading;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  bool get isCodeSent => status == AuthStatus.codeSent;

  bool get hasError =>
      status == AuthStatus.error ||
      status == AuthStatus.verificationFailed;
}