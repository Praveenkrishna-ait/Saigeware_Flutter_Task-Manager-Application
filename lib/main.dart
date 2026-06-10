import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/core/constants/app_constants.dart';
import 'package:task_manager/core/theme/app_theme.dart';
import 'package:task_manager/data/datasources/local_task_datasource_impl.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/repositories/task_repository_impl.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';
import 'package:task_manager/presentation/providers/filter_provider.dart';
import 'package:task_manager/presentation/providers/task_list_provider.dart';
import 'package:task_manager/presentation/screens/task_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(TaskModelAdapter());

  // Initialize data source
  final dataSource = LocalTaskDataSourceImpl();
  await dataSource.init();

  runApp(MyApp(dataSource: dataSource));
}

class MyApp extends StatelessWidget {
  final LocalTaskDataSourceImpl dataSource;

  const MyApp({super.key, required this.dataSource});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalTaskDataSourceImpl>.value(value: dataSource),
        Provider<TaskRepository>(
          create: (ctx) =>
              TaskRepositoryImpl(ctx.read<LocalTaskDataSourceImpl>()),
        ),
        ChangeNotifierProxyProvider<TaskRepository, TaskListProvider>(
          create: (ctx) => TaskListProvider(ctx.read<TaskRepository>()),
          update: (_, repo, __) => TaskListProvider(repo),
        ),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home: const TaskListScreen(),
      ),
    );
  }
}
