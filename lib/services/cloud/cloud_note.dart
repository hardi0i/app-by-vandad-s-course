import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vandad_course_app/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  final String documentId;
  final String ownerUserId;
  final String text;

  factory CloudNote.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return CloudNote(
      documentId: snapshot.id,
      ownerUserId: snapshot.data()[ownerUserIdFieldName],
      text: snapshot.data()[textFieldName],
    );
  }
}
