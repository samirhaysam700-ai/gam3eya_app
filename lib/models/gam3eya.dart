import 'package:hive/hive.dart';
part 'gam3eya.g.dart';

@HiveType(typeId: 0)
class Gam3eya extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  double totalAmount;

  @HiveField(2)
  double paidAmount;

  @HiveField(3)
  int installmentDay;

  @HiveField(4)
  double installmentValue;

  @HiveField(5)
  DateTime startDate;

  @HiveField(6)
  String? note;

  Gam3eya({
    required this.name,
    required this.totalAmount,
    this.paidAmount = 0,
    required this.installmentDay,
    required this.installmentValue,
    required this.startDate,
    this.note,
  });

  double get remaining => totalAmount - paidAmount;
}
