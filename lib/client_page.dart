import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stream_tutorial/client.dart';
import 'package:flutter_stream_tutorial/client_bloc.dart';
import 'package:flutter_stream_tutorial/client_events.dart';
import 'package:flutter_stream_tutorial/client_state.dart';

class ClientPage extends StatefulWidget {
  const ClientPage({super.key});

  @override
  State<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends State<ClientPage> {
  //final clientsList = [];
  late final ClientBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ClientBloc();
    //Carrega lista inicial de clientes
    bloc.add(LoadClientEvent());
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  String randomName() {
    final rand = Random();
    return ['Maria Almeida', 'Vinicius Silva', 'Luiz Williams', 'Bianca Nevis']
        .elementAt(rand.nextInt(4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clientes"), actions: [
        IconButton(
            onPressed: () {
              bloc.add(AddClientEvent(client: Client(name: randomName())));
            },
            icon: const Icon(Icons.person_add))
      ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: BlocBuilder<ClientBloc, ClientState>(
            bloc: bloc,
            builder: (context, state) {
              if (state is ClientInitialState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is ClientSuccessState) {
                final clientsList = state.clients;
                return ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            child: ClipRRect(
                              // ignore: sort_child_properties_last
                              child: Text(
                                clientsList[index].name.substring(0, 1),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          title: Text(clientsList[index].name,
                              style: TextStyle(color: Colors.blue[900])),
                          trailing: IconButton(
                            icon: const Icon(Icons.remove, color: Colors.red),
                            onPressed: () {
                              bloc.add(RemoveClientEvent(
                                  client: clientsList[index]));
                            },
                          ),
                        ),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: clientsList.length);
              }

              return const SizedBox();
            }),
      ),
    );
  }
}
