import 'package:digify_hr_system/features/enterprise_structure/domain/models/enterprise_stats.dart';

abstract class EnterpriseStatsRepository {
  Future<EnterpriseStats> getEnterpriseStats({required int enterpriseId});
}
