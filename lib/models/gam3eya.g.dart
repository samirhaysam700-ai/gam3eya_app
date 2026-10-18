// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gam3eya.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class Gam3eyaAdapter extends TypeAdapter<Gam3eya> {
  @override
  final int typeId = 0;

  @override
  Gam3eya read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gam3eya(
      name: fields[0] as String,
      totalAmount: fields[1] as double,
      paidAmount: fields[2] as double,
      installmentDay: fields[3] as int,
      installmentValue: fields[4] as double,
      startDate: fields[5] as DateTime,
      note: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Gam3eya obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.totalAmount)
      ..writeByte(2)
      ..write(obj.paidAmount)
      ..writeByte(3)
      ..write(obj.installmentDay)
      ..writeByte(4)
      ..write(obj.installmentValue)
      ..writeByte(5)
      ..write(obj.startDate)
      ..writeByte(6)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Gam3eyaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
