class EmplLookupValue {
  final int lookupId;
  final String lookupCode;
  final String meaningEn;
  final String meaningAr;
  final int displaySequence;

  const EmplLookupValue({
    required this.lookupId,
    required this.lookupCode,
    required this.meaningEn,
    required this.meaningAr,
    this.displaySequence = 0,
  });

  String get labelEn => meaningEn;

  String get labelAr => meaningAr;
}
