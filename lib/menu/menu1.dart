import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter1/pdf/invoice.dart';
import 'package:flutter1/utils/db.dart';

import 'package:flutter1/utils/list_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Menu1 extends StatelessWidget {
  const Menu1({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Bill>(
        builder: (context, value, child) => MaterialApp(
              home: Scaffold(
                appBar: const ShowBar(),
                body: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double screenWidth = constraints.maxWidth;
                    double leftWidth = screenWidth * 0.65;
                    double rightWidth = screenWidth * 0.35;

                    return Row(
                      children: [
                        ItemMenu(
                          leftWidth: leftWidth,
                          constraints: constraints,
                        ),
                        Cashier(
                          rightWidth: rightWidth,
                          constraints: constraints,
                        )
                      ],
                    );
                  },
                ),
              ),
            ));
  }
}

class ShowBar extends StatefulWidget implements PreferredSizeWidget {
  const ShowBar({super.key});

  @override
  State<ShowBar> createState() => _ShowBarState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ShowBarState extends State<ShowBar> {
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
    return AppBar(
      title: const Text('Eazy Posh'),
      backgroundColor: const Color(0xFFDBA688),
      foregroundColor: Colors.white,
      elevation: 4.0,
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Handle settings button press
              },
            ),
            StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final staff = snapshot.data!;

                  return Text(staff[0]['nama_staff'].toString());
                }),
            const SizedBox(
              width: 16,
            )
          ],
        ),
      ],
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

    return Consumer<Bill>(
        builder: (context, value, child) => Container(
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

                  return GridView.count(
                    crossAxisCount: 3,
                    children: List.generate(menus.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          final bills = context.read<Bill>();
                          bills.addItem(menus[index]);
                        },
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
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
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  menus[index]["nama_menu"],
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  menus[index]['harga']
                                                      .toString(),
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
                        ),
                      );
                    }),
                  );
                },
              ),
            ));
  }
}

class Cashier extends StatefulWidget {
  final double rightWidth;
  final BoxConstraints constraints;

  const Cashier(
      {super.key, required this.rightWidth, required this.constraints});
  @override
  State<Cashier> createState() => _CashierState();
}

class _CashierState extends State<Cashier> {
  String _selectedValue = 'Dine In';
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
    final rightWidth = widget.rightWidth;
    final constraints = widget.constraints;
    return Container(
      width: rightWidth,
      color: Colors.transparent,
      height: constraints.maxHeight,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double screenHeight = constraints.maxHeight;
          DateTime tanggal = DateTime.now();

          return StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final staff = snapshot.data!;

                return Consumer<Bill>(
                    builder: (context, value, child) => Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              height: screenHeight,
                              color: Colors.white,
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
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.transparent,
                                              child: DropdownButton<String>(
                                                value: _selectedValue,
                                                isExpanded: true,
                                                items: const [
                                                  DropdownMenuItem<String>(
                                                      value: "Dine In",
                                                      child: Center(
                                                        child: Text("Dine In"),
                                                      )),
                                                  DropdownMenuItem<String>(
                                                      value: "Take Away",
                                                      child: Center(
                                                        child:
                                                            Text("Take Away"),
                                                      )),
                                                ],
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    _selectedValue = newValue!;
                                                  });
                                                  print(_selectedValue);
                                                },
                                              ),
                                            ),
                                            Container(
                                                color: Colors.transparent,
                                                width: rightWidth,
                                                height: upHeight * 0.70,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: List.generate(
                                                        value.bill.length,
                                                        (index) {
                                                      return Container(
                                                        color:
                                                            Colors.transparent,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 1,
                                                              child: !value.deal
                                                                  ? IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        final bills =
                                                                            context.read<Bill>();
                                                                        bills.removeItem(
                                                                            index);
                                                                      },
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .remove_circle,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                    )
                                                                  : const Text(
                                                                      ""),
                                                            ),
                                                            Expanded(
                                                              flex: 4,
                                                              child: Text(value
                                                                          .bill[
                                                                      index][
                                                                  "nama_menu"]),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                  "${value.bill[index]['jumlah'].toString()} x"),
                                                            ),
                                                            Expanded(
                                                              child: Text(value
                                                                  .bill[index]
                                                                      ['total']
                                                                  .toString()),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                                  ),
                                                )),
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 40, right: 40),
                                                color: Colors.transparent,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: value
                                                                .cash.isNotEmpty
                                                            ? const Text(
                                                                "SUBTOTAL")
                                                            : const Text("")),
                                                    Expanded(
                                                        child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: value
                                                              .cash.isNotEmpty
                                                          ? Text(
                                                              value
                                                                  .formattedTotal,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                            )
                                                          : const Text(""),
                                                    ))
                                                  ],
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 40, right: 40),
                                                color: Colors.transparent,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: value
                                                                .cash.isNotEmpty
                                                            ? const Text("CASH")
                                                            : const Text("")),
                                                    Expanded(
                                                        child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child:
                                                          value.cash.isNotEmpty
                                                              ? Text(value.cash
                                                                  .toString())
                                                              : const Text(""),
                                                    ))
                                                  ],
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                padding: const EdgeInsets.only(
                                                    left: 40, right: 40),
                                                color: Colors.transparent,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: value
                                                                .cash.isNotEmpty
                                                            ? const Text(
                                                                "CHANGE")
                                                            : const Text("")),
                                                    Expanded(
                                                        child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: value
                                                              .cash.isNotEmpty
                                                          ? Text(value.change
                                                              .toString())
                                                          : const Text(""),
                                                    ))
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: botHeight,
                                        padding: const EdgeInsets.all(10),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (value.formattedTotal != "0") {
                                              if (value.cash.isNotEmpty) {
                                                List.generate(
                                                    value.bill.length,
                                                    (index) => {
                                                          Bayar(
                                                                  idMenu: value
                                                                          .bill[index][
                                                                      'id_menu'],
                                                                  total: value
                                                                          .bill[index]
                                                                      ['total'],
                                                                  jumlah: value
                                                                          .bill[index]
                                                                      [
                                                                      'jumlah'],
                                                                  idStaff: staff[
                                                                          0][
                                                                      'id_staff'],
                                                                  idPembayaran:
                                                                      1,
                                                                  tglPembayaran:
                                                                      tanggal
                                                                          .toString())
                                                              .tambahPembayaran()
                                                        });
                                                final invoice = Invoice(
                                                  namaStaff: 'sidik',
                                                  date: tanggal.toString(),
                                                  payment: 'Cash',
                                                  subtotal: value.total,
                                                  change: int.parse(value.change
                                                      .replaceAll(",", "")),
                                                  items: value.bill
                                                      .map<
                                                          Map<String,
                                                              dynamic>>((e) => {
                                                            'nama_menu':
                                                                e['nama_menu'],
                                                            'total': e['total'],
                                                            'jumlah':
                                                                e['jumlah'],
                                                          })
                                                      .toList(),
                                                  total: value.total,
                                                );

                                                await invoice.sendEmail();
                                                final bills =
                                                    context.read<Bill>();
                                                bills.clearBill();
                                                bills.clearCash();
                                              } else if (value
                                                  .payment.isNotEmpty) {
                                                print('pay dengan walet');
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (context) =>
                                                        const Pembayaran());
                                              }
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              minimumSize: const Size(400, 100),
                                              backgroundColor:
                                                  value.formattedTotal == "0"
                                                      ? Colors.grey[400]
                                                      : Colors.blue),
                                          child: value.cash.isNotEmpty
                                              ? const Text("Pay",
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.white))
                                              : value.formattedTotal == "0"
                                                  ? const Text("Charge",
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          color: Colors.black))
                                                  : Text(
                                                      "Rp.${value.formattedTotal}",
                                                      style: const TextStyle(
                                                        fontSize: 30,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ));
              });
        },
      ),
    );
  }
}

class Pembayaran extends StatelessWidget {
  const Pembayaran({super.key});

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
  late final Stream<List<Map<String, dynamic>>> _stream;
  List payment = [
    {
      "E-Wallet": [
        {
          "logo":
              "https://fintech.id/storage/files/shares/logo/logofi2/ShopeePay.png",
          'nama': 'ShopeePay',
          "id": 2,
        },
        {
          "logo":
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_7rAvoHd9vZdeAKo9UO_G-NUSFCeyHXJHPz-_SOcNFg&s",
          'nama': 'OVO',
          "id": 3,
        },
        {
          'logo':
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQb_Tmtcidb8-nToY-lBF685y9faw03fsD9ONH1hVW2&s",
          'nama': 'Dana',
          "id": 4,
        },
        {
          'logo':
              "https://assets.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/2021/10/16/359340013.png",
          'nama': 'GOPAY',
          "id": 5,
        },
        {
          'logo':
              "https://assets-a1.kompasiana.com/items/album/2023/04/13/beli-saldo-paypal-via-linkaja-6437c7be4addee244748a212.png",
          'nama': 'LinkAja',
          "id": 6,
        },
      ]
    },
    {
      "EDC": [
        {
          "logo":
              "https://mmc.tirto.id/image/2016/05/11/Bank_Central_Asia_048.JPG",
          'nama': 'BCA',
          "id": 7,
        },
        {
          "logo":
              "https://w7.pngwing.com/pngs/38/408/png-transparent-mandiri-logo-bank-mandiri-bank-negara-indonesia-bank-indonesia-bank-account-bank-mandiri-cdr-text-logo.png",
          'nama': 'Mandiri',
          "id": 8,
        },
        {
          'logo':
              "https://www.linkqu.id/wp-content/uploads/2021/07/Logo-BNI-Linkqu.jpg.webp",
          'nama': 'BNI',
          "id": 9,
        },
        {
          'logo':
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrZaGYxAt6ZbfKoPooG5H6dbcJwVKEJ18Qsw&s",
          'nama': 'BSI',
          "id": 10,
        },
        {
          'logo':
              "https://i.pinimg.com/originals/a0/b3/78/a0b37830a4301119ede11d48b9ca7931.png",
          'nama': 'BRI',
          "id": 11,
        },
      ]
    }
  ];

  bool isLoading = false;
  bool cash = false;

  @override
  void initState() {
    super.initState();
    _stream = Supabase.instance.client
        .from('staff')
        .stream(primaryKey: ['id_staff']).eq('status', true);
  }

  @override
  Widget build(BuildContext context) {
    List eWalletList = payment[0]['E-Wallet'];
    List edcList = payment[1]['EDC'];
    DateTime tanggal = DateTime.now();
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final staff = snapshot.data!;
          return Consumer<Bill>(
              builder: (context, value, child) => Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
                  child: Column(children: [
                    Container(
                        color: Colors.transparent,
                        child: Row(children: [
                          Container(
                            color: Colors.transparent,
                            child: const Text(
                              "Cash",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Expanded(flex: 1, child: Text("")),
                          Expanded(
                            flex: 4,
                            child: TextField(
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
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (newValue) {
                                final payment = context.read<Bill>();
                                payment.clearPayment();
                                setState(() {
                                  cash = true;
                                });
                              },
                            ),
                          ),
                          const Expanded(flex: 1, child: Text(""))
                        ])),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        color: Colors.transparent,
                        child: value.payment.isNotEmpty
                            ? const Text("")
                            : cash &&
                                    (int.tryParse(hargaController.text
                                                .replaceAll(',', '')) ??
                                            0) <
                                        int.parse(value.formattedTotal
                                            .replaceAll(",", ""))
                                ? const Text("Pembayaran cash kurang")
                                : const Text("")),
                    Container(
                        color: Colors.transparent,
                        child: Row(children: [
                          Container(
                            color: Colors.transparent,
                            child: const Text(
                              "E-Wallet",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Expanded(flex: 1, child: Text("")),
                          Expanded(
                              flex: 10,
                              child: Wrap(
                                  runSpacing: 10,
                                  spacing: 10,
                                  children: List.generate(eWalletList.length,
                                      (index) {
                                    return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            hargaController.text = "";
                                          });
                                          final payment = context.read<Bill>();
                                          payment.addPayment(
                                              eWalletList[index]['nama'],
                                              eWalletList[index]['id']);
                                        },
                                        child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            child: Container(
                                              color: Colors.white,
                                              margin: const EdgeInsets.all(5),
                                              child: Container(
                                                width: 100,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width:
                                                            2), // Add border here
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          eWalletList[index]
                                                              ['logo']),
                                                    )),
                                              ),
                                            )));
                                  }))),
                        ])),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                        color: Colors.transparent,
                        child: Row(children: [
                          Container(
                            color: Colors.transparent,
                            child: const Text(
                              "EDC",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Expanded(flex: 2, child: Text("")),
                          Expanded(
                              flex: 10,
                              child: Wrap(
                                  runSpacing: 10,
                                  spacing: 10,
                                  children:
                                      List.generate(edcList.length, (index) {
                                    return GestureDetector(
                                        onTap: () {
                                          final payment = context.read<Bill>();
                                          payment.addPayment(
                                              edcList[index]['nama'],
                                              edcList[index]['id']);
                                          setState(() {
                                            hargaController.text = "";
                                          });
                                        },
                                        child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(20)),
                                            child: Container(
                                              color: Colors.white,
                                              margin: const EdgeInsets.all(5),
                                              child: Container(
                                                width: 100,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width:
                                                            2), // Add border here
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          edcList[index]
                                                              ['logo']),
                                                    )),
                                              ),
                                            )));
                                  }))),
                        ])),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      color: Colors.transparent,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: const Size(200, 70)),
                        onPressed: () {
                          if (cash &&
                              (int.tryParse(hargaController.text
                                          .replaceAll(',', '')) ??
                                      0) >=
                                  value.total) {
                            final cash = context.read<Bill>();

                            cash.addCash(hargaController.text);
                            cash.setDeal(true);
                            cash.addChange();
                            Navigator.of(context).pop();
                          } else {
                            if (value.payment.isEmpty) {
                              "";
                            } else {
                              List.generate(
                                  value.bill.length,
                                  (index) => {
                                        Bayar(
                                                idMenu: value.bill[index]
                                                    ['id_menu'],
                                                total: value.bill[index]
                                                    ['total'],
                                                jumlah: value.bill[index]
                                                    ['jumlah'],
                                                idStaff: staff[0]['id_staff'],
                                                idPembayaran: value.idPayment,
                                                tglPembayaran:
                                                    tanggal.toString())
                                            .tambahPembayaran()
                                      });
                              final success = context.read<Bill>();
                              success.clearBill();
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: const Text(
                          "Bayar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    )
                  ])));
        });
  }
}
