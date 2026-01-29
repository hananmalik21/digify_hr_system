/// ABS lookup type codes. Use with [absLookupValuesForCodeProvider] instead of raw strings.
enum AbsLookupCode {
  empCategory('EMP_CATEGORY'),
  contractType('CONTRACT_TYPE'),
  empType('EMP_TYPE'),
  gender('GENDER'),
  religionCode('RELIGION_CODE'),
  maritalStatus('MARITAL_STATUS'),
  accrualMethod('ACCRUAL_METHOD');

  const AbsLookupCode(this.code);
  final String code;
}
