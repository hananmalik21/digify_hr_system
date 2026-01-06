import 'package:digify_hr_system/core/enums/time_management_enums.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/holiday_card.dart';
import 'package:digify_hr_system/features/time_management/presentation/widgets/public_holidays/components/monthly_holiday_group.dart';

/// Mock data source for public holidays
/// This provides mock data for development and testing
/// In production, this will be replaced with actual API calls
class PublicHolidaysMockDataSource {
  PublicHolidaysMockDataSource._();

  /// Get mock holiday groups organized by month
  static List<MonthlyHolidayGroupData> getMockHolidayGroups() {
    return [
      MonthlyHolidayGroupData(
        monthYear: 'January 2025',
        holidays: [
          HolidayCardData(
            id: '1',
            day: 1,
            month: 'Jan',
            nameEn: "New Year's Day",
            nameAr: 'رأس السنة الميلادية',
            descriptionEn: 'Celebration of the first day of the Gregorian calendar year',
            descriptionAr: 'الاحتفال باليوم الأول من السنة الميلادية',
            type: HolidayType.fixed,
            paymentStatus: HolidayPaymentStatus.paid,
            date: '01/01/2025',
            appliesTo: 'all',
          ),
          HolidayCardData(
            id: '2',
            day: 27,
            month: 'Jan',
            nameEn: "Isra and Mi'raj",
            nameAr: 'الإسراء والمعراج',
            descriptionEn: 'Islamic holiday commemorating the night journey of Prophet Muhammad',
            descriptionAr: 'عيد إسلامي يحيي ذكرى رحلة الإسراء والمعراج للنبي محمد صلى الله عليه وسلم',
            type: HolidayType.islamic,
            paymentStatus: HolidayPaymentStatus.paid,
            date: '27/01/2025',
            appliesTo: 'all',
          ),
        ],
      ),
      MonthlyHolidayGroupData(
        monthYear: 'February 2025',
        holidays: [
          HolidayCardData(
            id: '3',
            day: 25,
            month: 'Feb',
            nameEn: 'National Day',
            nameAr: 'العيد الوطني',
            descriptionEn: 'Kuwait National Day - Commemorates the ascension of Sheikh Abdullah Al-Salem Al-Sabah',
            descriptionAr: 'اليوم الوطني للكويت - إحياء ذكرى تولي الشيخ عبدالله السالم الصباح الحكم',
            type: HolidayType.fixed,
            paymentStatus: HolidayPaymentStatus.paid,
            date: '25/02/2025',
            appliesTo: 'all',
          ),
          HolidayCardData(
            id: '4',
            day: 26,
            month: 'Feb',
            nameEn: 'Liberation Day',
            nameAr: 'عيد التحرير',
            descriptionEn: 'Liberation Day - Commemorates the liberation of Kuwait in 1991',
            descriptionAr: 'عيد التحرير - إحياء ذكرى تحرير الكويت في عام 1991',
            type: HolidayType.fixed,
            paymentStatus: HolidayPaymentStatus.paid,
            date: '26/02/2025',
            appliesTo: 'all',
          ),
        ],
      ),
      MonthlyHolidayGroupData(
        monthYear: 'March 2025',
        holidays: [
          HolidayCardData(
            id: '5',
            day: 1,
            month: 'Mar',
            nameEn: 'Eid Al-Fitr (Day 1)',
            nameAr: 'عيد الفطر (اليوم الأول)',
            descriptionEn: 'Celebration marking the end of Ramadan fasting',
            descriptionAr: 'عيد يحتفل بنهاية صيام شهر رمضان المبارك',
            type: HolidayType.islamic,
            paymentStatus: HolidayPaymentStatus.paid,
            date: '01/03/2025',
            appliesTo: 'all',
          ),
          HolidayCardData(
            id: '6',
            day: 2,
            month: 'Mar',
            nameEn: 'Eid Al-Fitr (Day 2)',
            nameAr: 'عيد الفطر (اليوم الثاني)',
            descriptionEn: 'Second day of Eid Al-Fitr celebration',
            descriptionAr: 'اليوم الثاني من عيد الفطر المبارك',
            type: HolidayType.islamic,
            paymentStatus: HolidayPaymentStatus.paid,
            date: '02/03/2025',
            appliesTo: 'all',
          ),
          HolidayCardData(
            id: '7',
            day: 3,
            month: 'Mar',
            nameEn: 'Eid Al-Fitr (Day 3)',
            nameAr: 'عيد الفطر (اليوم الثالث)',
            descriptionEn: 'Third day of Eid Al-Fitr celebration',
            descriptionAr: 'اليوم الثالث من عيد الفطر المبارك',
            type: HolidayType.islamic,
            paymentStatus: HolidayPaymentStatus.paid,
            date: '03/03/2025',
            appliesTo: 'all',
          ),
        ],
      ),
    ];
  }

  /// Get mock statistics for public holidays
  static PublicHolidaysStats getMockStats() {
    return const PublicHolidaysStats(totalHolidays: 26, fixedHolidays: 6, islamicHolidays: 20, paidHolidays: 26);
  }
}

/// Statistics data model for public holidays
class PublicHolidaysStats {
  final int totalHolidays;
  final int fixedHolidays;
  final int islamicHolidays;
  final int paidHolidays;

  const PublicHolidaysStats({
    required this.totalHolidays,
    required this.fixedHolidays,
    required this.islamicHolidays,
    required this.paidHolidays,
  });
}
