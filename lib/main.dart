
import 'package:flutter/material.d
  final List<String> _kategorien = ['Privat', 'Kunde', 'Lieferant'];
  final List<String> _typen = ['Termin intern', 'Termin extern'];
  String? _ausgewaehlteKategorie;
  String? _ausgewaehlterTyp;
art';
import 'package:table_calendar/table_calendar.dart';
import 'package:collection/collection.dart';

@pragma('vm:entry-point')
void main() {
  runApp(MeineTermineApp());
}

class MeineTermineApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Neuer Termin')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titelController,
              decoration: InputDecoration(labelText: 'Titel'),
            ),
            
            SizedBox(height: 16),
            Text('Farbe auswählen:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                _buildColorOption(Colors.blue),
                _buildColorOption(Colors.red),
                _buildColorOption(Colors.green),
                _buildColorOption(Colors.orange),
                _buildColorOption(Colors.purple),
                _buildColorOption(Colors.yellow),
                _buildColorOption(Colors.brown),
                _buildColorOption(Colors.grey),
              ],
            ),

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
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Kategorie wählen'),
              value: _ausgewaehlteKategorie,
              items: _kategorien.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
              onChanged: (wert) => setState(() => _ausgewaehlteKategorie = wert),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Typ wählen'),
              value: _ausgewaehlterTyp,
              items: _typen.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
              onChanged: (wert) => setState(() => _ausgewaehlterTyp = wert),
            ),
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
            
            SizedBox(height: 16),
            Text('Farbe auswählen:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                _buildColorOption(Colors.blue),
                _buildColorOption(Colors.red),
                _buildColorOption(Colors.green),
                _buildColorOption(Colors.orange),
                _buildColorOption(Colors.purple),
                _buildColorOption(Colors.yellow),
                _buildColorOption(Colors.brown),
                _buildColorOption(Colors.grey),
              ],
            ),

            ElevatedButton(
              onPressed: () {
                if (_titelController.text.isNotEmpty && _ausgewaehltesDatum != null) {
                  Navigator.pop(context, {
                    'titel': _titelController.text,
                    'datum': _ausgewaehltesDatum,
                    'farbe': _kategorieFarbe,
                    'kategorie': _ausgewaehlteKategorie,
                    'typ': _ausgewaehlterTyp,
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

            child: Text(_ausgewaehltesDatum == null
                ? 'Datum auswählen'
                : _ausgewaehltesDatum.toString())
          )
          SizedBox(height: 16)
          ElevatedButton(
            onPressed: () async {
              final time = await showTimePicker(
                context: context
                initialTime: TimeOfDay.now()
              );
              if (time != null) {
                setState(() {
                  _startZeit = time;
                });
              }
            }
            child: Text(_startZeit == null
                ? 'Startzeit auswählen'
                : _startZeit!.format(context))
          )
          ElevatedButton(
            onPressed: () async {
              final time = await showTimePicker(
                context: context
                initialTime: TimeOfDay.now()
              );
              if (time != null) {
                setState(() {
                  _endZeit = time;
                });
              }
            }
            child: Text(_endZeit == null
                ? 'Endzeit auswählen'
                : _endZeit!.format(context))
          )
          SizedBox(height: 16)
          
          SizedBox(height: 16)
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Kategorie wählen')
            value: _ausgewaehlteKategorie
            items: _kategorien.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList()
            onChanged: (wert) => setState(() => _ausgewaehlteKategorie = wert)
          )
          SizedBox(height: 16)
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Typ wählen')
            value: _ausgewaehlterTyp
            items: _typen.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList()
            onChanged: (wert) => setState(() => _ausgewaehlterTyp = wert)
          )
          SizedBox(height: 16)
          DropdownButtonFormField<Color>(
            decoration: InputDecoration(labelText: 'Farbe wählen')
            value: _kategorieFarbe
            items: [
              Colors.blue
              Colors.green
              Colors.red
              Colors.orange
              Colors.purple
              Colors.teal
              Colors.brown
              Colors.pink
            ].map((farbe) {
              return DropdownMenuItem(
                value: farbe
                child: Row(
                  children: [
                    Container(width: 16, height: 16, color: farbe, margin: EdgeInsets.only(right: 8))
                    Text(farbe.toString().split('.').last)
                  ]
                )
              );
            }).toList()
            onChanged: (farbe) => setState(() => _kategorieFarbe = farbe!)
          )

            value: _ausgewaehlterTyp
            items: _typen.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList()
            onChanged: (wert) => setState(() => _ausgewaehlterTyp = wert)
          )
ElevatedButton(
            onPressed: () {
              if (_titelController.text.isNotEmpty &&
                  _ausgewaehltesDatum != null &&
                  _startZeit != null &&
                  _endZeit != null) {
                Navigator.pop(context, {
                  'titel': _titelController.text
                  'datum': _ausgewaehltesDatum
                  'von': _startZeit!.format(context)
                  'bis': _endZeit!.format(context)
                  'farbe': _kategorieFarbe
                  'kategorie': _ausgewaehlteKategorie
                  'typ': _ausgewaehlterTyp
                });
              }
            }
            ,
              child: Text('Termin speichern')
          )
        ])
      ))
    );
  }

  Widget _buildColorOption(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _kategorieFarbe = color;
        });
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _kategorieFarbe == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

}