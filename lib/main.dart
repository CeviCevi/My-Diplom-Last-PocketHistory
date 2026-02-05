import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:history/const/security/security.dart';
import 'package:history/const/style/app_theme.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/data%20services/achive_service/achive_service.dart';
import 'package:history/data/service/data%20services/ar_image_service/ar_image_service.dart';
import 'package:history/data/service/data%20services/comment_service.dart/comment_service.dart';
import 'package:history/data/service/data%20services/marker_service/marker_service.dart';
import 'package:history/data/service/data%20services/object_service/object_service.dart';
import 'package:history/data/service/data%20services/user_service/user_service.dart';
import 'package:history/data/state_managment/gui_manager/gui_manager_cubit.dart';
import 'package:history/presentation/screen/auth/auth_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheService.instance.init();
  await Supabase.initialize(
    url: Security.supaUrl,
    anonKey: Security.supaApiKey,
  );

  Future(() {
    UserService().initUsers();
    ObjectService().initDatabase();
    MarkerService().initMarkers();
    CommentService().initComments();
    ArImageService().initArImages();
    AchiveService().initAchievements();
  });

  runApp(
    DevicePreview(
      enabled: !kReleaseMode || !Platform.isAndroid,
      tools: const [...DevicePreview.defaultTools],
      builder: (context) => MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GuiManagerCubit>(
          create: (BuildContext context) => GuiManagerCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.ligth,
        darkTheme: AppTheme.dark,
        home: RegisterScreen(),
      ),
    );
  }
}
