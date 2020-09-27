import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users list"),
      ),
      drawer: Drawer(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              MaterialButton(
                minWidth: 200,
                onPressed: () {
                  //Agregar evento FilterUsersEvent con contexto del BlocProvider
                  _homeBloc..add(FilterUsersEvent(filterEven: false));
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Filtrar pares",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
              MaterialButton(
                minWidth: 200,
                onPressed: () {
                  //Agregar evento FilterUsersEvent con contexto del BlocProvider
                  _homeBloc..add(FilterUsersEvent(filterEven: true));
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Filtrar nones",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
              MaterialButton(
                minWidth: 200,
                onPressed: () {
                  //Agregar evento GetAllUsersEvent con contexto del BlocProvider
                  _homeBloc..add(GetAllUsersEvent());
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Mostrar todos los usuario",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => _homeBloc..add(GetAllUsersEvent()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            // para mostrar dialogos o snackbars
            if (state is ErrorState) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(content: Text("Error: ${state.error}")),
                );
            }
          },
          builder: (context, state) {
            if (state is ShowUsersState) {
              return RefreshIndicator(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey,
                  ),
                  itemCount: state.usersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(state.usersList[index].name),
                      subtitle: Text(state.usersList[index].username +
                          ", " +
                          state.usersList[index].company.name +
                          ".\n" +
                          state.usersList[index].address.street +
                          ", " +
                          state.usersList[index].address.city +
                          ".\n" +
                          state.usersList[index].phone +
                          ", "),
                    );
                  },
                ),
                onRefresh: () async {
                  BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
                },
              );
            } else if (state is LoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: MaterialButton(
                onPressed: () {
                  BlocProvider.of<HomeBloc>(context).add(GetAllUsersEvent());
                },
                child: Text("Cargar de nuevo"),
              ),
            );
          },
        ),
      ),
    );
  }
}
