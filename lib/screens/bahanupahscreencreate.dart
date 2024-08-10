import 'package:ahsp2/services/tugas_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';

class BahanUpahScreenCreate extends StatefulWidget {
  int? idtugas;
  int? idbahan;
  String bahan;

  BahanUpahScreenCreate(
      {super.key, this.idtugas, this.idbahan, required this.bahan});

  @override
  State<BahanUpahScreenCreate> createState() => _BahanUpahScreenCreateState();
}

class _BahanUpahScreenCreateState extends State<BahanUpahScreenCreate> {
  TextEditingController _hargaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _hargaController.dispose();

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
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Color.fromRGBO(255, 255, 255, 1)),
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.bahan,
                    style: TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Masukan Harga",
                      ),
                      controller: _hargaController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga tidak boleh kosong';
                        }
                        return null;
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: const Size(500, 40)),
                        onPressed: () {
                          Map creds = {
                            "harga": _hargaController.text,
                            "bahan_id": widget.idbahan,
                            "tugas_id": widget.idtugas,
                          };
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            Provider.of<TugasProvider>(context, listen: false)
                                .storeHarga(creds: creds);

                            Center(
                              child: LoadingAnimationWidget.waveDots(
                                color: GFColors.DARK,
                                size: 50,
                              ),
                            );
                            int? idtugass = widget.idtugas;
                            Provider.of<TugasProvider>(context, listen: false)
                                .getHargaBahan(idtugass!);
                            context.go('/bahan_upah/$idtugass');
                          }
                        },
                        child: const Text('Simpan'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
