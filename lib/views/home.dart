import 'package:app/app_theme.dart';
import 'package:app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1E1E3F),
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/images/moovetag.svg', // Replace with your SVG asset path
              height: 40, // Adjust the size as needed
            ),
            SizedBox(width: 12,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Home", style: AppTheme.darkTheme.textTheme.headlineMedium,),
                if (_authService.currentUser != null)
                  Text(
                    "Olá, ${_authService.currentUser!.displayName}", 
                    style: AppTheme.darkTheme.textTheme.bodySmall,
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _handleNotifications,
            icon: Icon(
              Icons.notifications_outlined,
              color: AppTheme.darkTheme.iconTheme.color,
            ),
            tooltip: 'Notificações',
          ),
          IconButton(
            onPressed: _handleLogout,
            icon: Icon(
              Icons.logout_outlined,
              color: AppTheme.darkTheme.iconTheme.color,
            ),
            tooltip: 'Sair',
          ),
        ]
      ),
      body: ListView(
        
        children: <Widget>[
          SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.qr_code_2_outlined),
            style: ListTileStyle.list,
            
            title: const Text('Ler tags'),
            
            onTap: () {
              // TODO: Implement navigation or action for "Ler tags"
              context.push("/readTags");
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            style: ListTileStyle.list,
            title: const Text('Visualizar grupos de tags'),
            
            onTap: () {
              // TODO: Implement navigation or action for "Visualizar grupos de tags"
              context.push("/groupList");
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Saída'),
        content: Text('Deseja realmente sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Sair'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      try {
        await _authService.signOut();
        if (mounted) {
          context.go('/'); // Navegar para login
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao fazer logout: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _handleNotifications() {
    // Implementar funcionalidade de notificações
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.notifications_outlined),
            SizedBox(width: 8),
            Text('Notificações'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.info_outline, color: Colors.blue),
              ),
              title: Text('Sistema atualizado'),
              subtitle: Text('Nova versão disponível'),
              trailing: Text('2h'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Icon(Icons.nfc, color: Colors.green),
              ),
              title: Text('Tag lida com sucesso'),
              subtitle: Text('TAG-001 foi escaneada'),
              trailing: Text('5h'),
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange[100],
                child: Icon(Icons.group_outlined, color: Colors.orange),
              ),
              title: Text('Novo grupo criado'),
              subtitle: Text('Grupo "Escritório" adicionado'),
              trailing: Text('1d'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar "Ver todas as notificações"
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Funcionalidade "Ver todas" será implementada'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Ver todas'),
          ),
        ],
      ),
    );
  }
}
