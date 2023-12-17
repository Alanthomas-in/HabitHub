// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CompletedHabits.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompletedHabitsAdapter extends TypeAdapter<CompletedHabits> {
  @override
  final int typeId = 1;

  @override
  CompletedHabits read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompletedHabits(
      date: fields[0] as DateTime,
      completedHabits: (fields[1] as List).cast<Habit>(),
    );
  }

  @override
  void write(BinaryWriter writer, CompletedHabits obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.completedHabits);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompletedHabitsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
