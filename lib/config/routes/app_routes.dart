abstract class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String emailVerification = '/email-verification';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String patientHome = '/patient/home';
  static const String patientSearch = '/patient/search';
  static const String doctorProfile = '/patient/doctor/:id';
  static const String booking = '/patient/booking/:doctorId';
  static const String bookingConfirm = '/patient/booking/confirm';
  static const String myAppointments = '/patient/appointments';
  static const String patientProfile = '/patient/profile';
  static const String doctorDashboard = '/doctor/dashboard';
  static const String doctorSchedule = '/doctor/schedule';
  static const String doctorPatients = '/doctor/patients';
  static const String prescription = '/doctor/prescription/:appointmentId';
  static const String chat = '/chat/:chatId';
  static const String videoCall = '/video-call/:callId';
  static const String notifications = '/notifications';
  
  // Missing routes to be added
  static const String payment = '/patient/payment';
  static const String visitRating = '/patient/visit-rating';
  static const String patientFile = '/doctor/patient-file/:patientId';
  static const String medicalRecords = '/patient/medical-records';
  static const String registerDoctorStep2 = '/register/doctor-specialty';
}
