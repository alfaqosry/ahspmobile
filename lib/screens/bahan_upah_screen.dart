import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:getwidget/getwidget.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:ahsp2/services/tugas_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BahanUpahScreen extends StatefulWidget {
  final String id;

  const BahanUpahScreen({super.key, required this.id});

  @override
  State<BahanUpahScreen> createState() => _BahanUpahScreenState();
}

class _BahanUpahScreenState extends State<BahanUpahScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: GFColors.DARK),
        backgroundColor: GFColors.WHITE,
        elevation: 0,
        title: Text("AHSP"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(30.0),
          child: GFTabBar(
            tabBarHeight: 35,
            tabBarColor: GFColors.WHITE,
            length: 2,
            controller: tabController,
            tabs: [
              Text(
                'Bahan',
                style: TextStyle(color: GFColors.DARK),
              ),
              Text(
                'Pekerja',
                style: TextStyle(color: GFColors.DARK),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Color.fromRGBO(246, 249, 255, 1),
        child: ListView(
          children: <Widget>[
            GFTabBarView(
              controller: tabController,
              children: <Widget>[
                Consumer<TugasProvider>(
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
                            titleText: value.harga[index].bahan.toString(),
                            subTitle: Text(
                              NumberFormat.currency(locale: 'id')
                                  .format(value.harga[index].harga),
                              style: TextStyle(color: GFColors.PRIMARY),
                            ),
                            color: GFColors.WHITE,
                            icon: Icon(Ionicons.chevron_forward_outline),
                            shadow: BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 0,
                                blurRadius: 0,
                                offset: Offset(0, 0)),
                            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                            onTap: () {
                              int idbahan = value.harga[index].id_bahan;
                              int idtugas = int.parse(widget.id);
                              String bahan = value.harga[index].bahan;

                              context.goNamed('bahan_upah.create',
                                  pathParameters: <String, String>{
                                    "idbahan": idbahan.toString(),
                                    "id": idtugas.toString(),
                                    "bahan": bahan
                                  });
                            },
                            radius: 5,
                            margin: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                          );
                        },
                        itemCount: value.harga.length,
                      );
                    }
                  },
                ),
                Center(
                  child: Icon(
                    Icons.music_note,
                    size: 150,
                    color: Colors.grey.withOpacity(0.44),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
