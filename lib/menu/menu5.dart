import 'package:flutter/material.dart';

class Menu5 extends StatelessWidget {
  const Menu5({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 150,
                backgroundImage: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRyaQlEqv1AUFpmwdoMzmHz1T9KQqoBmOr8cjFJiLJ3g&s"),
              ),
              SizedBox(
                height: 30,
              ),
              Text("POSH COFFEE", style: TextStyle(fontSize: 30)),
              SizedBox(
                height: 20,
              ),
              Text(
                  "Jl. Nuri pikgondang No.17, Kentungan, Condongcatur, Kec. Depok, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55281",
                  style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
