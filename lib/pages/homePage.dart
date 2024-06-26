import 'package:flutter/material.dart';
import 'package:listausuarios/pages/addUser.dart';
import 'package:listausuarios/pages/pageUser.dart';
import 'package:listausuarios/src/shared/user.dart';
import 'package:listausuarios/src/shared/user_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<User>> futureUsers;

  final UserService userService = UserService();
  @override
  void initState() {
    super.initState();
    futureUsers = userService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    _refreshUserList();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text("Lista de usuário")),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(Icons.list), Text("Lista")],
                ),
              ),
              Tab(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(Icons.grid_view_sharp), Text("Bloco")],
              ))
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Column(
                children: [_buildUserList()],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Column(
                  children: [_buildUserCard()],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddUserPage(),
              ),
            );
            _refreshUserList();
          },
          tooltip: 'Cadastro',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return Expanded(
      child: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                User user = snapshot.data![index];
                return ListTile(
                  onTap: () async {
                    final updatedUser = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserPage(
                          user: user,
                        ),
                      ),
                    );
                    setState(() {
                      user = updatedUser;
                    });
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.picture),
                  ),
                  title: Text('${user.firstName} ${user.lastName}'),
                  subtitle: Text(user.email),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildUserCard() {
    return Expanded(
      child: FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  mainAxisExtent: 210),
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                User user = snapshot.data![index];
                return Card(
                  child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () async {
                        final updatedUser = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserPage(
                              user: user,
                            ),
                          ),
                        );
                        setState(() {
                          user = updatedUser;
                        });
                      },
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(user.picture,
                                  fit: BoxFit.cover,
                                  width: double.maxFinite,
                                  height: 150)),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                user.firstName,
                              ),
                            ),
                          )
                        ],
                      )),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _refreshUserList() {
    setState(() {
      futureUsers = userService.getUsers();
    });
  }
}
