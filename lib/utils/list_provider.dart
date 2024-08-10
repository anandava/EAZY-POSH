import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Bill extends ChangeNotifier {
  final List _bill = [];
  String _payment = "";
  int _idPayment = 0;
  String _cash = "";
  int _change = 0;
  bool _deal = false;
  bool _pemasukan = true;
  final List _person = [];
  List get bill => _bill;
  String get payment => _payment;
  int get idPayment => _idPayment;
  String get cash => _cash;
  String get change => formatNumber(_change);
  bool get deal => _deal;
  // int get total =>
  //     _bill.fold(0, (sum, item) => sum + int.parse(item['harga'].toString()));
  // String get formattedTotal => formatNumber(total);
  List get person => _person;

  int get total => _bill.fold(
        0,
        (sum, item) {
          int price = int.parse(item['harga'].toString());

          int quantity = item['jumlah'];

          return (sum + (price * quantity));
        },
      );
  String get formattedTotal => formatNumber(total);
  bool get pemasukan => _pemasukan;

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  void setPemasukan(bool value) {
    _pemasukan = value;
    notifyListeners();
  }

  void addItem(dynamic newItem) {
    if (_bill.isEmpty) {
      _bill.add({
        'id_menu': newItem['id_menu'],
        'nama_menu': newItem['nama_menu'],
        'harga': newItem['harga'],
        'url': newItem['url'],
        'jumlah': 1,
        'total': newItem['harga'],
      });
    } else {
      bool itemFound = false;
      for (var i in _bill) {
        if (i['id_menu'] == newItem['id_menu']) {
          i['jumlah'] += 1;
          i['total'] += newItem['harga'];
          itemFound = true;
          break;
        }
      }
      if (!itemFound) {
        _bill.add({
          'id_menu': newItem['id_menu'],
          'nama_menu': newItem['nama_menu'],
          'harga': newItem['harga'],
          'url': newItem['url'],
          'jumlah': 1,
          'total': newItem['harga'],
        });
      }
    }
    notifyListeners();
  }

  void removeItem(int index) {
    if (_bill[index]['jumlah'] > 1) {
      _bill[index]['total'] -= _bill[index]['harga'];
      _bill[index]['jumlah'] -= 1;
    } else {
      _bill.removeAt(index);
    }

    notifyListeners();
  }

  void addPayment(String payment, int idPayment) {
    _payment = payment;
    _idPayment = idPayment;
    notifyListeners();
  }

  void clearBill() {
    _bill.clear();
    _payment = "";
    notifyListeners();
  }

  void clearPayment() {
    _payment = "";
    notifyListeners();
  }

  void addCash(String cash) {
    _cash = cash;
    notifyListeners();
  }

  void clearCash() {
    _cash = "";
    _change = 0;
    _deal = false;
    notifyListeners();
  }

  void addChange() {
    _change = (int.parse(cash.replaceAll(",", "")) -
        int.parse(formattedTotal.replaceAll(",", "")));

    notifyListeners();
  }

  void setDeal(bool deal) {
    _deal = deal;
    notifyListeners();
  }

  void addPerson(dynamic person) {
    if (_person.isEmpty) {
      if (person['status'] == true) {
        _person.add({
          'id_staff': person['id_staff'],
          'nama_staff': person['nama_staff'],
          'status': 'Shift',
          'nomor_tlp': person['nomor_tlp'],
          'created_at': person['created_at'].toString(),
        });
      } else {
        _person.add({
          'id_staff': person['id_staff'],
          'nama_staff': person['nama_staff'],
          'status': 'Not Shift',
          'nomor_tlp': person['nomor_tlp'],
          'created_at': person['created_at'].toString(),
        });
      }
    } else {
      _person.clear();
      if (person['status'] == true) {
        _person.add({
          'id_staff': person['id_staff'],
          'nama_staff': person['nama_staff'],
          'status': 'Shift',
          'nomor_tlp': person['nomor_tlp'],
          'created_at': person['created_at'].toString(),
        });
      } else {
        _person.add({
          'id_staff': person['id_staff'],
          'nama_staff': person['nama_staff'],
          'status': 'Not Shift',
          'nomor_tlp': person['nomor_tlp'],
          'created_at': person['created_at'].toString(),
        });
      }
    }
    notifyListeners();
  }

  void clearPerson() {
    _person.clear();
    notifyListeners();
  }

  void chageStatus() {
    _person[0]['status'] = 'Shift';
    notifyListeners();
  }
}
