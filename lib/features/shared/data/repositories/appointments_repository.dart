// Path: lib/features/shared/data/repositories/appointments_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/appointment_model.dart';

class AppointmentsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'appointments';

  // 1. إنشاء حجز جديد (المريض بيستخدمها)
  Future<void> createAppointment(AppointmentModel appointment) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(appointment.id)
          .set(appointment.toMap());
    } catch (e) {
      throw Exception('فشل في إنشاء الموعد: $e');
    }
  }

  // 2. جلب مواعيد دكتور معين (شاشة جدول الدكتور بتستخدمها)
  Stream<List<AppointmentModel>> getDoctorAppointments(String doctorId) {
    return _firestore
        .collection(_collectionPath)
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // 3. جلب مواعيد مريض معين (شاشة المريض بتستخدمها)
  Stream<List<AppointmentModel>> getPatientAppointments(String patientId) {
    return _firestore
        .collection(_collectionPath)
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AppointmentModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  // 4. تحديث حالة الحجز (قبول/رفض من الدكتور)
  Future<void> updateAppointmentStatus(String appointmentId, AppointmentStatus newStatus) async {
    try {
      await _firestore.collection(_collectionPath).doc(appointmentId).update({
        'status': newStatus.name,
      });
    } catch (e) {
      throw Exception('فشل في تحديث حالة الموعد: $e');
    }
  }
}