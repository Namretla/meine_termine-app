
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:table_calendar/table_calendar.dart'; // Wichtig für Kalender

void main() {
  runApp(MeineTermineApp());
}

class MeineTermineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meine Termine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TermineHomePage(),
    );
  }
}

class TermineHomePage extends StatefulWidget {
  @override
  _TermineHomePageState createState() => _TermineHomePageState();
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
          bottom: TabBar(
            tabs: [
              Tab(text: "Liste"),
              Tab(text: "Kalender"),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                final neuerTermin = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NeuerTerminSeite(),
                  ),
                );
                if (neuerTermin != null) {
                  setState(() {
                    termine.add(neuerTermin);
                  });
                  _scheduleMultipleNotifications(
                    titel: neuerTermin['titel'],
                    datum: neuerTermin['datum'],
                  );
                }
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            _buildTerminListe(),
            _buildKalender(),
          ],
        ),
      ),
    );
  }

  Widget _buildTerminListe() {
    return ListView.builder(
      itemCount: termine.length,
      itemBuilder: (context, index) {
        final termin = termine[index];
        return ListTile(
          leading: Icon(Icons.event, color: termin['farbe']),
          title: Text(termin['titel']),
          subtitle: Text(termin['datum'].toString()),
        );
      },
    );
  }

  Widget _buildKalender() {
    return TableCalendar(
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
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(color: Colors.red),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
      ),
    );
  }

  void _scheduleMultipleNotifications({required String titel, required DateTime datum}) async {
    await _scheduleSingleNotification(
      id: datum.hashCode,
      titel: titel,
      body: 'In 1 Woche: $titel',
      scheduledTime: datum.subtract(Duration(days: 7)),
    );

    await _scheduleSingleNotification(
      id: datum.hashCode + 1,
      titel: titel,
      body: 'In 1 Tag: $titel',
      scheduledTime: datum.subtract(Duration(days: 1)),
    );

    await _scheduleSingleNotification(
      id: datum.hashCode + 2,
      titel: titel,
      body: 'In 1 Stunde: $titel',
      scheduledTime: datum.subtract(Duration(hours: 1)),
    );

    await _scheduleSingleNotification(
      id: datum.hashCode + 3,
      titel: titel,
      body: 'In 10 Minuten: $titel',
      scheduledTime: datum.subtract(Duration(minutes: 10)),
    );
  }

  Future<void> _scheduleSingleNotification({
    required int id,
    required String titel,
    required String body,
    required DateTime scheduledTime,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'deine_kalender_app',
      'Terminerinnerungen',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    var notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      titel,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
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
  Color _kategorieFarbe = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Neuer Termin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
              onPressed: () {
                if (_titelController.text.isNotEmpty && _ausgewaehltesDatum != null) {
                  Navigator.pop(context, {
                    'titel': _titelController.text,
                    'datum': _ausgewaehltesDatum,
                    'farbe': _kategorieFarbe,
                  });
                }
              },
              child: Text('Termin speichern'),
            )
          ],
        ),
      ),
    );
  }
}
