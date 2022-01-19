import 'package:aliftech_test/db/todo_database.dart';
import 'package:aliftech_test/models/todo.dart';
import 'package:aliftech_test/ui/styles/styles.dart';
import 'package:aliftech_test/ui/widgets/custom_textfield.dart';
import 'package:aliftech_test/util/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'main.dart';

class AddEditTodo extends StatefulWidget {
  final Todo? todo;

  const AddEditTodo({Key? key, this.todo}) : super(key: key);

  @override
  _AddEditTodoState createState() => _AddEditTodoState();
}

class _AddEditTodoState extends State<AddEditTodo> {
  late List<Todo> todos;
  final _formKey = GlobalKey<FormState>();
  TextEditingController todoNameController = TextEditingController();
  TextEditingController todoDescController = TextEditingController();
  bool switchValue = false;
  bool checkStatus = false;
  bool checkDate = false;
  bool isLoading = false;
  String todoStatus = 'Статус';
  late Todo todo;
  late DateTime dateTime = DateTime.now();

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
  void initState() {
    todoNameController = TextEditingController(text: widget.todo?.todoName ?? '');
    todoDescController = TextEditingController(text: widget.todo?.todoDescription ?? '');
    todoStatus = widget.todo?.todoStatus ?? 'Статус';
    dateTime = widget.todo?.todoTime ?? DateTime.now();
    switchValue = widget.todo != null ? true : false;
    refreshTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: widget.todo == null ? const Text('Добавление задач') : const Text('Редактирование'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: [
            //Fields "todoName" and "todoStatus"
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: CustomTextField(
                        hint: 'Название',
                        controller: todoNameController,
                        validator: (val) {
                          if (val.isEmpty) return 'Заполните поле';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xffE5E5E5),
                      indent: 10,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                      child: CustomTextField(
                        hint: 'Комментарий',
                        controller: todoDescController,
                        validator: (val) {
                          if (val.isEmpty) return 'Заполните поле';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              height: MediaQuery.of(context).size.height / 3,
              width: 300,
            ),
            const SizedBox(height: 15),
            //todoStatus
            ListTile(
              tileColor: Colors.grey.shade100,
              leading: Icon(
                Icons.check_box_outline_blank,
                color: primaryColor,
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.menu),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                onSelected: (val) {
                  setState(() {
                    todoStatus = val;
                  });
                },
                itemBuilder: (context) => <PopupMenuItem<String>>[
                  const PopupMenuItem<String>(
                    value: '0',
                    child: Text('Активный'),
                  ),
                  const PopupMenuItem<String>(
                    value: '1',
                    child: Text('В процессе'),
                  ),
                  const PopupMenuItem<String>(
                    value: '2',
                    child: Text('Завершенный'),
                  ),
                ],
              ),
              title: Text(
                todoStatus == 'Статус' ? 'Статус' : TODO_STATUS[int.parse(todoStatus)]['name'].toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            //Check status
            checkStatus
                ? const Padding(
                    padding: EdgeInsets.only(top:8.0),
                    child: Text(
                      'Выберите статус задачи',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  )
                : const SizedBox(height: 20),
            const SizedBox(height: 20),
            //todoTime
            ListTile(
              tileColor: Colors.grey.shade100,
              leading: const Icon(
                Icons.calendar_today,
                color: Colors.red,
              ),
              trailing: CupertinoSwitch(
                onChanged: (bool value) {
                  setState(() {
                    switchValue = !switchValue;
                  });
                },
                value: switchValue,
              ),
              title: const Text(
                'Дата',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            switchValue
                ? SfDateRangePicker(
                    initialSelectedDate: dateTime,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                      dateTime = args.value;
                    },
                  )
                : const SizedBox(),
            const SizedBox(height: 15),
            //Button create or update
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(0xffF8CB36)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (todoStatus == 'Статус') {
                    setState(() {
                      checkStatus = true;
                    });
                  }

                  if (_formKey.currentState!.validate() && todoStatus.toString() != 'Статус') {
                    setState(() {
                      checkStatus = false;
                    });

                    addOrUpdateNote();
                    todoNameController.clear();
                    todoDescController.clear();
                    todoStatus = 'Статус';
                    switchValue = false;
                  }
                },
                child:  Text(
                  widget.todo == null ? 'Создать' : 'Обновить',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  //Check add or update data
  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.todo != null;

      if (isUpdating) {
        await updateTodo();
      } else {
        await addTodo();
      }

      refreshTodos();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Main()),
            (Route<dynamic> route) => false,
      );
    }
  }

  //Create
  Future addTodo() async {
    final todo = Todo(
      todoName: todoNameController.text,
      todoDescription: todoDescController.text,
      todoStatus: todoStatus,
      todoTime: dateTime,
    );

    await TodoDatabase.instance.create(todo);
  }

//Update
  Future updateTodo() async {
    final todo = widget.todo!.copy(
      todoName: todoNameController.text,
      todoDescription: todoDescController.text,
      todoStatus: todoStatus,
      todoTime: dateTime,
    );

    await TodoDatabase.instance.update(todo);
  }
}
