import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:developer' as developer;
import 'package:zyboexpensetracker/features/home/data/datasources/cloud_sync_repository.dart';
import 'package:zyboexpensetracker/features/home/data/datasources/home_local_datasource.dart';

part 'syncto_cloud_event.dart';
part 'syncto_cloud_state.dart';

class SynctoCloudBloc extends Bloc<SynctoCloudEvent, SynctoCloudState> {
  final HomeLocalDatasource dataSource;
  final CloudSyncRepository syncRepo;

  SynctoCloudBloc(this.dataSource, this.syncRepo)
    : super(SynctoCloudInitial()) {
    on<StartCloudSync>((event, emit) async {
      developer.log(
        'SYNC BLOC: Initiating Strict Cloud Sync Workflow...',
        name: 'Sync',
      );

      emit(SynctoCloudInProgress());

      try {
        final deletedTxList = await dataSource.getSoftDeletedItems(
          'transactions',
        );
        final deletedTxIds = deletedTxList
            .map((e) => e['id'] as String)
            .toList();

        if (deletedTxIds.isNotEmpty) {
          developer.log(
            'SYNC: Purging ${deletedTxIds.length} deleted transactions.',
            name: 'Sync',
          );
          final success = await syncRepo.clearCloudDeletions(
            '/transactions/delete/',
            deletedTxIds,
          );

          if (success) {
            await dataSource.hardDeleteItems('transactions', deletedTxIds);
          }
        }

        final deletedCatList = await dataSource.getSoftDeletedItems(
          'categories',
        );
        final deletedCatIds = deletedCatList
            .map((e) => e['id'] as String)
            .toList();

        if (deletedCatIds.isNotEmpty) {
          developer.log(
            'SYNC: Purging ${deletedCatIds.length} deleted categories.',
            name: 'Sync',
          );
          final success = await syncRepo.clearCloudDeletions(
            '/categories/delete/',
            deletedCatIds,
          );
          if (success) {
            await dataSource.hardDeleteItems('categories', deletedCatIds);
          }
        }

        final unsyncedCategories = await dataSource.getUnsyncedItems(
          'categories',
        );

        if (unsyncedCategories.isNotEmpty) {
          developer.log(
            'SYNC: Uploading ${unsyncedCategories.length} new categories.',
            name: 'Sync',
          );
          final syncedCatIds = await syncRepo.transmitCategories(
            unsyncedCategories,
          );

          if (syncedCatIds.isNotEmpty) {
            await dataSource.updateSyncStatus('categories', syncedCatIds);
          }
        }
        final unsyncedTransactions = await dataSource.getUnsyncedItems(
          'transactions',
        );

        if (unsyncedTransactions.isNotEmpty) {
          developer.log(
            'SYNC: Uploading ${unsyncedTransactions.length} new transactions.',
            name: 'Sync',
          );
          final syncedTxIds = await syncRepo.transmitTransactions(
            unsyncedTransactions,
          );

          if (syncedTxIds.isNotEmpty) {
            await dataSource.updateSyncStatus('transactions', syncedTxIds);
          }
        }
        developer.log(
          'SYNC BLOC: Cloud Sync Successfully Completed!',
          name: 'Sync',
        );
        emit(SynctoCloudSucess());
      } catch (e) {
        developer.log(
          'SYNC BLOC ERROR: Pipeline failure -> $e',
          name: 'Sync',
          error: e,
        );
        emit(
          SynctoCloudFailure(
            error:
                "Sync failed. Please check your internet connection and try again.",
          ),
        );
      }
    });
  }
}
