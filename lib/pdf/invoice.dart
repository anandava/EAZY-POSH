import 'package:http/http.dart' as http;
import 'dart:convert';

class Invoice {
  final String namaStaff;
  final String date;
  final List<Map<String, dynamic>> items;
  final int total;
  final int id = DateTime.now().millisecondsSinceEpoch;
  final int subtotal;
  final String payment;
  final int change;

  Invoice({
    required this.namaStaff,
    required this.date,
    required this.items,
    required this.total,
    required this.subtotal,
    required this.payment,
    required this.change,
  });

  String generateHtml() {
    final itemRows = items.map((item) {
      return '''
      <tr>
        <td>${item['nama_menu']}</td>
        <td>${item['jumlah']}</td>
        <td>${item['total']}</td>
      </tr>
      ''';
    }).join();

    return '''
    <html>
    <body>
      <h1>Invoice $id</h1>
      <p>Date: $date</p>
      <p>Staff: $namaStaff</p>
      <table border="1" cellpadding="5">
        <thead>
          <tr>
            <th>Item</th>
            <th>Quantity</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          $itemRows
        </tbody>
      </table>
      <p>Subtotal: $subtotal</p>
      <p>Payment: $payment</p>
      <p>Change: $change</p>
      <p>Jl. Nuri pikgondang No.17, Kentungan, Condongcatur, Kec. Depok, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55281</p>
    </body>
    </html>
    ''';
  }

  Future<void> sendEmail() async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final htmlContent = generateHtml();

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'origin': 'http://localhost', // Necessary for CORS
      },
      body: json.encode({
        'service_id': 'service_d2wuxbh',
        'template_id': 'template_drxh2mk',
        'user_id': 'FFeQTKUXcYAqXBU8B',
        'template_params': {
          'html_message': htmlContent,
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }
}
