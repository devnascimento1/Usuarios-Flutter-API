import 'package:flutter/material.dart';
import 'package:listausuarios/src/shared/user.dart';
import 'package:listausuarios/src/shared/user_service.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  late Future<List<User>> futureUsers;
  final UserService userService = UserService();

  final TextEditingController tituloController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController =
      TextEditingController(); // Added for email
  final TextEditingController pictureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(child: userForm()),
      ),
    );
  }

  Widget userForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Cadastro de usuário",
            style: Theme.of(context).textTheme.displaySmall),
        Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: firstnameController,
                    decoration: const InputDecoration(
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
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: TextField(
                //     controller: pictureController,
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(),
                //       labelText: 'Link da foto de perfil',
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.all(8.0),
                //   child: DropdownMenu(
                //     requestFocusOnTap: false,
                //     hintText: "Título",
                //     expandedInsets: EdgeInsets.zero,
                //     dropdownMenuEntries: [
                //       //"mr", "ms", "mrs", "miss", "dr", ""
                //       DropdownMenuEntry(
                //           value: () {
                //             tituloController.text = "mr";
                //           },
                //           label: "mr"),
                //       DropdownMenuEntry(
                //           value: () {
                //             tituloController.text = "ms";
                //           },
                //           label: "ms"),
                //       DropdownMenuEntry(
                //           value: () {
                //             tituloController.text = "mrs";
                //           },
                //           label: "mrs"),
                //       DropdownMenuEntry(
                //           value: () {
                //             tituloController.text = "miss";
                //           },
                //           label: "miss"),
                //       DropdownMenuEntry(
                //           value: () {
                //             tituloController.text = "dr";
                //           },
                //           label: "dr")
                //     ],
                //   ),
                // ),
              ]),
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 35),
            height: 40,
            width: 230,
            child: FilledButton(
              onPressed: _addUser,
              child: Text("Cadastrar"),
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
    );
  }

  //metodo para adiocionar o
  void _addUser() {
    if (firstnameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      userService
          .createUser(User(
        id: '', // ID é gerado pela API, não precisa enviar
        title: tituloController
            .text, // Incluído, assumindo que você ainda quer enviar isso
        firstName: firstnameController.text,
        lastName: lastnameController.text,
        email: emailController.text,
        picture: pictureController.text, // Incluído, assumindo que é necessário
      ))
          .then((newUser) {
        _showSnackbar('User added successfully!');
        _refreshUserList();
        Navigator.pop(context, futureUsers);
      }).catchError((error) {
        _showSnackbar('Failed to add user: $error');
      });
    } else {
      _showSnackbar('Please fill in all fields.');
    }
  }

  void _refreshUserList() {
    setState(() {
      futureUsers = userService.getUsers();
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
