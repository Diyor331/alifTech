import 'package:aliftech_test/blocs/navbar/navbar_cubit.dart';
import 'package:aliftech_test/db/todo_database.dart';
import 'package:aliftech_test/models/nav_bar_item.dart';
import 'package:aliftech_test/models/todo.dart';
import 'package:aliftech_test/ui/screens/screens.dart';
import 'package:aliftech_test/ui/widgets/widgets.dart';
import 'package:aliftech_test/util/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Main extends StatefulWidget {
  static const routeName = 'mainScreen';

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  late List<Todo> todos;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshTodos();
  }

  Future refreshTodos() async {
    setState(() {
      isLoading = true;
    });

    todos = await TodoDatabase.instance.readAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alif tech TODO',
        ),
        elevation: 0.0,
        actions: [
          //Add todos
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddEditTodo(),
              ));
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: BlocBuilder<NavigationCubit, NavigationState>(builder: (context, state) {
        if (state.navBarItem == NavBarItem.all) {
          //All
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : todos.isEmpty
                    ? Center(child: Text('Нет задач'))
                    : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          var item = todos[index];
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) async {
                              await TodoDatabase.instance.delete(item.id ?? 0);
                              // Remove the item from the data source.
                              setState(() {
                                todos.removeAt(index);
                              });

                              refreshTodos();

                              // Then show a snackbar.
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.todoName} Удален')));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 10,
                                  height: 70,
                                  margin: const EdgeInsets.only(bottom: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    color: TODO_COLOR[int.parse(item.todoStatus)]['color'],
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    isThreeLine: true,
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item.todoTime.toString().substring(0, 16)),
                                        Text(item.todoName),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => AddEditTodo(
                                            todo: item,
                                          ),
                                        ));
                                      },
                                    ),
                                    subtitle: Text(item.todoDescription),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
          );
        } else if (state.navBarItem == NavBarItem.progress) {
          //Progress
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : todos.isEmpty
                    ? const Center(child: Text('Нет задач'))
                    : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          var item = todos[index];
                          return item.todoStatus == '1'
                              ? Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) async {
                                    await TodoDatabase.instance.delete(item.id ?? 0);
                                    // Remove the item from the data source.
                                    setState(() {
                                      todos.removeAt(index);
                                    });

                                    refreshTodos();

                                    // Then show a snackbar.
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.todoName} Удален')));
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 70,
                                        margin: const EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                          color: TODO_COLOR[int.parse(item.todoStatus)]['color'],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          isThreeLine: true,
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item.todoTime.toString().substring(0, 16)),
                                              Text(item.todoName),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              // buildAddEdit(item);
                                            },
                                          ),
                                          subtitle: Text(item.todoDescription),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : item.todoStatus != '1'
                                  ? const Center(child: Text('Нет задач'))
                                  : const SizedBox();
                        },
                      ),
          );
        } else if (state.navBarItem == NavBarItem.completed) {
          //Completed
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : todos.isEmpty
                    ? const Center(child: Text('Нет задач'))
                    : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (BuildContext ctx, int index) {
                          var item = todos[index];
                          return item.todoStatus == '2'
                              ? Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) async {
                                    await TodoDatabase.instance.delete(item.id ?? 0);
                                    // Remove the item from the data source.
                                    setState(() {
                                      todos.removeAt(index);
                                    });

                                    refreshTodos();

                                    // Then show a snackbar.
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.todoName} Удален')));
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 70,
                                        margin: const EdgeInsets.only(bottom: 20),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                          color: TODO_COLOR[int.parse(item.todoStatus)]['color'],
                                        ),
                                      ),
                                      Expanded(
                                        child: ListTile(
                                          isThreeLine: true,
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item.todoTime.toString().substring(0, 16)),
                                              Text(item.todoName),
                                            ],
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () {
                                              // buildAddEdit(item);
                                            },
                                          ),
                                          subtitle: Text(item.todoDescription),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : item.todoStatus != '2'
                              ? const Center(child: Text('Нет задач'))
                              : const SizedBox();
                        },
                      ),
          );
        }
        return const SizedBox();
      }),
      bottomNavigationBar: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return BottomNavigation(
            currentNav: state.index,
            onTap: (index) {
              if (index == 0) {
                refreshTodos();
                BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.all);
              } else if (index == 1) {
                refreshTodos();
                BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.progress);
              } else if (index == 2) {
                refreshTodos();
                BlocProvider.of<NavigationCubit>(context).getNavBarItem(NavBarItem.completed);
              }
            },
          );
        },
      ),
    );
  }
}
