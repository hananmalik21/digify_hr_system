import 'package:digify_hr_system/features/employee_management/domain/models/employee_full_details.dart';
import 'package:digify_hr_system/features/employee_management/presentation/utils/employee_detail_formatters.dart';

/// Presentation model for one document card on the employee detail documents tab.
/// All display logic lives here; UI only consumes [title], [fileName], [status], [expiryDate], [accessUrl].
class EmployeeDetailDocumentDisplay {
  const EmployeeDetailDocumentDisplay({
    required this.title,
    required this.fileName,
    required this.status,
    required this.expiryDate,
    this.accessUrl,
    this.firstFieldLabel = 'File name',
  });

  final String title;
  final String fileName;
  final String status;
  final String expiryDate;
  final String? accessUrl;
  final String firstFieldLabel;

  static String documentTypeTitle(String? code) {
    if (code == null || code.isEmpty) return 'Document';
    return code
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map((s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.length > 1 ? s.substring(1) : ''}')
        .join(' ');
  }

  static String _expiryForDocumentType(String? documentTypeCode, EmployeeFullDetails? fullDetails) {
    if (fullDetails == null) return '—';
    final docComp = fullDetails.documentCompliance;
    final demo = fullDetails.demographics;
    switch (documentTypeCode?.toUpperCase()) {
      case 'CIVIL_ID':
        return formatIsoDateToDisplay(docComp?.civilIdExpiry);
      case 'PASSPORT':
        return formatIsoDateToDisplay(docComp?.passportExpiry);
      case 'VISA':
        return formatIsoDateToDisplay(demo?.visaExpiry);
      case 'WORK_PERMIT':
        return formatIsoDateToDisplay(demo?.workPermitExpiry);
      default:
        return '—';
    }
  }

  static EmployeeDetailDocumentDisplay fromDocument(DocumentItem doc, EmployeeFullDetails? fullDetails) {
    return EmployeeDetailDocumentDisplay(
      title: documentTypeTitle(doc.documentTypeCode),
      fileName: displayValue(doc.fileName),
      status: doc.status ?? '—',
      expiryDate: _expiryForDocumentType(doc.documentTypeCode, fullDetails),
      accessUrl: doc.accessUrl,
    );
  }

  /// Returns display items from API documents, or fallback items from demographics/documentCompliance when empty.
  static List<EmployeeDetailDocumentDisplay> fromFullDetails(EmployeeFullDetails? fullDetails) {
    final documents = fullDetails?.documents ?? [];
    if (documents.isNotEmpty) {
      return documents.map((d) => fromDocument(d, fullDetails)).toList();
    }
    final docComp = fullDetails?.documentCompliance;
    final demo = fullDetails?.demographics;
    return [
      EmployeeDetailDocumentDisplay(
        title: 'Civil ID',
        fileName: displayValue(demo?.civilIdNumber),
        status: '—',
        expiryDate: formatIsoDateToDisplay(docComp?.civilIdExpiry),
        firstFieldLabel: 'Number',
      ),
      EmployeeDetailDocumentDisplay(
        title: 'Passport',
        fileName: displayValue(demo?.passportNumber),
        status: '—',
        expiryDate: formatIsoDateToDisplay(docComp?.passportExpiry),
        firstFieldLabel: 'Number',
      ),
      EmployeeDetailDocumentDisplay(
        title: 'Visa',
        fileName: displayValue(demo?.visaNumber),
        status: '—',
        expiryDate: formatIsoDateToDisplay(demo?.visaExpiry),
        firstFieldLabel: 'Number',
      ),
      EmployeeDetailDocumentDisplay(
        title: 'Work Permit',
        fileName: displayValue(demo?.workPermitNumber),
        status: '—',
        expiryDate: formatIsoDateToDisplay(demo?.workPermitExpiry),
        firstFieldLabel: 'Number',
      ),
    ];
  }
}
