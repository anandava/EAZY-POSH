import 'package:supabase_flutter/supabase_flutter.dart';

class TambahMenu {
  final String? name;
  final int? price;
  final String? id;
  final String? image;

  TambahMenu({this.name, this.price, this.id, this.image});

  Future<void> tambahMenu() async {
    final db = Supabase.instance.client;
    final response = await db
        .from('menu')
        .upsert({'nama_menu': name, 'harga': price, 'url': image})
        .select()
        .single();

    if (response.isEmpty) {
      print('Error inserting data: No response from server.');
    } else {
      print('Data inserted successfully: $response');
    }
  }

  Future<void> deleteMenu() async {
    int value = int.parse(id!);

    final db = Supabase.instance.client;

    final response = await db
        .from('menu')
        .delete()
        .match({'id_menu': value})
        .select()
        .single();

    if (response.isEmpty) {
      print('Error deleting data: No response from server.');
    } else {
      print('Data deleted successfully: $response');
    }
  }

  Future<void> updateMenus() async {
    int value = int.parse(id!);

    final db = Supabase.instance.client;

    final response = await db.from('menu').update(
        {'nama_menu': name, 'harga': price, 'url': image}).eq('id_menu', value);

    if (response == null) {
      print('Error deleting data: No response from server.');
    } else {
      print('Data deleted successfully: $response');
    }
  }
}

class Bayar {
  final int? jumlah;
  final int? total;
  final int? idMenu;
  final int? idStaff;
  final String? tglPembayaran;
  final int? idPembayaran;
  Bayar(
      {this.jumlah,
      this.total,
      this.idMenu,
      this.idStaff,
      this.tglPembayaran,
      this.idPembayaran});

  Future<void> tambahPembayaran() async {
    final db = Supabase.instance.client;
    var res = await db
        .from('pembayaran')
        .insert({
          'jumlah': jumlah,
          'total_harga': total,
          'id_menu': idMenu,
          'id_staff': idStaff,
          'tgl_pembayaran': tglPembayaran,
          'id_jenis_pembayaran': idPembayaran
        })
        .select()
        .single();
    if (res.isEmpty) {
      print('Error inserting data: No response from server.');
    } else {
      print('Data inserted successfully: $res');
    }
  }
}

class Outcome {
  String? deskrpsi;
  int? jumlah;
  String? tglPengeluaran;
  int? idStaff;

  Outcome({this.deskrpsi, this.jumlah, this.tglPengeluaran, this.idStaff});

  Future<void> tambahPengeluaran() async {
    final db = Supabase.instance.client;
    final response = await db
        .from('pengeluaran')
        .insert({
          'deskripsi': deskrpsi,
          'jumlah': jumlah,
          'tgl_pengeluaran': tglPengeluaran,
          'id_staff': idStaff
        })
        .select()
        .single();
    if (response.isEmpty) {
      print('Error inserting data: No response from server.');
    } else {
      print('Data inserted successfully: $response');
    }
  }
}

class TambahPerson {
  final String? namaStaff;
  final String? id;
  final String? nomorTlp;
  final String? status;
  TambahPerson({this.namaStaff, this.id, this.nomorTlp, this.status});

  Future<void> tambahPerson() async {
    final db = Supabase.instance.client;
    final response = await db
        .from('staff')
        .upsert(
            {'nama_staff': namaStaff, 'nomor_tlp': nomorTlp, 'status': false})
        .select()
        .single();
    if (response.isEmpty) {
      print('Error inserting data: No response from server.');
    } else {
      print('Data inserted successfully: $response');
    }
  }

  Future<void> deletePerson() async {
    int value = int.parse(id!);
    final db = Supabase.instance.client;
    final response = await db
        .from('staff')
        .delete()
        .match({'id_staff': value})
        .select()
        .single();
    if (response.isEmpty) {
      print('Error deleting data: No response from server.');
    } else {
      print('Data deleted successfully: $response');
    }
  }

  Future<void> updatePerson() async {
    int value = int.parse(id!);
    final db = Supabase.instance.client;

    // Update the specific id to true
    final response1 =
        await db.from('staff').update({'status': true}).eq('id_staff', value);

    // Update all other records to false
    final response2 =
        await db.from('staff').update({'status': false}).neq('id_staff', value);

    if (response1 == null || response2 == null) {
      print('Error updating data: No response from server.');
    } else {
      print('Data updated successfully: $response1 and $response2');
    }
  }
}
