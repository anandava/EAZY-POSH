import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter1/utils/db.dart';
import 'package:flutter1/utils/list_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Menu4 extends StatelessWidget {
  const Menu4({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    // Memformat tanggal
    String formattedDate = DateFormat('dd-MMMM-yyyy').format(now);
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('DASHBOARD'),
      ),
      body: Consumer<Bill>(
          builder: (context, value, child) => SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                    child: value.pemasukan
                        ? Column(
                            children: [
                              Header(formattedDate: formattedDate),
                              const Pemasukan(),
                              const SizedBox(
                                height: 20,
                              ),
                              const ItemPemasukan(),
                            ],
                          )
                        : Column(
                            children: [
                              Header(formattedDate: formattedDate),
                              const Pengeluaran(),
                              const SizedBox(
                                height: 20,
                              ),
                              const ItemPengeluaran()
                            ],
                          )),
              )),
    ));
  }
}

class Header extends StatefulWidget {
  final String formattedDate;
  const Header({super.key, required this.formattedDate});
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String formattedDate = "";
  @override
  void initState() {
    super.initState();
    formattedDate = widget.formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Bill>(
      builder: (context, value, child) => Container(
        color: Colors.transparent,
        height: 80,
        child: Row(children: [
          Expanded(
              child: Center(
                  child: Container(
            padding: const EdgeInsets.all(8.0), // Padding di sekitar teks
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black87, width: 2.0), // Warna dan lebar border
              borderRadius:
                  BorderRadius.circular(8.0), // Membuat border melengkung
            ),
            child: Text("tanggal : $formattedDate"),
          ))),
          Expanded(
            child: Row(
              children: [
                const SizedBox(
                  width: 150,
                ),
                ElevatedButton(
                    onPressed: () {
                      final masuk = context.read<Bill>();
                      masuk.setPemasukan(true);
                    },
                    child: const Text("Pemasukan")),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {
                      final masuk = context.read<Bill>();
                      masuk.setPemasukan(false);
                    },
                    child: const Text("Pengeluaran")),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class Pemasukan extends StatefulWidget {
  const Pemasukan({super.key});

  @override
  State<Pemasukan> createState() => _PemasukanState();
}

class _PemasukanState extends State<Pemasukan> {
  late final Future<int> _future;

  @override
  void initState() {
    super.initState();
    _future = _getTotalPemasukanHariIni();
  }

  Future<int> _getTotalPemasukanHariIni() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final response = await Supabase.instance.client
        .from('pembayaran')
        .select('total_harga')
        .gte('tgl_pembayaran', startOfDay)
        .lte('tgl_pembayaran', endOfDay);

    final data = response as List<dynamic>;
    final totalPemasukan = data.fold<int>(
      0,
      (sum, item) => sum + (item['total_harga'] as num).toInt(),
    );

    return totalPemasukan;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final totalPemasukan = snapshot.data!;

        return Container(
          height: 50,
          width: 1200,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black87, width: 2.0), // Warna dan lebar border
            borderRadius:
                BorderRadius.circular(8.0), // Membuat border melengkung
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Pemasukan Hari Ini: Rp. $totalPemasukan",
                  style: const TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
              const Expanded(
                child: Text(
                  "",
                  style: TextStyle(color: Colors.red, fontSize: 30),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ItemPemasukan extends StatefulWidget {
  const ItemPemasukan({super.key});

  @override
  State<ItemPemasukan> createState() => _ItemPemasukanState();
}

class _ItemPemasukanState extends State<ItemPemasukan> {
  late final Future<List<Map<String, dynamic>>> _future;
  @override
  void initState() {
    final today = DateTime.now();

    final startOfDay = DateTime(today.year, today.month, today.day);

    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    super.initState();
    _future = Supabase.instance.client
        .from('pembayaran')
        .select(
            'jumlah,tgl_pembayaran,total_harga,staff(nama_staff),menu(nama_menu,harga))')
        .gte('tgl_pembayaran', startOfDay)
        .lte('tgl_pembayaran', endOfDay);

    // replace with the foreign key values you want to join
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bayar = snapshot.data!;
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  width: 1200,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black87,
                        width: 2.0), // Warna dan lebar border
                    borderRadius:
                        BorderRadius.circular(8.0), // Membuat border melengkung
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder.all(color: Colors.black87),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(color: Colors.white),
                          children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("No.",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("DateTime",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Staff",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Menu",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Harga",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("jumlah",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Total",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                          ],
                        ),
                        ...List.generate(
                          bayar.length,
                          (index) => TableRow(
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text((index + 1).toString(),
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        (bayar[index]['tgl_pembayaran'])
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        bayar[index]['staff']['nama_staff'],
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        bayar[index]['menu']['nama_menu'],
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        bayar[index]['menu']['harga']
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        bayar[index]['jumlah'].toString(),
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        bayar[index]['total_harga'].toString(),
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }
}

class Pengeluaran extends StatefulWidget {
  const Pengeluaran({super.key});

  @override
  State<Pengeluaran> createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.black87, width: 2.0), // Warna dan lebar border
          borderRadius: BorderRadius.circular(8.0), // Membuat border melengkung
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          onPressed: () {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const TambahPengeluaran());
          },
          child: const Text("Tambah Pengeluaran"),
        ));
  }
}

class TambahPengeluaran extends StatelessWidget {
  const TambahPengeluaran({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Bill>(
        builder: (context, value, child) => Dialog(
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
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: value.formattedTotal == "0"
                                    ? const Text("Charge",
                                        style: TextStyle(
                                            fontSize: 30, color: Colors.black))
                                    : Text(
                                        "Rp.${value.formattedTotal}",
                                        style: const TextStyle(
                                            fontSize: 30, color: Colors.black),
                                      ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  value.payment,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
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
            ));
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
  bool isLoading = false;
  late final Stream<List<Map<String, dynamic>>> _stream;
  @override
  void initState() {
    super.initState();

    _stream = Supabase.instance.client
        .from('staff')
        .stream(primaryKey: ['id_staff']).eq('status', true);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Container(
        color: Colors.transparent,
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _stream,
          builder: (context, snapshot) => Form(
            child: Column(
              children: [
                Container(
                    padding:
                        const EdgeInsets.only(top: 30, left: 50, right: 50),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(children: [
                            TextFormField(
                              controller: namaMenuController,
                              decoration: const InputDecoration(
                                labelText: "Deskrpsi",
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
                                  final numericValue =
                                      int.tryParse(newValue.text);
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
                                labelText: "Total Pengeluaran",
                              ),
                            ),
                            const SizedBox(
                              height: 50,
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
                                  await Outcome(
                                          deskrpsi: namaMenu,
                                          jumlah: hargaMenu,
                                          tglPengeluaran: now.toString(),
                                          idStaff: snapshot.data![0]
                                              ['id_staff'])
                                      .tambahPengeluaran();
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.pop(widget.dialogContext);
                                  // Menampilkan nilai yang ditetapkan
                                },
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(fontSize: 20),
                                ))
                          ])),
              ],
            ),
          ),
        ));
  }
}

class ItemPengeluaran extends StatefulWidget {
  const ItemPengeluaran({super.key});

  @override
  State<ItemPengeluaran> createState() => _ItemPengeluaranState();
}

class _ItemPengeluaranState extends State<ItemPengeluaran> {
  late final Future<List<Map<String, dynamic>>> _future;
  @override
  void initState() {
    final today = DateTime.now();

    final startOfDay = DateTime(today.year, today.month, today.day);

    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    super.initState();
    _future = Supabase.instance.client
        .from('pengeluaran')
        .select(
          'jumlah,tgl_pengeluaran,id_staff,deskripsi,staff(nama_staff)',
        )
        .gte('tgl_pengeluaran', startOfDay)
        .lte('tgl_pengeluaran', endOfDay);

    // replace with the foreign key values you want to join
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final bayar = snapshot.data!;
          return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                  width: 1200,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black87,
                        width: 2.0), // Warna dan lebar border
                    borderRadius:
                        BorderRadius.circular(8.0), // Membuat border melengkung
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Table(
                      border: TableBorder.all(color: Colors.black87),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(color: Colors.white),
                          children: [
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("No.",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("DateTime",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Staff",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Deskripsi",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                            TableCell(
                                verticalAlignment:
                                    TableCellVerticalAlignment.middle,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("Total Pengeluaran",
                                      style: TextStyle(color: Colors.black87)),
                                )),
                          ],
                        ),
                        ...List.generate(
                          bayar.length,
                          (index) => TableRow(
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            children: [
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text((index + 1).toString(),
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        (bayar[index]['tgl_pengeluaran'])
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        bayar[index]['staff']['nama_staff'],
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        bayar[index]['deskripsi'].toString(),
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                              TableCell(
                                  verticalAlignment:
                                      TableCellVerticalAlignment.middle,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        bayar[index]['jumlah'].toString(),
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  )));
        });
  }
}
