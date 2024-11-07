// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../components/custom_drawer.dart';
import 'package:http/http.dart' as http;
import '../../utils/variables.dart';
import 'utils.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});
  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List<Event> _apiEvents = []; // Nueva lista para eventos de la API

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
  _fetchEvents().then((_) {
    _updateSelectedEvents(); // Actualiza los eventos seleccionados después de cargar los eventos de la API
  });
  }

Future<void> _fetchEvents() async {
  final response = await http.get(Uri.parse(ipOdoo));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    print(data);
    _apiEvents = data.map((e) {
      final title = e['title'];
      final start = DateTime.parse(e['start']);
      final end = DateTime.parse(e['end']);
      return Event(title, start, end);
    }).toList();
    print(_apiEvents);
    // Actualizar los eventos seleccionados
    _updateSelectedEvents();
    setState(() {}); // Actualizar el estado para reflejar los cambios
  } else {
    throw Exception('Failed to load events');
  }
}

   void _updateSelectedEvents() {
    if (_selectedDay != null) {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    } else if (_rangeStart != null && _rangeEnd != null) {
      _selectedEvents.value = _getEventsForRange(_rangeStart!, _rangeEnd!);
    }
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

List<Event> _getEventsForDay(DateTime day) {
  final List<Event> events = [...kEvents[day] ?? []];
  print('Events from kEvents for day $day: $events');

  final List<Event> apiEventsForDay = _apiEvents.where((event) {
    final isSameDay = event.start.year == day.year &&
        event.start.month == day.month &&
        event.start.day == day.day;
    print('Event: Title: ${event.title}, Start: ${event.start}, End: ${event.end}, isSameDay: $isSameDay');
    return isSameDay;
  }).toList();
  print('API Events for day $day: $apiEventsForDay');

  events.addAll(apiEventsForDay);
  print('All Events for day $day: $events');
  return events;
}




  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final List<DateTime> days = daysInRange(start, end);
    final List<Event> events = [];

    for (final day in days) {
      events.addAll(_apiEvents);
      events.addAll(kEvents[day] ?? []);
    }

    return events;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _updateSelectedEvents();
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    _updateSelectedEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calentario'),
      ),
      drawer:  CustomDrawer(),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: const CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
