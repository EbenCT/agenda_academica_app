import 'package:flutter/material.dart';
import '../datos/datos_user.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userType = DataUser().userRole ?? 0; // Usa 0 como valor predeterminado si es null

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.onPrimary,
                  child: Icon(
                    Icons.person,
                    color: theme.colorScheme.primary,
                    size: 50,
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bienvenido',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildUserTypeText(userType, theme),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Perfil'),
            leading: Icon(Icons.person, color: theme.colorScheme.primary),
            onTap: () {
              Navigator.pushNamed(context, '/perfil');
            },
          ),
          _buildMenuOptions(context, userType, theme),
          ListTile(
            title: const Text('Comunicados'),
            leading: Icon(Icons.notifications, color: theme.colorScheme.primary),
              onTap: () {
                Navigator.pushNamed(context, '/comunicados');
              },
          ),
          ListTile(
            title: const Text('Calendario'),
            leading: Icon(Icons.calendar_today, color: theme.colorScheme.primary),
            onTap: () {
              Navigator.pushNamed(context, '/calendario');
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Cerrar Sesión'),
            leading: Icon(Icons.exit_to_app, color: theme.colorScheme.primary),
            onTap: () async {
              await DataUser().clearUserData(); // Limpia los datos al cerrar sesión
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/', // Ruta del login
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserTypeText(int userType, ThemeData theme) {
    String userTypeText = '';
    switch (userType) {
      case 57:
        userTypeText = 'Profesor';
        break;
      case 55:
        userTypeText = 'Estudiante';
        break;
      case 56:
        userTypeText = 'Padre/Madre/Tutor';
        break;
      default:
        userTypeText = 'Usuario';
    }
    return Text(
      userTypeText,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onPrimary,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildMenuOptions(BuildContext context, int userType, ThemeData theme) {
    List<Widget> menuOptions = [];
    if (userType == 57 || userType == 55) {
      menuOptions.add(
        ListTile(
          title: const Text('Materias'),
          leading: Icon(Icons.book, color: theme.colorScheme.primary),
          onTap: () {
            Navigator.pushNamed(context, '/materias');
          },
        ),
      );
    }
    if (userType == 57) {
      menuOptions.addAll([
        ListTile(
          title: const Text('Cursos'),
          leading: Icon(Icons.school, color: theme.colorScheme.primary),
          onTap: () {
            Navigator.pushNamed(context, '/cursos');
          },
        ),
        ListTile(
          title: const Text('Publicaciones'),
          leading: Icon(Icons.post_add, color: theme.colorScheme.primary),
          onTap: () {
            Navigator.pushNamed(context, '/publicaciones');
          },
        ),
      ]);
    }
    if (userType == 56) {
      menuOptions.add(
        ListTile(
          title: const Text('Hijos'),
          leading: Icon(Icons.family_restroom, color: theme.colorScheme.primary),
          onTap: () {
            Navigator.pushNamed(context, '/hijos');
          },
        ),
      );
    }
    if (userType == 55) {
      menuOptions.add(
        ListTile(
          title: const Text('Tareas'),
          leading: Icon(Icons.assignment, color: theme.colorScheme.primary),
          onTap: () {
            Navigator.pushNamed(context, '/publicaciones');
          },
        ),
      );
    }
    return Column(children: menuOptions);
  }
}
