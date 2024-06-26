import 'package:flutter/material.dart';
import 'package:listausuarios/pages/alterUser.dart';
import 'package:listausuarios/pages/homePage.dart';
import 'package:listausuarios/src/shared/user.dart';
import '../src/shared/user_service.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.user});
  final User user;
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<User> futureUsers;
  final UserService userService = UserService();
  @override
  void initState() {
    super.initState();
    futureUsers = userService.getUserById(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    _refreshUserList(widget.user.id);
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        centerTitle: true,
        leading: BackButton(onPressed: () {
          Navigator.pop(context, futureUsers);
        }),
      ),
      body: FutureBuilder<User>(
          future: futureUsers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              User user = snapshot.data!;
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: verificaImagem(user)),
                      Container(
                        width: 350,
                        padding: EdgeInsets.all(15.0),
                        child: TextField(
                          controller: TextEditingController(text: user.title),
                          enabled: false,
                          decoration: InputDecoration(
                              filled: true, labelText: "Título"),
                        ),
                      ),
                      Container(
                        width: 350,
                        padding: EdgeInsets.all(15.0),
                        child: TextField(
                          controller:
                              TextEditingController(text: user.firstName),
                          enabled: false,
                          decoration:
                              InputDecoration(filled: true, labelText: "Nome"),
                        ),
                      ),
                      Container(
                        width: 350,
                        padding: EdgeInsets.all(15.0),
                        child: TextField(
                          controller:
                              TextEditingController(text: user.lastName),
                          enabled: false,
                          decoration: InputDecoration(
                              filled: true, labelText: "Sobrenome"),
                        ),
                      ),
                      Container(
                        width: 350,
                        padding: EdgeInsets.all(15.0),
                        child: TextField(
                          controller: TextEditingController(text: user.email),
                          enabled: false,
                          decoration: InputDecoration(
                              filled: true, labelText: "E-mail"),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 20, top: 30),
                          height: 40,
                          width: 230,
                          child: FilledButton(
                            onPressed: () async {
                              final updatedUser = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlterUserPage(
                                    user: user,
                                  ),
                                ),
                              );
                              setState(() {
                                user = updatedUser;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.edit),
                                Text("Alterar"),
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 40,
                        width: 230,
                        child: ElevatedButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.delete),
                              Text("Deletar"),
                            ],
                          ),
                          onPressed: () {
                            deleteShowDialog();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget verificaImagem(User user) {
    if (user.picture.isEmpty || user.picture == "default_picture_url") {
      return Image.asset(
        "assets/image/userUndefined.png",
        height: 150,
        width: 150,
      );
    } else {
      return Image.network(
        user.picture,
        fit: BoxFit.cover,
        height: 150,
        width: 150,
      );
    }
  }

  void deleteShowDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Excluir"),
              content: const Text(
                  "Ao excluir esse perfil não será possível recupera-lo, tem certeza de querer exclui-lo?"),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Voltar")),
                    ElevatedButton(
                        onPressed: () {
                          _deleteUser(widget.user.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()),
                          );
                        },
                        child: const Text("Excluir"))
                  ],
                )
              ],
            ));
  }

  void _deleteUser(String id) {
    userService.deleteUser(id).then((_) {
      _showSnackbar('User deleted successfully!');
      _refreshUserList(id);
    }).catchError((error) {
      _showSnackbar('Failed to delete user.');
    });
  }

  void _refreshUserList(String id) {
    setState(() {
      futureUsers = userService.getUserById(id);
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
