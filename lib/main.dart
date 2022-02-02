import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Question Dropdown",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(
        optionStream: BehaviorSubject<Option>(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final BehaviorSubject<Option> optionStream;

  const HomePage({
    Key? key,
    required this.optionStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Question Dropdown"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: StreamBuilder<Option>(
                    initialData: Option.A,
                    stream: optionStream,
                    builder: (context, snapshot) {
                      final option = snapshot.data ?? Option.A;
                      return _dropDownMenu(context, option);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropDownMenu(
    BuildContext context,
    Option option,
  ) {
    const items = Option.values;
    return GestureDetector(
      onTapDown: (details) async {
        final offset = details.globalPosition;
        final newOption = await showMenu(
          context: context,
          position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
          items: items.map((e) => _dropdownItem(context, e, option)).toList(),
        );
        if (newOption != null) {
          optionStream.add(newOption);
        }
      },
      child: _dropdownHandler(context, option),
    );
  }

  OptionsItemHelper _dropDownItemData(
    BuildContext context,
    Option option,
  ) {
    Widget icon;
    String text;
    switch (option) {
      case Option.A:
        icon = const Icon(Icons.ac_unit);
        text = "An option";
        break;
      case Option.B:
        icon = const Icon(Icons.baby_changing_station);
        text = "Best option";
        break;
      case Option.C:
        icon = const Icon(Icons.cake_sharp);
        text = "Closest option";
        break;
      case Option.D:
        icon = const Icon(Icons.dashboard);
        text = "Dumb option";
        break;
    }
    return OptionsItemHelper(text, icon);
  }

  Widget _dropdownHandler(
    BuildContext context,
    Option option,
  ) {
    final helper = _dropDownItemData(context, option);
    return helper.icon;
  }

  PopupMenuEntry<Option> _dropdownItem(
    BuildContext context,
    Option option,
    Option selected,
  ) {
    final helper = _dropDownItemData(context, option);
    return CheckedPopupMenuItem<Option>(
      value: option,
      checked: option == selected,
      child: Row(
        children: [
          Expanded(child: Container()),
          Text(helper.text),
          const SizedBox(width: 16),
          helper.icon,
        ],
      ),
    );
  }
}

enum Option {
  A,
  B,
  C,
  D,
}

class OptionsItemHelper {
  final String text;
  final Widget icon;

  OptionsItemHelper(
    this.text,
    this.icon,
  );
}
