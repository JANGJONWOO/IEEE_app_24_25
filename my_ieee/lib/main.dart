/*import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

extension DateTimeExt on DateTime {
  DateTime get monthStart => DateTime(year, month);
  DateTime get dayStart => DateTime(year, month, day);

  DateTime addMonth(int count) {
    return DateTime(year, month + count, day);
  }

  bool isSameDate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isToday {
    return isSameDate(DateTime.now());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DateTime selectedMonth;

  DateTime? selectedDate;

  @override
  void initState() {
    selectedMonth = DateTime.now().monthStart;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 450,
          width: 250,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Header(
                selectedMonth: selectedMonth,
                selectedDate: selectedDate,
                onChange: (value) => setState(() => selectedMonth = value),
              ),
              Expanded(
                child: _Body(
                  selectedDate: selectedDate,
                  selectedMonth: selectedMonth,
                  selectDate: (DateTime value) => setState(() {
                    selectedDate = value;
                  }),
                ),
              ),
              _Bottom(
                selectedDate: selectedDate,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.selectedMonth,
    required this.selectedDate,
    required this.selectDate,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;

  final ValueChanged<DateTime> selectDate;

  @override
  Widget build(BuildContext context) {
    var data = CalendarMonthData(
      year: selectedMonth.year,
      month: selectedMonth.month,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('M'),
            Text('T'),
            Text('W'),
            Text('T'),
            Text('F'),
            Text('S'),
            Text('S'),
          ],
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1,
              color: Colors.pink[200],
            ),
            for (var week in data.weeks)
              Row(
                children: week.map((d) {
                  return Expanded(
                    child: _RowItem(
                      hasRightBorder: false,
                      date: d.date,
                      isActiveMonth: d.isActiveMonth,
                      onTap: () => selectDate(d.date),
                      isSelected: selectedDate != null &&
                          selectedDate!.isSameDate(d.date),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ],
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.hasRightBorder,
    required this.isActiveMonth,
    required this.isSelected,
    required this.date,
    required this.onTap,
  });

  final bool hasRightBorder;
  final bool isActiveMonth;
  final VoidCallback onTap;
  final bool isSelected;

  final DateTime date;
  @override
  Widget build(BuildContext context) {
    final int number = date.day;
    final isToday = date.isToday;
    final bool isPassed = date.isBefore(DateTime.now());

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        height: 35,
        decoration: isSelected
            ? const BoxDecoration(color: Colors.pink, shape: BoxShape.circle)
            : isToday
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Colors.pink,
                    ),
                  )
                : null,
        child: Text(
          number.toString(),
          style: TextStyle(
              fontSize: 14,
              color: isPassed
                  ? isActiveMonth
                      ? Colors.grey
                      : Colors.transparent
                  : isActiveMonth
                      ? Colors.black
                      : Colors.grey[300]),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.selectedMonth,
    required this.selectedDate,
    required this.onChange,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;

  final ValueChanged<DateTime> onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
              'Selected date: ${selectedDate == null ? 'non' : "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}"}'),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Month: ${selectedMonth.month + 1}/${selectedMonth.year}',
                  textAlign: TextAlign.center,
                ),
              ),
              IconButton(
                onPressed: () {
                  onChange(selectedMonth.addMonth(-1));
                },
                icon: const Icon(Icons.arrow_left_sharp),
              ),
              IconButton(
                onPressed: () {
                  onChange(selectedMonth.addMonth(1));
                },
                icon: const Icon(Icons.arrow_right_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bottom extends StatelessWidget {
  const _Bottom({
    required this.selectedDate,
  });

  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            print(selectedDate);
          },
          child: const Text('save'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('cancel'),
        ),
      ],
    );
  }
}

class CalendarMonthData {
  final int year;
  final int month;

  int get daysInMonth => DateUtils.getDaysInMonth(year, month);
  int get firstDayOfWeekIndex => 0;

  int get weeksCount => ((daysInMonth + firstDayOffset) / 7).ceil();

  const CalendarMonthData({
    required this.year,
    required this.month,
  });

  int get firstDayOffset {
    final int weekdayFromMonday = DateTime(year, month).weekday - 1;

    return (weekdayFromMonday - ((firstDayOfWeekIndex - 1) % 7)) % 7 - 1;
  }

  List<List<CalendarDayData>> get weeks {
    final res = <List<CalendarDayData>>[];
    var firstDayMonth = DateTime(year, month, 1);
    var firstDayOfWeek = firstDayMonth.subtract(Duration(days: firstDayOffset));

    for (var w = 0; w < weeksCount; w++) {
      final week = List<CalendarDayData>.generate(
        7,
        (index) {
          final date = firstDayOfWeek.add(Duration(days: index));

          final isActiveMonth = date.year == year && date.month == month;

          return CalendarDayData(
            date: date,
            isActiveMonth: isActiveMonth,
            isActiveDate: date.isToday,
          );
        },
      );
      res.add(week);
      firstDayOfWeek = firstDayOfWeek.add(const Duration(days: 7));
    }
    return res;
  }
}

class CalendarDayData {
  final DateTime date;
  final bool isActiveMonth;
  final bool isActiveDate;

  const CalendarDayData({
    required this.date,
    required this.isActiveMonth,
    required this.isActiveDate,
  });
}*/

/*import 'package:flutter/material.dart';


void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

extension DateTimeExt on DateTime {
  DateTime get monthStart => DateTime(year, month, 1);
  DateTime get dayStart => DateTime(year, month, day);

  DateTime addMonth(int count) {
    return DateTime(year, month + count, 1);
  }

  bool isSameDate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isToday {
    return isSameDate(DateTime.now());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DateTime selectedMonth;
  DateTime? selectedDate;

  @override
  void initState() {
    // Set January 2025 as the default month
    selectedMonth = DateTime(2025, 1, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 450,
          width: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              _Header(
                selectedMonth: selectedMonth,
                selectedDate: selectedDate,
                onChange: (value) => setState(() => selectedMonth = value),
              ),
              // Calendar Body
              Expanded(
                child: _Body(
                  selectedDate: selectedDate,
                  selectedMonth: selectedMonth,
                  selectDate: (DateTime value) => setState(() {
                    selectedDate = value;
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Calendar Body
class _Body extends StatelessWidget {
  const _Body({
    required this.selectedMonth,
    required this.selectedDate,
    required this.selectDate,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> selectDate;

  @override
  Widget build(BuildContext context) {
    var data = CalendarMonthData(
      year: selectedMonth.year,
      month: selectedMonth.month,
    );

    return Column(
      children: [
        // Days of the Week
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('M'),
            Text('T'),
            Text('W'),
            Text('T'),
            Text('F'),
            Text('S'),
            Text('S'),
          ],
        ),
        const SizedBox(height: 10),
        // Calendar Rows
        Column(
          children: [
            for (var week in data.weeks)
              Row(
                children: week.map((d) {
                  return Expanded(
                    child: _RowItem(
                      date: d,
                      isActiveMonth: d.month == selectedMonth.month,
                      onTap: () => selectDate(d),
                      isSelected:
                          selectedDate != null && selectedDate!.isSameDate(d),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ],
    );
  }
}

// Calendar Row Item
class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.date,
    required this.isActiveMonth,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool isActiveMonth;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final int dayNumber = date.day;
    final isToday = date.isToday;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 35,
        decoration: isSelected
            ? const BoxDecoration(color: Colors.pink, shape: BoxShape.circle)
            : isToday
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Colors.pink,
                    ),
                  )
                : null,
        child: Text(
          dayNumber.toString(),
          style: TextStyle(
            fontSize: 14,
            color: isActiveMonth ? Colors.black : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}

// Calendar Header
class _Header extends StatelessWidget {
  const _Header({
    required this.selectedMonth,
    required this.selectedDate,
    required this.onChange,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChange;

  final List<String> monthNames = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Selected date: ${selectedDate == null ? 'None' : "${selectedDate!.day} ${monthNames[selectedDate!.month - 1]} ${selectedDate!.year}"}',
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => onChange(selectedMonth.addMonth(-1)),
                icon: const Icon(Icons.arrow_left_sharp),
              ),
              Text(
                '${monthNames[selectedMonth.month - 1]} ${selectedMonth.year}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => onChange(selectedMonth.addMonth(1)),
                icon: const Icon(Icons.arrow_right_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Calendar Data Logic
class CalendarMonthData {
  final int year;
  final int month;

  CalendarMonthData({required this.year, required this.month});

  int get daysInMonth => DateUtils.getDaysInMonth(year, month);

  int get firstDayOffset => DateTime(year, month, 1).weekday - 1;

  List<List<DateTime>> get weeks {
    // Start from the first day of the month
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Calculate the first day in the calendar grid
    DateTime firstDayInGrid =
        firstDayOfMonth.subtract(Duration(days: firstDayOffset));

    // Create a grid of 42 days (6 weeks x 7 days)
    List<DateTime> allDays = List.generate(
      42,
      (index) => firstDayInGrid.add(Duration(days: index)),
    );

    // Group the days into weeks
    return List.generate(6, (index) {
      return allDays.skip(index * 7).take(7).toList();
    });
  }
}
*/
/* ye wala acha hai final wala
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

extension DateTimeExt on DateTime {
  DateTime get monthStart => DateTime(year, month, 1);
  DateTime get dayStart => DateTime(year, month, day);

  DateTime addMonth(int count) {
    return DateTime(year, month + count, 1);
  }

  bool isSameDate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isToday {
    return isSameDate(DateTime.now());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DateTime selectedMonth;
  DateTime? selectedDate;

  @override
  void initState() {
    // Set January 2025 as the default month
    selectedMonth = DateTime(2025, 1, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 500, // Adjusted height for more space
          width: 300, // Adjusted width
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header Section
              _Header(
                selectedMonth: selectedMonth,
                selectedDate: selectedDate,
                onChange: (value) => setState(() => selectedMonth = value),
              ),
              // Calendar Body
              Expanded(
                child: _Body(
                  selectedDate: selectedDate,
                  selectedMonth: selectedMonth,
                  selectDate: (DateTime value) => setState(() {
                    selectedDate = value;
                  }),
                ),
              ),
              // "More Information" Tag
              GestureDetector(
                onTap: () {
                  // Action when "More Information" is clicked
                  print("More Information clicked");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('More Information coming soon!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'More Information',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10), // Space below the tag
            ],
          ),
        ),
      ),
    );
  }
}

// Calendar Body
class _Body extends StatelessWidget {
  const _Body({
    required this.selectedMonth,
    required this.selectedDate,
    required this.selectDate,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> selectDate;

  @override
  Widget build(BuildContext context) {
    var data = CalendarMonthData(
      year: selectedMonth.year,
      month: selectedMonth.month,
    );

    return Column(
      children: [
        // Days of the Week
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('M'),
            Text('T'),
            Text('W'),
            Text('T'),
            Text('F'),
            Text('S'),
            Text('S'),
          ],
        ),
        const SizedBox(height: 10),
        // Calendar Rows
        Column(
          children: [
            for (var week in data.weeks)
              Row(
                children: week.map((d) {
                  return Expanded(
                    child: _RowItem(
                      date: d,
                      isActiveMonth: d.month == selectedMonth.month,
                      onTap: () => selectDate(d),
                      isSelected:
                          selectedDate != null && selectedDate!.isSameDate(d),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ],
    );
  }
}

// Calendar Row Item
class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.date,
    required this.isActiveMonth,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool isActiveMonth;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final int dayNumber = date.day;
    final isToday = date.isToday;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 35,
        decoration: isSelected
            ? const BoxDecoration(color: Colors.pink, shape: BoxShape.circle)
            : isToday
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    border: Border.all(
                      color: Colors.pink,
                    ),
                  )
                : null,
        child: Text(
          dayNumber.toString(),
          style: TextStyle(
            fontSize: 14,
            color: isActiveMonth ? Colors.black : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}

// Calendar Header
class _Header extends StatelessWidget {
  const _Header({
    required this.selectedMonth,
    required this.selectedDate,
    required this.onChange,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChange;

  final List<String> monthNames = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Selected date: ${selectedDate == null ? 'None' : "${selectedDate!.day} ${monthNames[selectedDate!.month - 1]} ${selectedDate!.year}"}',
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => onChange(selectedMonth.addMonth(-1)),
                icon: const Icon(Icons.arrow_left_sharp),
              ),
              Text(
                '${monthNames[selectedMonth.month - 1]} ${selectedMonth.year}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => onChange(selectedMonth.addMonth(1)),
                icon: const Icon(Icons.arrow_right_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Calendar Data Logic
class CalendarMonthData {
  final int year;
  final int month;

  CalendarMonthData({required this.year, required this.month});

  int get daysInMonth => DateUtils.getDaysInMonth(year, month);

  int get firstDayOffset => DateTime(year, month, 1).weekday - 1;

  List<List<DateTime>> get weeks {
    // Start from the first day of the month
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Calculate the first day in the calendar grid
    DateTime firstDayInGrid =
        firstDayOfMonth.subtract(Duration(days: firstDayOffset));

    // Create a grid of 42 days (6 weeks x 7 days)
    List<DateTime> allDays = List.generate(
      42,
      (index) => firstDayInGrid.add(Duration(days: index)),
    );

    // Group the days into weeks
    return List.generate(6, (index) {
      return allDays.skip(index * 7).take(7).toList();
    });
  }
}
*/
/*/upr wale se updrade hai
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

extension DateTimeExt on DateTime {
  DateTime get monthStart => DateTime(year, month, 1);
  DateTime get dayStart => DateTime(year, month, day);

  DateTime addMonth(int count) {
    return DateTime(year, month + count, 1);
  }

  bool isSameDate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isToday {
    return isSameDate(DateTime.now());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DateTime selectedMonth;
  DateTime? selectedDate;

  @override
  void initState() {
    // Set January 2025 as the default month
    selectedMonth = DateTime(2025, 1, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 520,
          width: 320,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Name Plate
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 22, left: 19, right: 19),
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.blue[100],
                child: const Center(
                  child: Text(
                    "CALENDER name plate",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // Header Section
              _Header(
                selectedMonth: selectedMonth,
                selectedDate: selectedDate,
                onChange: (value) => setState(() => selectedMonth = value),
              ),
              // Calendar Body
              Expanded(
                child: _Body(
                  selectedDate: selectedDate,
                  selectedMonth: selectedMonth,
                  selectDate: (DateTime value) => setState(() {
                    selectedDate = value;
                  }),
                ),
              ),
              // "More Information" Button
              GestureDetector(
                onTap: () {
                  print("More Information clicked");
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "More Information",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Calendar Body
class _Body extends StatelessWidget {
  const _Body({
    required this.selectedMonth,
    required this.selectedDate,
    required this.selectDate,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> selectDate;

  @override
  Widget build(BuildContext context) {
    var data = CalendarMonthData(
      year: selectedMonth.year,
      month: selectedMonth.month,
    );

    return Column(
      children: [
        // Days of the Week
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('M'),
            Text('T'),
            Text('W'),
            Text('T'),
            Text('F'),
            Text('S'),
            Text('S'),
          ],
        ),
        const SizedBox(height: 5),
        // Calendar Rows
        Column(
          children: [
            for (var week in data.weeks)
              Row(
                children: week.map((d) {
                  return Expanded(
                    child: _RowItem(
                      date: d,
                      isActiveMonth: d.month == selectedMonth.month,
                      onTap: () => selectDate(d),
                      isSelected:
                          selectedDate != null && selectedDate!.isSameDate(d),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ],
    );
  }
}

// Calendar Row Item
class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.date,
    required this.isActiveMonth,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool isActiveMonth;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final int dayNumber = date.day;
    final isToday = date.isToday;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(2), // Minimized spacing
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.pink
              : isToday
                  ? Colors.blue[100]
                  : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActiveMonth ? Colors.black : Colors.grey[300]!,
          ),
        ),
        child: Text(
          dayNumber.toString(),
          style: TextStyle(
            fontSize: 14,
            color: isActiveMonth ? Colors.black : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}

// Calendar Header
class _Header extends StatelessWidget {
  const _Header({
    required this.selectedMonth,
    required this.selectedDate,
    required this.onChange,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChange;

  final List<String> monthNames = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Selected date: ${selectedDate == null ? 'None' : "${selectedDate!.day} ${monthNames[selectedDate!.month - 1]} ${selectedDate!.year}"}',
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => onChange(selectedMonth.addMonth(-1)),
                icon: const Icon(Icons.arrow_left_sharp),
              ),
              Text(
                '${monthNames[selectedMonth.month - 1]} ${selectedMonth.year}',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => onChange(selectedMonth.addMonth(1)),
                icon: const Icon(Icons.arrow_right_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Calendar Data Logic
class CalendarMonthData {
  final int year;
  final int month;

  CalendarMonthData({required this.year, required this.month});

  int get daysInMonth => DateUtils.getDaysInMonth(year, month);

  int get firstDayOffset => DateTime(year, month, 1).weekday - 1;

  List<List<DateTime>> get weeks {
    // Start from the first day of the month
    DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Calculate the first day in the calendar grid
    DateTime firstDayInGrid =
        firstDayOfMonth.subtract(Duration(days: firstDayOffset));

    // Create a grid of 42 days (6 weeks x 7 days)
    List<DateTime> allDays = List.generate(
      42,
      (index) => firstDayInGrid.add(Duration(days: index)),
    );

    // Group the days into weeks
    return List.generate(6, (index) {
      return allDays.skip(index * 7).take(7).toList();
    });
  }
}
*/
// Name Plate
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

// Extension for DateTime utility methods
extension DateTimeExt on DateTime {
  DateTime get monthStart => DateTime(year, month, 1);
  DateTime get dayStart => DateTime(year, month, day);

  DateTime addMonth(int count) {
    return DateTime(year, month + count, 1);
  }

  bool isSameDate(DateTime date) {
    return year == date.year && month == date.month && day == date.day;
  }

  bool get isToday {
    return isSameDate(DateTime.now());
  }
}

// Main MyApp Widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DateTime selectedMonth;
  DateTime? selectedDate;

  @override
  void initState() {
    // Initialize with January 2025 as the default month
    selectedMonth = DateTime(2025, 1, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 600, // Height of the main container
          width: 350, // Width of the main container
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Name Plate
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 22, left: 19, right: 19),
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.blue[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    //Icon(Icons.arrow_left, size: 20, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      "CALENDAR",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Header Section
              _Header(
                selectedMonth: selectedMonth,
                selectedDate: selectedDate,
                onChange: (value) => setState(() => selectedMonth = value),
              ),
              // Calendar Body
              Expanded(
                child: _Body(
                  selectedDate: selectedDate,
                  selectedMonth: selectedMonth,
                  selectDate: (DateTime value) => setState(() {
                    selectedDate = value;
                  }),
                ),
              ),
              // Blue Rectangle Box
              Container(
                margin: const EdgeInsets.only(bottom: 34, left: 19, right: 19),
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.blue[200],
                child: const Center(
                  child: Text(
                    "Additional Information Box",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // "More Information" Button
              GestureDetector(
                onTap: () {
                  print("More Information clicked");
                },
                child: Container(
                  margin:
                      const EdgeInsets.only(bottom: 30, left: 19, right: 19),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "More Information",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Header Widget
class _Header extends StatelessWidget {
  const _Header({
    required this.selectedMonth,
    required this.selectedDate,
    required this.onChange,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onChange;

  final List<String> monthNames = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Text(
            'Selected date: ${selectedDate == null ? 'None' : "${selectedDate!.day} ${monthNames[selectedDate!.month - 1]} ${selectedDate!.year}"}',
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => onChange(selectedMonth.addMonth(-1)),
                icon: const Icon(Icons.arrow_left_sharp),
              ),
              Text(
                '${monthNames[selectedMonth.month - 1]} ${selectedMonth.year}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => onChange(selectedMonth.addMonth(1)),
                icon: const Icon(Icons.arrow_right_sharp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Calendar Body
class _Body extends StatelessWidget {
  const _Body({
    required this.selectedMonth,
    required this.selectedDate,
    required this.selectDate,
  });

  final DateTime selectedMonth;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> selectDate;

  @override
  Widget build(BuildContext context) {
    var data = CalendarMonthData(
      year: selectedMonth.year,
      month: selectedMonth.month,
    );

    return Column(
      children: [
        // Days of the Week
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('M'),
            Text('T'),
            Text('W'),
            Text('T'),
            Text('F'),
            Text('S'),
            Text('S'),
          ],
        ),
        const SizedBox(height: 5),
        // Calendar Rows
        Column(
          children: [
            for (var week in data.weeks)
              Row(
                children: week.map((d) {
                  return Expanded(
                    child: _RowItem(
                      date: d,
                      isActiveMonth: d.month == selectedMonth.month,
                      onTap: () => selectDate(d),
                      isSelected:
                          selectedDate != null && selectedDate!.isSameDate(d),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ],
    );
  }
}

// Calendar Row Item
class _RowItem extends StatelessWidget {
  const _RowItem({
    required this.date,
    required this.isActiveMonth,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool isActiveMonth;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final int dayNumber = date.day;
    final isToday = date.isToday;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(2),
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.pink
              : isToday
                  ? Colors.blue[100]
                  : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(
            color: isActiveMonth ? Colors.black : Colors.grey[300]!,
          ),
        ),
        child: Text(
          dayNumber.toString(),
          style: TextStyle(
            fontSize: 14,
            color: isActiveMonth ? Colors.black : Colors.grey[300],
          ),
        ),
      ),
    );
  }
}

// Calendar Data Logic
class CalendarMonthData {
  final int year;
  final int month;

  CalendarMonthData({required this.year, required this.month});

  int get daysInMonth => DateUtils.getDaysInMonth(year, month);

  int get firstDayOffset => DateTime(year, month, 1).weekday - 1;

  List<List<DateTime>> get weeks {
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime firstDayInGrid =
        firstDayOfMonth.subtract(Duration(days: firstDayOffset));
    List<DateTime> allDays = List.generate(
      42,
      (index) => firstDayInGrid.add(Duration(days: index)),
    );

    return List.generate(6, (index) {
      return allDays.skip(index * 7).take(7).toList();
    });
  }
}
