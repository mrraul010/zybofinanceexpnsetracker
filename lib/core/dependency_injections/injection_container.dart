import 'package:get_it/get_it.dart';
import 'package:zyboexpensetracker/core/network/api_client.dart';
import 'package:zyboexpensetracker/features/auth/data/repositories/auth_repository.dart';
import 'package:zyboexpensetracker/features/auth/onboarding_active_screen/presentation/bloc/create_account_bloc.dart';
import 'package:zyboexpensetracker/features/auth/presentation/send_otpbloc/bloc/send_otp_bloc_bloc.dart';
import 'package:zyboexpensetracker/features/home/data/datasources/cloud_sync_repository.dart';
import 'package:zyboexpensetracker/features/home/data/datasources/home_local_datasource.dart';
import 'package:zyboexpensetracker/features/home/databases/database_helpers.dart';
import 'package:zyboexpensetracker/features/home/presentation/bloc/home_bloc.dart';
import 'package:zyboexpensetracker/features/home/presentation/synctocloudbloc/bloc/syncto_cloud_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(sl()));

  sl.registerFactory<SendOtpBlocBloc>(() => SendOtpBlocBloc(sl()));

  sl.registerFactory<CreateAccountBloc>(() => CreateAccountBloc(sl()));

  sl.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper.instance);

  sl.registerLazySingleton<HomeLocalDatasource>(
    () => HomeLocalDatasource(sl()),
  );

  sl.registerLazySingleton<CloudSyncRepository>(
    () => CloudSyncRepository(sl()),
  );

  sl.registerFactory<HomeBloc>(() => HomeBloc(sl()));
  sl.registerFactory<SynctoCloudBloc>(() => SynctoCloudBloc(sl(), sl()));
}
