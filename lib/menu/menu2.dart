import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter1/tools/firebase_service.dart';

import 'package:flutter1/utils/db.dart';
import 'package:flutter1/utils/image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Menu2 extends StatelessWidget {
  const Menu2({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text('My App'),
        //   backgroundColor: const Color(0xFFDBA688),
        //   foregroundColor: Colors.white,
        //   elevation: 4.0,
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.search),
        //       onPressed: () {
        //         // Handle search button press
        //       },
        //     ),
        //     IconButton(
        //       icon: const Icon(Icons.settings),
        //       onPressed: () {
        //         // Handle settings button press
        //       },
        //     ),
        //   ],
        // ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double screenWidth = constraints.maxWidth;
            double leftWidth = screenWidth * 0.80;
            double rightWidth = screenWidth * 0.20;

            return Row(
              children: [
                ItemMenu(
                  leftWidth: leftWidth,
                  constraints: constraints,
                ),
                Container(
                  width: rightWidth,
                  color: Colors.transparent,
                  height: constraints.maxHeight,
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      double screenHeight = constraints.maxHeight;

                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            height: screenHeight,
                            color: Colors.grey[400],
                            child: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                double screenHeight2 = constraints.maxHeight;
                                double upHeight = screenHeight2 * 0.85;
                                double botHeight = screenHeight2 * 0.15;
                                return Column(
                                  children: [
                                    Container(
                                      height: upHeight,
                                      color: Colors.transparent,
                                    ),
                                    Container(
                                      height: botHeight,
                                      padding: const EdgeInsets.all(10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) =>
                                                  const Pembayaran());
                                        },
                                        style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            backgroundColor: Colors.white),
                                        child: const Icon(
                                          Icons.add,
                                          size: 70,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class Pembayaran extends StatelessWidget {
  const Pembayaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 600,
          height: 650,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Tambah Menu",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InputMenu(
                dialogContext: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InputMenu extends StatefulWidget {
  final BuildContext dialogContext;
  const InputMenu({super.key, required this.dialogContext});
  @override
  State<InputMenu> createState() => _InputMenuState();
}

class _InputMenuState extends State<InputMenu> {
  TextEditingController namaMenuController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  Uint8List? image;
  bool isLoading = false;

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);

    if (img != null) {
      setState(() {
        image = img;
      });
    } else {
      // Handle the case where no image is selected
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Form(
        child: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(top: 30, left: 50, right: 50),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(children: [
                        TextFormField(
                          controller: namaMenuController,
                          decoration: const InputDecoration(
                            labelText: "Nama Menu",
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              // Format input menjadi format yang diinginkan
                              final numericValue = int.tryParse(newValue.text);
                              if (numericValue != null) {
                                final formatter =
                                    NumberFormat("#,##0", "en_US");
                                final newString =
                                    formatter.format(numericValue);
                                return TextEditingValue(
                                  text: newString,
                                  selection: TextSelection.collapsed(
                                      offset: newString.length),
                                );
                              }
                              return newValue;
                            }),
                          ],
                          controller: hargaController,
                          decoration: const InputDecoration(
                            labelText: "Harga ",
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Stack(
                          children: [
                            image != null
                                ? Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: MemoryImage(image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 200,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "https://cdn-icons-png.flaticon.com/512/184/184725.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            Positioned(
                              bottom: -10,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              final numericValue = int.tryParse(
                                  hargaController.text.replaceAll(',', ''));
                              String namaMenu = namaMenuController.text;
                              int hargaMenu = numericValue!;
                              setState(() {
                                isLoading = true;
                              });
                              // Menampilkan nilai yang ditetapkan
                              if (image != null) {
                                final gambar =
                                    ImageUploader(image: image!).uploadImage();
                                String? gambar2 = await gambar;

                                await TambahMenu(
                                  name: namaMenu,
                                  price: hargaMenu,
                                  image: gambar2,
                                ).tambahMenu();
                              } else {
                                // Handle case when no image is selected
                                print('No image selected');
                              }
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(widget.dialogContext).pop();
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(fontSize: 20),
                            ))
                      ])),
          ],
        ),
      ),
    );
  }
}

class ItemMenu extends StatefulWidget {
  final double leftWidth;
  final BoxConstraints constraints;
  const ItemMenu(
      {super.key, required this.leftWidth, required this.constraints});

  @override
  State<ItemMenu> createState() => _ItemMenuState();
}

class _ItemMenuState extends State<ItemMenu> {
  late final Stream<List<Map<String, dynamic>>> _stream;
  var number = 0;

  void deleteMN(int index) async {
    await TambahMenu(id: index.toString()).deleteMenu();
  }

  @override
  void initState() {
    super.initState();
    _stream =
        Supabase.instance.client.from('menu').stream(primaryKey: ['id_menu']);
  }

  @override
  Widget build(BuildContext context) {
    final leftWidth = widget.leftWidth;
    final constraints = widget.constraints;

    return Container(
      width: leftWidth,
      color: Colors.grey[400],
      height: constraints.maxHeight,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final menus = snapshot.data!;

          // final menu = menus[index];
          return GridView.count(
            crossAxisCount: 4,
            children: List.generate(menus.length, (index) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Container(
                  color: Colors.white,
                  margin: const EdgeInsets.all(5),
                  child: Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Image.network(
                              menus[index]["url"],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      color: Colors.transparent,
                                      child: Column(children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            menus[index]["nama_menu"],
                                            style: const TextStyle(
                                              fontSize: 15,
                                              decoration:
                                                  TextDecoration.underline,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: Row(children: [
                                          Expanded(
                                            child: Center(
                                              child: IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      barrierDismissible: false,
                                                      builder: (context) =>
                                                          Pembayaran2(
                                                            id: menus[index]
                                                                ['id_menu'],
                                                          ));
                                                },
                                                icon: const Icon(
                                                    Icons.edit_square),
                                                iconSize: 24,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Container(
                                                  color: Colors.transparent,
                                                  child: Center(
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          number = menus[index]
                                                              ['id_menu'];
                                                        });
                                                        deleteMN(number);
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete_rounded),
                                                      iconSize: 24,
                                                    ),
                                                  ))),
                                        ]))
                                      ])),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        menus[index]['harga'].toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class Pembayaran2 extends StatelessWidget {
  final int id;
  const Pembayaran2({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 600,
          height: 650,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Update Menu",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              UpdateMenu(
                dialogContext: context,
                id: id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateMenu extends StatefulWidget {
  final BuildContext? dialogContext;
  final int id;
  const UpdateMenu({super.key, required this.dialogContext, required this.id});
  @override
  State<UpdateMenu> createState() => _UpdateMenuState();
}

class _UpdateMenuState extends State<UpdateMenu> {
  TextEditingController namaMenuController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  String bImage = '';
  Uint8List? image;
  bool isLoading = false;
  // late final Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    final future = Supabase.instance.client
        .from('menu')
        .select()
        .eq('id_menu', widget.id)
        .single();
    future.then((value) {
      setState(() {
        namaMenuController.text = value['nama_menu'].toString();
        hargaController.text = value['harga'].toString();
        bImage = value['url'].toString();
      });
    });
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        image = img;
      });
    } else {
      // Handle the case where no image is selected
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              child: Column(
                children: [
                  Container(
                      padding:
                          const EdgeInsets.only(top: 30, left: 50, right: 50),
                      child: Column(children: [
                        TextFormField(
                          controller: namaMenuController,
                          decoration: const InputDecoration(
                            labelText: "Nama Menu",
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              // Format input menjadi format yang diinginkan
                              final numericValue = int.tryParse(newValue.text);
                              if (numericValue != null) {
                                final formatter =
                                    NumberFormat("#,##0", "en_US");
                                final newString =
                                    formatter.format(numericValue);
                                return TextEditingValue(
                                  text: newString,
                                  selection: TextSelection.collapsed(
                                      offset: newString.length),
                                );
                              }
                              return newValue;
                            }),
                          ],
                          controller: hargaController,
                          decoration: const InputDecoration(
                            labelText: "Harga ",
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Stack(
                          children: [
                            image != null
                                ? Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: MemoryImage(image!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: NetworkImage(bImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            Positioned(
                              bottom: -10,
                              right: 0,
                              child: IconButton(
                                onPressed: () {
                                  selectImage();
                                },
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              final numericValue = int.tryParse(
                                  hargaController.text.replaceAll(',', ''));
                              String namaMenu = namaMenuController.text;
                              int hargaMenu = numericValue!;
                              // Menampilkan nilai yang ditetapkan
                              setState(() {
                                isLoading = true;
                              });
                              if (image == null) {
                                await TambahMenu(
                                        name: namaMenu,
                                        price: hargaMenu,
                                        image: bImage,
                                        id: widget.id.toString())
                                    .updateMenus();
                              } else {
                                final gambar =
                                    ImageUploader(image: image!).uploadImage();
                                String? gambar2 = await gambar;

                                await TambahMenu(
                                  name: namaMenu,
                                  price: hargaMenu,
                                  image: gambar2,
                                  id: widget.id.toString(),
                                ).updateMenus();
                              }

                              Navigator.pop(widget.dialogContext!);
                            },
                            child: const Text(
                              "Update",
                              style: TextStyle(fontSize: 20),
                            ))
                      ])),
                ],
              ),
            ),
    );
  }
}
