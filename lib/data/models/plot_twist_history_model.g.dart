// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plot_twist_history_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlotTwistHistoryModelAdapter extends TypeAdapter<PlotTwistHistoryModel> {
  @override
  final int typeId = 0;

  @override
  PlotTwistHistoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlotTwistHistoryModel(
      id: fields[0] as String,
      inputText: fields[1] as String,
      generatedContent: fields[2] as String,
      format: fields[3] as String,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PlotTwistHistoryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.inputText)
      ..writeByte(2)
      ..write(obj.generatedContent)
      ..writeByte(3)
      ..write(obj.format)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlotTwistHistoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
