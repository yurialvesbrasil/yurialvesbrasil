import 'package:bloc/bloc.dart';
import 'client_events.dart';
import 'client_repository.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  //Deveria ser passado por injeção de dependencias
  final _clientRepo = ClientRepository();

  // //Entrada de eventos
  // final StreamController<ClientEvent> _inputClientController =
  //     StreamController<ClientEvent>();

  // Sink<ClientEvent> get inputClient => _inputClientController.sink;

  // //Estados de saida
  // final StreamController<ClientState> _outputClientController =
  //     StreamController<ClientState>();

  // Stream<ClientState> get stream => _outputClientController.stream;

  ClientBloc() : super(ClientInitialState()) {
    //_inputClientController.stream.listen(_mapEventToState);
    on<LoadClientEvent>((event, emit) =>
        emit(ClientSuccessState(clients: _clientRepo.loadClients())));
    on<AddClientEvent>((event, emit) => emit(ClientSuccessState(
        clients: _clientRepo.addClient(client: event.client))));
    on<RemoveClientEvent>((event, emit) => emit(ClientSuccessState(
        clients: _clientRepo.removeClient(client: event.client))));
  }

  // _mapEventToState(ClientEvent event) {
  //   List<Client> clients = [];
  //   if (event is LoadClientEvent) {
  //     clients = _clientRepo.loadClients();
  //   } else if (event is AddClientEvent) {
  //     clients = _clientRepo.addClient(event.client);
  //   } else if (event is RemoveClientEvent) {
  //     clients = _clientRepo.removeClient(event.client);
  //   }

  //   _outputClientController.add(ClientSuccessState(clients: clients));
  // }
}
