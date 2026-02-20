enum OrganizationLevel {
  company,
  division,
  businessUnit,
  department,
  section,
  unknown;

  factory OrganizationLevel.fromCode(String code) {
    switch (code.toUpperCase()) {
      case 'COMPANY':
      case 'COMP':
        return OrganizationLevel.company;
      case 'DIVISION':
      case 'DIV':
        return OrganizationLevel.division;
      case 'BUSINESS_UNIT':
      case 'BUSINESSUNIT':
      case 'BU':
        return OrganizationLevel.businessUnit;
      case 'DEPARTMENT':
      case 'DEPT':
        return OrganizationLevel.department;
      case 'SECTION':
      case 'SECT':
        return OrganizationLevel.section;
      default:
        return OrganizationLevel.unknown;
    }
  }
}
