import 'package:digify_hr_system/features/workforce_structure/domain/models/reporting_relationship.dart';

abstract class ReportingStructureRepository {
  Future<List<ReportingRelationship>> getReportingRelationships({int? tenantId});
}
