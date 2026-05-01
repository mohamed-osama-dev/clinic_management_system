import 'package:clinic_management_system/core/network/firebase_gateways.dart';

class AuthFirebaseDataSource {
  AuthFirebaseDataSource(this._authGateway);

  final FirebaseAuthGateway _authGateway;

  // TODO(migrate): implement FirebaseAuth-driven datasource methods.
  FirebaseAuthGateway get authGateway => _authGateway;
}
