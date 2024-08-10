import 'package:flutter/material.dart';

import 'package:flutter1/utils/db.dart';
import 'package:flutter1/utils/list_provider.dart';

import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Menu3 extends StatelessWidget {
  const Menu3({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double screenWidth = constraints.maxWidth;
            double leftWidth = screenWidth * 0.50;
            double rightWidth = screenWidth * 0.50;

            return Row(
              children: [
                ItemPerson(
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
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20, top: 5),
                            height: screenHeight,
                            color: Colors.grey[400],
                            child: LayoutBuilder(
                              builder: (BuildContext context,
                                  BoxConstraints constraints) {
                                double screenHeight2 = constraints.maxHeight;
                                double upHeight = screenHeight2 * 0.80;
                                double botHeight = screenHeight2 * 0.15;
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    StaffInfo(upHeight: upHeight),
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
                          "Tambah Staff",
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
              InputPerson(
                dialogContext: context,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ItemPerson extends StatefulWidget {
  final double leftWidth;
  final BoxConstraints constraints;

  const ItemPerson(
      {super.key, required this.leftWidth, required this.constraints});

  @override
  State<ItemPerson> createState() => _ItemPersonState();
}

class _ItemPersonState extends State<ItemPerson> {
  late final Stream<List<Map<String, dynamic>>> _stream;

  void deletePerson(int index) async {
    await TambahPerson(id: index.toString()).deletePerson();
  }

  @override
  void initState() {
    super.initState();
    _stream =
        Supabase.instance.client.from('staff').stream(primaryKey: ['id_staff']);
  }

  @override
  Widget build(BuildContext context) {
    final leftWidth = widget.leftWidth;
    final constraints = widget.constraints;

    return Consumer<Bill>(
        builder: (context, ref, child) => Container(
              width: leftWidth,
              color: Colors.grey[400],
              height: constraints.maxHeight,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final staffs = snapshot.data!;

                  return ListView.builder(
                    itemCount: staffs.length,
                    itemBuilder: (context, index) {
                      final staff = staffs[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5), // Add vertical margin between items
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(
                              color: Colors.black, width: 1), // Add border
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Add rounded corners
                        ),
                        child: ListTile(
                          onTap: () {
                            final person = context.read<Bill>();
                            person.addPerson(staff);
                          },
                          leading: const Icon(Icons.person, size: 50),
                          title: Text(staff['nama_staff']),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deletePerson(staff['id_staff']);
                              final person = context.read<Bill>();
                              person.clearPerson();
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ));
  }
}

class StaffInfo extends StatefulWidget {
  final double upHeight;
  const StaffInfo({super.key, required this.upHeight});

  @override
  State<StaffInfo> createState() => _StaffInfoState();
}

class _StaffInfoState extends State<StaffInfo> {
  @override
  Widget build(BuildContext context) {
    final upHeight = widget.upHeight;
    return Consumer<Bill>(
      builder: (context, value, child) => Container(
        height: upHeight,
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border.all(color: Colors.black, width: 1), // Add border
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                width: 220, // Adjust width to fit the CircleAvatar with border
                height:
                    220, // Adjust height to fit the CircleAvatar with border
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.black87, width: 2), // Add border
                ),
                child: const CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                      "https://cdn3d.iconscout.com/3d/premium/thumb/man-9251877-7590869.png?f=webp"),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Nama: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  value.person.isEmpty
                      ? const Text(
                          "John Doe",
                          style: TextStyle(fontSize: 20),
                        )
                      : Text(
                          value.person[0]['nama_staff'].toString(),
                          style: const TextStyle(fontSize: 20),
                        )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No. Telp: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  value.person.isEmpty
                      ? const Text(
                          "No Staff Selected",
                          style: TextStyle(fontSize: 20),
                        )
                      : Text(
                          value.person[0]['nomor_tlp'].toString(),
                          style: const TextStyle(fontSize: 20),
                        )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Status: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  value.person.isEmpty
                      ? const Text(
                          "John Doe",
                          style: TextStyle(fontSize: 20),
                        )
                      : Text(
                          value.person[0]['status'].toString(),
                          style: const TextStyle(fontSize: 20),
                        )
                ],
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(100, 50)),
                onPressed: () async {
                  await TambahPerson(id: value.person[0]["id_staff"].toString())
                      .updatePerson();

                  final person = context.read<Bill>();
                  person.chageStatus();
                },
                child: const Text(
                  "Shift ON",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}

class InputPerson extends StatefulWidget {
  final BuildContext dialogContext;
  const InputPerson({super.key, required this.dialogContext});
  @override
  State<InputPerson> createState() => _InputPersonState();
}

class _InputPersonState extends State<InputPerson> {
  TextEditingController namaMenuController = TextEditingController();
  TextEditingController nomerTlpController = TextEditingController();

  bool isLoading = false;

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
                        const SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          controller: namaMenuController,
                          decoration: const InputDecoration(
                            labelText: "Nama Staff",
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: nomerTlpController,
                          decoration: const InputDecoration(
                            labelText: "Nomor Telepon",
                          ),
                        ),
                        const SizedBox(
                          height: 200,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              await TambahPerson(
                                namaStaff: namaMenuController.text,
                                nomorTlp: nomerTlpController.text,
                              ).tambahPerson();

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
