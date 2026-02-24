import '../models/overtime/overtime_record.dart';

abstract class OvertimeRepository {
  Future<List<OvertimeRecord>> getOvertimeRecords({String? employeeNumber});
}
