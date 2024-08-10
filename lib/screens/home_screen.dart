import 'package:ahsp2/screens/login_screen.dart';
import 'package:ahsp2/services/auth.dart';
import 'package:ahsp2/services/tugas_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final storage = new FlutterSecureStorage();
  int currentPageIndex = 0;
  String? iduser;

  @override
  void initState() {
    super.initState();
    readToken();
  }

  void readToken() async {
    String? token = await storage.read(key: 'token');

    this.iduser = await storage.read(key: 'userid');
    if (token != null) {
      Provider.of<Auth>(context, listen: false).tryToken(token: token);
      print(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 235, 240, 250)),
        backgroundColor: GFColors.WHITE,
        elevation: 0,
        title: Text("AHSP"),
        actions: [
          CircleAvatar(backgroundColor: GFColors.FOCUS, radius: 20),
          SizedBox(
            width: 10,
          )
        ],
      ),
      drawer: Drawer(
        surfaceTintColor: GFColors.DARK,
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            if (!auth.authenticated) {
              return ListView(
                children: [
                  ListTile(
                    title: Text('Login'),
                    leading: Icon(Icons.login),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScren()));
                    },
                  ),
                ],
              );
            } else {
              return ListView(
                children: [
                  DrawerHeader(
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          auth.user?.name ?? "noname",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          auth.user?.username ?? "noemail",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          auth.user?.email ?? "noemail",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(color: Colors.blue),
                  ),
                  ListTile(
                    title: Text('Logout'),
                    leading: Icon(Icons.logout),
                    onTap: () {
                      Provider.of<Auth>(context, listen: false).logout();
                    },
                  )
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          print(index);
          setState(() {
            if (index == 1) {
              Provider.of<TugasProvider>(context, listen: false)
                  .getTugas(int.parse(iduser!));
            }
            currentPageIndex = index;
            print("id user");
            print(iduser);
          });
        },
        // indicatorColor: Colors.amber[800],
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.book),
            label: 'Tugas',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.people),
            icon: Icon(Icons.people_alt_outlined),
            label: 'Profile',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Color.fromRGBO(246, 249, 255, 1),
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: GFColors.WHITE),
                      margin: EdgeInsets.all(5),
                      child: SizedBox(
                        height: 100,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Total Tugas"),
                            Text(
                              '120',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            )
                          ],
                        )),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: GFColors.WHITE),
                      margin: EdgeInsets.all(5),
                      child: SizedBox(
                        height: 100,
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Tugas Selesai"),
                            Text(
                              '50',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            )
                          ],
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          color: Color.fromARGB(255, 246, 249, 255),
          alignment: Alignment.center,
          child: Consumer<TugasProvider>(
            builder: (context, value, child) {
              if (value.isLoading == true) {
                return Center(
                  child: LoadingAnimationWidget.waveDots(
                    color: GFColors.DARK,
                    size: 50,
                  ),
                );
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return GFListTile(
                      titleText: value.tugas[index].projek.toString(),
                      subTitleText: value.tugas[index].tahun.toString(),
                      color: GFColors.WHITE,
                      icon: Icon(Ionicons.chevron_forward_outline),
                      shadow: BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(0, 0)),
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      onTap: () {
                        int id = value.tugas[index].id;
                        Provider.of<TugasProvider>(context, listen: false)
                            .getHargaBahan(id);
                        context.go('/bahan_upah/$id');
                      },
                      radius: 5,
                      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                    );
                  },
                  itemCount: value.tugas.length,
                );
              }
            },
          ),
        ),
        Container(
            alignment: Alignment.topCenter,
            child: Container(
              width: 500,
              color: GFColors.WHITE,
              margin: EdgeInsets.all(10),
              child: Consumer<Auth>(builder: (context, auth, child) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                            backgroundColor: GFColors.DARK, radius: 30),
                        title: Text(auth.user?.name ?? "noname"),
                        subtitle: Text(auth.user?.email ?? "noemail"),
                      )
                    ],
                  ),
                );
              }),
            )),
      ][currentPageIndex],
    );
  }
}
