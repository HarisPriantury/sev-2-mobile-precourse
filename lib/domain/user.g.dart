// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 23;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      fields[0] as dynamic,
      registeredAt: fields[7] as DateTime?,
      availability: fields[8] as String,
      email: fields[9] as String,
      profileUrl: fields[11] as String,
      userType: fields[12] as UserType,
      phoneNumber: fields[13] as String,
      suiteId: fields[15] as String?,
      secondPhoneNumber: fields[14] as String?,
      projectsInfo: fields[24] as ProjectsInfo?,
      hiringInfo: fields[25] as HiringInfo?,
      subscriptionInfo: fields[26] as SubscriptionInfo?,
      storyPointInfo: fields[27] as StoryPointInfo?,
      workInfo: fields[28] as WorkInfo?,
      isRSP: fields[16] as bool?,
      isOnboard: fields[17] as bool?,
      userStatus: fields[18] as String?,
      statusIcon: fields[19] as String?,
      currentTask: fields[20] as String?,
      device: fields[21] as String?,
      isWorking: fields[22] as bool?,
      currentChannel: fields[23] as String?,
      uri: fields[1] as dynamic,
      typeName: fields[2] as dynamic,
      type: fields[3] as dynamic,
      name: fields[4] as dynamic,
      fullName: fields[5] as dynamic,
      status: fields[6] as dynamic,
      avatar: fields[255] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(29)
      ..writeByte(7)
      ..write(obj.registeredAt)
      ..writeByte(8)
      ..write(obj.availability)
      ..writeByte(9)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.profileUrl)
      ..writeByte(12)
      ..write(obj.userType)
      ..writeByte(13)
      ..write(obj.phoneNumber)
      ..writeByte(14)
      ..write(obj.secondPhoneNumber)
      ..writeByte(15)
      ..write(obj.suiteId)
      ..writeByte(16)
      ..write(obj.isRSP)
      ..writeByte(17)
      ..write(obj.isOnboard)
      ..writeByte(18)
      ..write(obj.userStatus)
      ..writeByte(19)
      ..write(obj.statusIcon)
      ..writeByte(20)
      ..write(obj.currentTask)
      ..writeByte(21)
      ..write(obj.device)
      ..writeByte(22)
      ..write(obj.isWorking)
      ..writeByte(23)
      ..write(obj.currentChannel)
      ..writeByte(24)
      ..write(obj.projectsInfo)
      ..writeByte(25)
      ..write(obj.hiringInfo)
      ..writeByte(26)
      ..write(obj.subscriptionInfo)
      ..writeByte(27)
      ..write(obj.storyPointInfo)
      ..writeByte(28)
      ..write(obj.workInfo)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.uri)
      ..writeByte(2)
      ..write(obj.typeName)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.fullName)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(255)
      ..write(obj.avatar);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProjectsInfoAdapter extends TypeAdapter<ProjectsInfo> {
  @override
  final int typeId = 24;

  @override
  ProjectsInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectsInfo(
      totalProjects: fields[0] as int,
      totalStoryPoints: fields[1] as double,
      totalFinishedStoryPoints: fields[2] as double,
      totalDepositStoryPoints: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectsInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.totalProjects)
      ..writeByte(1)
      ..write(obj.totalStoryPoints)
      ..writeByte(2)
      ..write(obj.totalFinishedStoryPoints)
      ..writeByte(3)
      ..write(obj.totalDepositStoryPoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectsInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionInfoAdapter extends TypeAdapter<SubscriptionInfo> {
  @override
  final int typeId = 25;

  @override
  SubscriptionInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubscriptionInfo(
      fields[0] as SubscriptionStatus,
      fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SubscriptionInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.expiredDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StoryPointInfoAdapter extends TypeAdapter<StoryPointInfo> {
  @override
  final int typeId = 26;

  @override
  StoryPointInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryPointInfo(
      totalFinishedStoryPoints: fields[0] as double?,
      totalIncome: fields[1] as String?,
      totalWithdrawableIncome: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, StoryPointInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.totalFinishedStoryPoints)
      ..writeByte(1)
      ..write(obj.totalIncome)
      ..writeByte(2)
      ..write(obj.totalWithdrawableIncome);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryPointInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HiringInfoAdapter extends TypeAdapter<HiringInfo> {
  @override
  final int typeId = 27;

  @override
  HiringInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiringInfo(
      fields[0] as int?,
      fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HiringInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.totalJobs)
      ..writeByte(1)
      ..write(obj.totalHired);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiringInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkInfoAdapter extends TypeAdapter<WorkInfo> {
  @override
  final int typeId = 28;

  @override
  WorkInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkInfo(
      fields[0] as DateTime,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorkInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.joinedDate)
      ..writeByte(1)
      ..write(obj.occupation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserTypeAdapter extends TypeAdapter<UserType> {
  @override
  final int typeId = 29;

  @override
  UserType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserType.connect;
      case 1:
        return UserType.refactory;
      case 2:
        return UserType.suite;
      case 3:
        return UserType.rsp;
      default:
        return UserType.connect;
    }
  }

  @override
  void write(BinaryWriter writer, UserType obj) {
    switch (obj) {
      case UserType.connect:
        writer.writeByte(0);
        break;
      case UserType.refactory:
        writer.writeByte(1);
        break;
      case UserType.suite:
        writer.writeByte(2);
        break;
      case UserType.rsp:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionStatusAdapter extends TypeAdapter<SubscriptionStatus> {
  @override
  final int typeId = 30;

  @override
  SubscriptionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionStatus.preparation;
      case 1:
        return SubscriptionStatus.active;
      case 2:
        return SubscriptionStatus.expired;
      default:
        return SubscriptionStatus.preparation;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionStatus obj) {
    switch (obj) {
      case SubscriptionStatus.preparation:
        writer.writeByte(0);
        break;
      case SubscriptionStatus.active:
        writer.writeByte(1);
        break;
      case SubscriptionStatus.expired:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
