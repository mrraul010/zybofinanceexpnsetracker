part of 'syncto_cloud_bloc.dart';

abstract class SynctoCloudEvent extends Equatable {
  const SynctoCloudEvent();

  @override
  List<Object> get props => [];
}

class StartCloudSync extends SynctoCloudEvent {}