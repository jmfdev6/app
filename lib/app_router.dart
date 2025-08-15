import 'package:app/views/auth/login.dart';
import 'package:app/views/groups/create_groups.dart';
import 'package:app/views/groups/group_list.dart';
import 'package:app/views/groups/select_group.dart';
import 'package:app/views/home.dart';
import 'package:app/views/tag/details_tag.dart';
import 'package:app/views/tag/leitura_tags.dart';
import 'package:app/service/auth_service.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  redirect: (context, state) {
    final authService = AuthService();
    final isAuthenticated = authService.isAuthenticated;
    final isLoginPage = state.fullPath == '/';

    // Se não está autenticado e não está na página de login
    if (!isAuthenticated && !isLoginPage) {
      return '/';
    }

    // Se está autenticado e está na página de login
    if (isAuthenticated && isLoginPage) {
      return '/home';
    }

    return null; // Não redirecionar
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/selectGroup',
      builder: (context, state) => const SelectGroupScreen(),
    ),
     GoRoute(
      path: '/groupList',
      builder: (context, state) => GroupListScreen(),
    ),
     GoRoute(
      path: '/createGroup',
      builder: (context, state) => CreateGroupScreen(),
    ),
     GoRoute(
      path: '/tagDetails',
      builder: (context, state) => DetailsTag(),
    ),
    GoRoute(
      path: '/readTags',
      builder: (context, state) => ReadTagsScreen(),
    ),
  ],
);