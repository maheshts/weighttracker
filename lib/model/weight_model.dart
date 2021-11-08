import 'package:hive/hive.dart';
part 'weight_model.g.dart';

@HiveType(typeId: 0)
class WeightModel {
  @HiveField(0)
  final int? srNum;
  @HiveField(1)
  final String? dateStamp;
  @HiveField(2)
  final double? weightNum;
  @HiveField(3)
  final String? timeStamp;

  WeightModel({
    this.srNum,
    this.dateStamp,
    this.weightNum,
    this.timeStamp,
  });
}
