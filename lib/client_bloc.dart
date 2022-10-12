import 'dart:async';
import 'package:flutter_stream_tutorial/client.dart';
import 'package:flutter_stream_tutorial/client_state.dart';
import 'client_events.dart';
import 'client_repository.dart';

class ClientBloc {
  //Deveria ser passado por injeção de dependencias
  final _clientRepo = ClientRepository();

  //Entrada de eventos
  final StreamController<ClientEvent> _inputClientController =
      StreamController<ClientEvent>();

  Sink<ClientEvent> get inputClient => _inputClientController.sink;

  //Estados de saida
  final StreamController<ClientState> _outputClientController =
      StreamController<ClientState>();

  Stream<ClientState> get stream => _outputClientController.stream;

  ClientBloc() {
    _inputClientController.stream.listen(_mapEventToState);
  }

  _mapEventToState(ClientEvent event) {
    List<Client> clients = [];
    if (event is LoadClientEvent) {
      clients = _clientRepo.loadClients();
    } else if (event is AddClientEvent) {
      clients = _clientRepo.addClient(event.client);
    } else if (event is RemoveClientEvent) {
      clients = _clientRepo.removeClient(event.client);
    }

    _outputClientController.add(ClientSuccessState(clients: clients));
  }
}
