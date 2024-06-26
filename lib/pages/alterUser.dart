import 'package:flutter/material.dart';
import '../src/shared/user.dart';
import '../src/shared/user_service.dart';

class AlterUserPage extends StatefulWidget {
  const AlterUserPage({super.key, required this.user});
  final User user;
  @override
  State<AlterUserPage> createState() => _AlterUserPageState();
}

class _AlterUserPageState extends State<AlterUserPage> {
  late Future<User> futureUsers;
  UserService userService = UserService();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // Added for email
  final TextEditingController pictureController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    tituloController.text = widget.user.title;
    firstnameController.text = widget.user.firstName;
    lastnameController.text = widget.user.lastName;
    emailController.text = widget.user.email;
    pictureController.text = widget.user.picture;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Alteração de dados",
                  style: Theme.of(context).textTheme.displaySmall),
              Padding(
                padding: EdgeInsets.all(22.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: firstnameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nome',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: lastnameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Sobrenome',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          controller: pictureController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Link da foto de perfil',
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DropdownMenu(
                          requestFocusOnTap: false,
                          controller: tituloController,
                          expandedInsets: EdgeInsets.zero,
                          dropdownMenuEntries: [
                            //"mr", "ms", "mrs", "miss", "dr", ""
                            DropdownMenuEntry(
                                value: () {
                                  tituloController.text = "mr";
                                },
                                label: "mr"),
                            DropdownMenuEntry(
                                value: () {
                                  tituloController.text = "ms";
                                },
                                label: "ms"),
                            DropdownMenuEntry(
                                value: () {
                                  tituloController.text = "mrs";
                                },
                                label: "mrs"),
                            DropdownMenuEntry(
                                value: () {
                                  tituloController.text = "miss";
                                },
                                label: "miss"),
                            DropdownMenuEntry(
                                value: () {
                                  tituloController.text = "dr";
                                },
                                label: "dr")
                          ],
                        ),
                      ),
                    ]),
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 35),
                  height: 40,
                  width: 230,
                  child: FilledButton(
                    onPressed: () {
                      _updateUser(widget.user);
                    },
                    child: const Text("Salvar"),
                  )),
              SizedBox(
                  height: 40,
                  width: 230,
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancelar")))
            ],
          ),
        ),
      ),
    );
  }

  void _updateUser(User user) {
    // Inicializa um Map para armazenar apenas os campos permitidos para atualização
    Map<String, dynamic> dataToUpdate = {
      'firstName': firstnameController.text,
      'lastName': lastnameController.text,
      'picture': pictureController.text,
            'title': tituloController.text,
      // Não inclua 'email' pois é proibido atualizar
    };

    if (tituloController.text.isNotEmpty &&
        firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        pictureController.text.isNotEmpty) {
      userService.updateUser(user.id, dataToUpdate).then((updatedUser) {
        _showSnackbar('User updated successfully!');
        _refreshUserList(user.id);
        Navigator.pop(context, updatedUser);
      }).catchError((error) {
        _showSnackbar('Failed to update user: $error');
      });
    }
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
