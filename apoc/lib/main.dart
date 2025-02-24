import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/apod.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Astronomy Picture of the Day',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  
  var apods = <Apod>[];

  var dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('apod.json');
    final data = await json.decode(response);
    for (final apod in data) {
      if (apod['media_type'] == 'image') {
        apods.add(Apod.fromJson(apod));
      }
    }
    notifyListeners();
  }

  var current = 0;

  void nextDay() {
    current = (current+1)%apods.length;
    notifyListeners();
  }

  void changeDay(int index) {
    current = index;
    notifyListeners();
  }

  void previousDay() {
    current = (current-1)%apods.length;
    notifyListeners();
  }

  var favorites = <int>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }

}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();
    var selectedIndex = appState.current;
    var apods = appState.apods;

    if (apods.isEmpty) {
      appState.readJson();
    }

    Widget page;
    if (apods.isEmpty) {
      page = Center(
        child: CircularProgressIndicator(),
      );
    } else {
      var apod = apods[selectedIndex];
      page = Center(
        child: Image.network(
          apod.hdurl,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) => 
              loadingProgress == null ? child :
              Center(
                child: CircularProgressIndicator(
                  color: Colors.indigo,
                ),
              ),
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => 
            Center(
              child: Icon(Icons.error, color: Colors.red),
            )
        ),
      );
    }

    IconData iconFavorite;
    if (appState.favorites.contains(selectedIndex)) {
      iconFavorite = Icons.favorite;
    } else {
      iconFavorite = Icons.favorite_border;
    }

    return Scaffold(
      bottomNavigationBar: BottomBarWidget(),
      floatingActionButton: FloatingActionButton(

        onPressed: appState.toggleFavorite,
        child: Icon(iconFavorite),
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomBarWidget extends StatelessWidget {

  const BottomBarWidget({
    super.key,
  });

  void showInfo(BuildContext context, Apod apod, DateFormat dateFormat) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Wrap(
              children: [
                Column(
                  children: [
                    Text(dateFormat.format(apod.date), style: Theme.of(context).textTheme.bodyMedium),
                    Text(apod.title, style: Theme.of(context).textTheme.headlineMedium),
                    SizedBox(height: 10),
                    Text(apod.explanation),
                  ],
                ),
              ],
            ),
          );
      },
      );
  }

  void showFavs(BuildContext context, List<Apod> apods, List<int> favorites, DateFormat dateFormat) {

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        if (favorites.isEmpty) {
          return Wrap(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text('No favorites yet.'),
                ),
              ),
            ]
          );
        }

        return ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                  'You have ${favorites.length} favorites',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
            ),
            for (var index in favorites)
              ListTile(
                leading: AspectRatio(
                  aspectRatio: 5/4,
                  child: Image.network(
                      apods[index].url,
                      fit: BoxFit.fill,
                    ),
                ),
                title: Text(apods[index].title),
                subtitle: Text(dateFormat.format(apods[index].date)),
                trailing: IconButton(
                  tooltip: "Voir",
                  onPressed: () => context.read<MyAppState>().changeDay(index),
                  icon: Icon(Icons.visibility)
                ),
              ),
          ],
        );
          },
          );
  }

  Future selectDate(BuildContext context, List<Apod> apods, int current, Function changeDay) async {

    return showDatePicker(
      context: context,
      initialDate: apods[current].date,
      firstDate: apods.first.date,
      lastDate: apods.last.date,
      selectableDayPredicate: (day) => apods.any((apod) => apod.date == day),

    ).then((DateTime? selected) {
      if (selected != null) {
        var index = apods.indexWhere((apod) => apod.date == selected);
        if (index != -1) {
          changeDay(index);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return BottomAppBar(
      
      child: Row(
        children: [
          IconButton(tooltip: "Voir les favoris", onPressed: () => showFavs(
              context, appState.apods, appState.favorites, appState.dateFormat
            ), icon: Icon(Icons.bookmark_outline)),
          IconButton(tooltip: "Voir les infos", onPressed: () => showInfo(
              context, appState.apods[appState.current], appState.dateFormat
            ), icon: Icon(Icons.info_outline)),
          Expanded(child: Container()),
          IconButton(tooltip: "Précédente", onPressed: appState.previousDay, icon: Icon(Icons.arrow_back)),
          IconButton(tooltip: "Choisir une date", onPressed: () => selectDate(
            context, appState.apods, appState.current, appState.changeDay
            ), icon: Icon(Icons.calendar_today)),
          IconButton(tooltip: "Suivante", onPressed: appState.nextDay, icon: Icon(Icons.arrow_forward)),
        ],
      ),
    );
  }
}