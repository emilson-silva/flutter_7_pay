import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConsultarEnderecosPage extends StatefulWidget {
  const ConsultarEnderecosPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConsultarEnderecosPageState createState() => _ConsultarEnderecosPageState();
}

class _ConsultarEnderecosPageState extends State<ConsultarEnderecosPage> {
  TextEditingController ufController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController filterUfController = TextEditingController();
  TextEditingController filterBairroController = TextEditingController();

  List<Address> addresses = [];
  List<Address> filteredAddresses = [];

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
        filteredAddresses = List.from(addresses);
      });
    } else {
      print('Failed to load addresses');
    }
  }

  void filterAddresses() {
    setState(() {
      filteredAddresses = addresses.where((address) {
        return (filterUfController.text.isEmpty ||
                address.uf == filterUfController.text) &&
            (filterBairroController.text.isEmpty ||
                address.bairro == filterBairroController.text);
      }).toList();
    });
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
                  flex: 1,
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
                  flex: 2,
                  child: SizedBox(
                    child: TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: streetController,
                    decoration: const InputDecoration(
                      labelText: 'Rua',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
              ],
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: searchAddresses,
              child: const Text('Buscar'),
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
            const SizedBox(height: 24.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: filterUfController,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por UF',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: filterBairroController,
                    decoration: const InputDecoration(
                      labelText: 'Filtrar por Bairro',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: filterAddresses,
                    child: const Text('Filtrar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: ListView.builder(
                itemCount: filteredAddresses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredAddresses[index].logradouro),
                    subtitle: Text(
                        '${filteredAddresses[index].bairro}, ${filteredAddresses[index].localidade}, ${filteredAddresses[index].uf}'),
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
