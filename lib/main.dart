
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MeineTermineApp());
}

class MeineTermineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meine Termine',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TermineHomePage(),
    );
  }
}

class TermineHomePage extends StatefulWidget {
  @override
  _TermineHomePageState createState() => _TermineHomePageState();
}


Map<DateTime, List<Map<String, dynamic>>> _events = {};

List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
  return _events[DateTime(day.year, day.month, day.day)] ?? [];
}
class _TermineHomePageState extends State<TermineHomePage> {
  List<Map<String, dynamic>> termine = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Meine Termine'),
          
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final neuerTermin = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NeuerTerminSeite()),
                );
                if (neuerTermin != null) {
                  setState(() {
                    termine.add(neuerTermin);
                  final tag = DateTime(neuerTermin['datum'].year, neuerTermin['datum'].month, neuerTermin['datum'].day);
                  if (_events.containsKey(tag)) {
                    _events[tag]!.add(neuerTermin);
                  } else {
                    _events[tag] = [neuerTermin];
                  }
                  });
                }
              },
            ),
          ],
        ),
        body: _buildKalender(),
      ),
    );
  }



  Widget _buildKalender() {
    return TableCalendar(
      eventLoader: _getEventsForDay,
      
      
      
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Column(
              children: events.map((event) {
                final Color baseColor = event['farbe'] ?? Colors.blue;
                final bool istExtern = event['typ'] == 'Termin extern';
                final Color farbe = istExtern ? baseColor : baseColor.withOpacity(0.4);
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  margin: EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    color: farbe,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event['titel'],
                    style: TextStyle(fontSize: 10, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            );
          }
          return SizedBox.shrink();
        },
      ),



      focusedDay: _selectedDay,
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      calendarStyle: CalendarStyle(weekendTextStyle: TextStyle(color: Colors.red)),
      headerStyle: HeaderStyle(formatButtonVisible: true, titleCentered: true),
    );
  }
}

class NeuerTerminSeite extends StatefulWidget {
  @override
  _NeuerTerminSeiteState createState() => _NeuerTerminSeiteState();
}

class _NeuerTerminSeiteState extends State<NeuerTerminSeite> {
  final _titelController = TextEditingController();
  DateTime? _ausgewaehltesDatum;
  TimeOfDay? _startZeit;
  TimeOfDay? _endZeit;
  Color _kategorieFarbe = Colors.blue;
  final List<String> _kategorien = ['Privat', 'Kunde', 'Lieferant'];
  final List<String> _typen = ['Termin intern', 'Termin extern'];
  String? _ausgewaehlteKategorie;
  String? _ausgewaehlterTyp;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Neuer Termin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: _titelController,
            decoration: InputDecoration(labelText: 'Titel'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final datum = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (datum != null) {
                setState(() {
                  _ausgewaehltesDatum = datum;
                });
              }
            },
            child: Text(_ausgewaehltesDatum == null
                ? 'Datum auswählen'
                : _ausgewaehltesDatum.toString()),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _startZeit = time;
                });
              }
            },
            child: Text(_startZeit == null
                ? 'Startzeit auswählen'
                : _startZeit!.format(context)),
          ),
          ElevatedButton(
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _endZeit = time;
                });
              }
            },
            child: Text(_endZeit == null
                ? 'Endzeit auswählen'
                : _endZeit!.format(context)),
          ),
          SizedBox(height: 16),
          
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Kategorie wählen'),
            value: _ausgewaehlteKategorie,
            items: _kategorien.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
            onChanged: (wert) => setState(() => _ausgewaehlteKategorie = wert),
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Typ wählen')
          SizedBox(height: 16),
          DropdownButtonFormField<Color>(
            decoration: InputDecoration(labelText: 'Farbe wählen'),
            value: _kategorieFarbe,
            items: [
              Colors.blue,
              Colors.green,
              Colors.red,
              Colors.orange,
              Colors.purple,
              Colors.teal,
              Colors.brown,
              Colors.pink
            ].map((farbe) {
              return DropdownMenuItem(
                value: farbe,
                child: Row(
                  children: [
                    Container(width: 16, height: 16, color: farbe, margin: EdgeInsets.only(right: 8)),
                    Text(farbe.toString().split('.').last),
                  ],
                ),
              );
            }).toList(),
            onChanged: (farbe) => setState(() => _kategorieFarbe = farbe!),
          ),
,
            value: _ausgewaehlterTyp,
            items: _typen.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
            onChanged: (wert) => setState(() => _ausgewaehlterTyp = wert),
          ),
ElevatedButton(
            onPressed: () {
              if (_titelController.text.isNotEmpty &&
                  _ausgewaehltesDatum != null &&
                  _startZeit != null &&
                  _endZeit != null) {
                Navigator.pop(context, {
                  'titel': _titelController.text,
                  'datum': _ausgewaehltesDatum,
                  'von': _startZeit!.format(context),
                  'bis': _endZeit!.format(context),
                  'farbe': _kategorieFarbe,
                  'kategorie': _ausgewaehlteKategorie,
                  'typ': _ausgewaehlterTyp,
                });
              }
            },
            child: Text('Termin speichern'),
          ),
        ]),
      ),
    );
  }
}
