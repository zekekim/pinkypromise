import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pinkypromise/controllers/auth_controller.dart';
import 'package:pinkypromise/controllers/item_list_controller.dart';
import 'package:pinkypromise/pages/nav_screen.dart';
import 'package:pinkypromise/providers/auth_providers.dart';
import 'package:pinkypromise/repos/custom_exception.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'dart:io';

import 'models/item_model.dart';
import 'pages/widgets/custom_tab_bar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authState = useProvider(authControllerProvider);
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'PlayfairDisplay',
          canvasColor: Colors.orange[100],
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.orange[50]),
      home: authState != null ? const HomePage() : const LoginPage(),
    );
  }
}

class HomePage extends StatefulHookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final authState = useProvider(authControllerProvider);
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: const Text("pinky promise"),
              backgroundColor: Colors.orange[200],
              floating: true,
              forceElevated: innerBoxIsScrolled,
              actions: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.person),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.settings),
                )
              ],
            ),
          ];
        },
        body: NavScreen(),
      ),
    );
  }
}

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final List<int> _items = List<int>.generate(50, (int index) => index);
  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: [
        for (int index = 0; index < _items.length; index++)
          Padding(
            padding: const EdgeInsets.all(8.0),
            key: Key('$index'),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              tileColor: Colors.orange[100],
              title: Text('Item ${_items[index]}'),
            ),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final int item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
    );
  }
}

class LoginPage extends StatefulHookWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController ctrl = TextEditingController();
    var maskFormatter = MaskTextInputFormatter(
        mask: '(###) ###-####', filter: {"#": RegExp(r'[0-9]')});
    var phoneState = useProvider(phoneNumberProvider).state;
    var errorState = useProvider(authExceptionProvider).state;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: 190,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "sign up",
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  showCursor: false,
                  controller: ctrl,
                  style: const TextStyle(fontSize: 30.0),
                  decoration: const InputDecoration(
                    hintText: ('(123) 456-7890'),
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  inputFormatters: [maskFormatter],
                  keyboardType: TextInputType.phone,
                  onSubmitted: (value) {
                    context.read(phoneNumberProvider).state =
                        '+1' + maskFormatter.unmaskText(value);
                    print(phoneState);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SmsPage()));
                  },
                ),
                const SizedBox(height: 25),
                Container(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      context.read(phoneNumberProvider).state =
                          '+1' + maskFormatter.unmaskText(ctrl.text);
                      print(phoneState);
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SmsPage()));
                    },
                    child: const Text(
                      "next",
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                          fontSize: 15.0),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.orange[100]),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  errorState?.message ?? '',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhonePage extends StatefulWidget {
  const PhonePage({Key? key}) : super(key: key);

  @override
  _PhonePageState createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class SmsPage extends StatefulHookWidget {
  const SmsPage({Key? key}) : super(key: key);

  @override
  _SmsPageState createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final phoneNo = context.read(phoneNumberProvider).state;
      print(phoneNo);
      final provider = context.read(authControllerProvider.notifier);
      provider.verifyPhone();
    });
  }

  @override
  Widget build(BuildContext context) {
    var sms = useProvider(smsProvider).state;
    var authNotifier = useProvider(authControllerProvider.notifier);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PinFieldAutoFill(
              decoration: UnderlineDecoration(
                colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
              ),
              currentCode: sms,
              onCodeSubmitted: (code) {
                context.read(smsProvider).state = code;
                try {
                  authNotifier.signIn();
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                } on CustomException catch (e) {
                  print(e.message);
                }
              },
              onCodeChanged: (code) {
                context.read(smsProvider).state = code ?? '';
              },
            ),
            TextButton(
                onPressed: () async {
                  try {
                    await authNotifier.signIn();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } on CustomException catch (e) {
                    print(e.message);
                  }
                },
                child: const Text('submit'))
          ],
        ),
      ),
    );
  }
}

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

final helloWorldProvider = Provider((ref) => 'HelloWorld');

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authControllerState = useProvider(authControllerProvider);
    final itemListFilter = useProvider(itemListFilterProvider);
    final isObtainedFilter = itemListFilter.state == ItemListFilter.obtained;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        leading: authControllerState != null
            ? IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () =>
                    context.read(authControllerProvider.notifier).signOut(),
              )
            : null,
        actions: [
          IconButton(
            onPressed: () => itemListFilter.state =
                isObtainedFilter ? ItemListFilter.all : ItemListFilter.obtained,
            icon: Icon(
              isObtainedFilter
                  ? Icons.check_circle
                  : Icons.check_circle_outline,
            ),
          ),
        ],
      ),
      body: ProviderListener(
        provider: itemListExceptionProvider,
        onChange: (
          BuildContext context,
          StateController<CustomException?> customException,
        ) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(customException.state!.message!),
            ),
          );
        },
        child: const ItemList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddItemDialog.show(context, Item.empty()),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddItemDialog extends HookWidget {
  static void show(BuildContext context, Item item) {
    showDialog(
      context: context,
      builder: (context) => AddItemDialog(item: item),
    );
  }

  final Item item;

  const AddItemDialog({Key? key, required this.item}) : super(key: key);

  bool get isUpdating => item.id != null;

  @override
  Widget build(BuildContext context) {
    final textController = useTextEditingController(text: item.name);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Item name'),
            ),
            const SizedBox(
              height: 12.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: isUpdating
                      ? Colors.orange
                      : Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  isUpdating
                      ? context
                          .read(itemListControllerProvider.notifier)
                          .updateItem(
                            updatedItem: item.copyWith(
                              name: textController.text.trim(),
                              obtained: item.obtained,
                            ),
                          )
                      : context
                          .read(itemListControllerProvider.notifier)
                          .addItem(name: textController.text.trim());
                  Navigator.of(context).pop();
                },
                child: Text(isUpdating ? 'Update' : 'Add'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

final currentItem = ScopedProvider<Item>((_) {
  throw UnimplementedError();
});

class ItemList extends HookWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemListState = useProvider(itemListControllerProvider);
    final filteredItemList = useProvider(filteredItemListProvider);
    return itemListState.when(
      data: (items) => items.isEmpty
          ? const Center(
              child: Text(
                'Tap + to add an item',
                style: TextStyle(fontSize: 20.0),
              ),
            )
          : ListView.builder(
              itemCount: filteredItemList.length,
              itemBuilder: (BuildContext context, int index) {
                final item = filteredItemList[index];
                return ProviderScope(
                  overrides: [currentItem.overrideWithValue(item)],
                  child: const ItemTile(),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ItemListError(
        message:
            error is CustomException ? error.message! : 'Something went wrong!',
      ),
    );
  }
}

class ItemListError extends StatelessWidget {
  final String message;
  const ItemListError({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, style: const TextStyle(fontSize: 20.0)),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () => context
                .read(itemListControllerProvider.notifier)
                .retrieveItems(isRefreshing: true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class ItemTile extends HookWidget {
  const ItemTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final item = useProvider(currentItem);
    return ListTile(
      key: ValueKey(item.id),
      title: Text(item.name),
      trailing: Checkbox(
        value: item.obtained,
        onChanged: (val) => context
            .read(itemListControllerProvider.notifier)
            .updateItem(updatedItem: item.copyWith(obtained: !item.obtained)),
      ),
      onTap: () => AddItemDialog.show(context, item),
      onLongPress: () => context
          .read(itemListControllerProvider.notifier)
          .deleteItem(itemId: item.id!),
    );
  }
}
