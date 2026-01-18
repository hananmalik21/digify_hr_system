import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digify_hr_system/features/leave_management/data/repositories/document_repository_impl.dart';
import 'package:digify_hr_system/features/leave_management/domain/repositories/document_repository.dart';

/// Provider for DocumentRepository
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  return DocumentRepositoryImpl();
});
