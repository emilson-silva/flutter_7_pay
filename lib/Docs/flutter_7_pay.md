# flutter_7_pay

Projeto Flutter.

## Getting Started

Este projeto é uma aplicação Flutter que permite ao usuário pesquisar e filtrar endereços. Ele usa a API do ViaCEP para buscar os endereços.

A classe ConsultarEnderecosPage é um StatefulWidget que mantém o estado da aplicação. Ela tem um estado \_ConsultarEnderecosPageState que contém a lógica da aplicação.

O estado contém cinco TextEditingController que são usados para obter a entrada do usuário para a UF, cidade, rua, UF do filtro e bairro do filtro.

A lista addresses contém todos os endereços retornados pela API e a lista filteredAddresses contém os endereços que correspondem aos critérios de filtro do usuário.

O método searchAddresses é usado para buscar os endereços da API. Ele constrói a URL da API usando a UF, cidade e rua fornecidas pelo usuário, faz a solicitação HTTP e, em seguida, decodifica a resposta JSON e atualiza o estado com os novos endereços.

O método filterAddresses é usado para filtrar os endereços com base na UF e no bairro fornecidos pelo usuário.

O método build constrói a interface do usuário da aplicação. Ele contém campos de texto para a entrada do usuário, um botão para iniciar a busca, uma lista para exibir os endereços retornados e campos de texto e um botão para o filtro.

A classe Address é um modelo de dados para um endereço. Ela tem um método de fábrica fromJson que é usado para criar uma instância de Address a partir de um Map JSON.
