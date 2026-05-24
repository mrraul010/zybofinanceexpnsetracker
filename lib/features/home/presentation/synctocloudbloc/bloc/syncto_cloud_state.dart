part of 'syncto_cloud_bloc.dart';

abstract class SynctoCloudState extends Equatable {
  const SynctoCloudState();

  @override
  List<Object?> get props => [];
}

class SynctoCloudInitial extends SynctoCloudState {}

class SynctoCloudInProgress extends SynctoCloudState {}

class SynctoCloudSucess extends SynctoCloudState {}

class SynctoCloudFailure extends SynctoCloudState {
  final String? error;
  const SynctoCloudFailure({this.error});
  @override
  List<Object?> get props => [error];
}
