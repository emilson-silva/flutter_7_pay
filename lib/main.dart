import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViaCEP API Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddressSearchScreen(),
    );
  }
}

class AddressSearchScreen extends StatefulWidget {
  const AddressSearchScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddressSearchScreenState createState() => _AddressSearchScreenState();
}

class _AddressSearchScreenState extends State<AddressSearchScreen> {
  TextEditingController ufController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  List<Address> addresses = [];

  Future<void> searchAddresses() async {
    String uf = ufController.text;
    String city = cityController.text;
    String street = streetController.text;
    String url = 'https://viacep.com.br/ws/$uf/$city/$street/json/';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body) as List;
      setState(() {
        addresses = data.map((json) => Address.fromJson(json)).toList();
      });
    } else {
      print('Failed to load addresses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: ufController,
                    decoration: const InputDecoration(
                      labelText: 'UF',

                      border: OutlineInputBorder(), // Adiciona uma borda
                    ),
                  ),
                ),
                const SizedBox(
                    width: 16.0), // Adiciona um espaço entre os campos
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: streetController,
                    decoration: const InputDecoration(
                      labelText: 'Street',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            ElevatedButton(
              onPressed: searchAddresses,
              child: const Text('Search'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(addresses[index].logradouro),
                    subtitle: Text(
                        '${addresses[index].bairro}, ${addresses[index].localidade}, ${addresses[index].uf}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Address {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;

  Address({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      cep: json['cep'],
      logradouro: json['logradouro'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      localidade: json['localidade'],
      uf: json['uf'],
    );
  }
}
