import 'package:flutter/material.dart';

// Mô hình ghế
class Seat {
  final String id;
  final Rect position; // Tọa độ và kích thước ghế (x, y, width, height)
  bool isOccupied;

  Seat({required this.id, required this.position, this.isOccupied = false});
}

// Mô hình hành khách
class Passenger {
  final String seatId;
  final String name;

  Passenger({required this.seatId, required this.name});
}

class TestMap extends StatefulWidget {
  const TestMap({super.key});

  @override
  _TestMapState createState() => _TestMapState();
}

class _TestMapState extends State<TestMap> {
  List<Seat> seats = [];
  List<Passenger> passengers = [
    Passenger(seatId: "1A", name: "John Doe"),
    Passenger(seatId: "2C", name: "Jane Smith"),
  ];
  String? selectedSeatId;

  @override
  void initState() {
    super.initState();
    _loadSeatData(); // Tải dữ liệu ghế
  }

  void _loadSeatData() {
    // Bố cục ghế cho một loại máy bay (ví dụ: A321)
    seats = [
      Seat(id: "1A", position: Rect.fromLTWH(50, 100, 40, 40)),
      Seat(id: "1C", position: Rect.fromLTWH(100, 100, 40, 40)),
      Seat(id: "1D", position: Rect.fromLTWH(150, 100, 40, 40)),
      Seat(id: "1G", position: Rect.fromLTWH(200, 100, 40, 40)),
      Seat(id: "2A", position: Rect.fromLTWH(50, 150, 40, 40)),
      Seat(id: "2C", position: Rect.fromLTWH(100, 150, 40, 40)),
      Seat(id: "2D", position: Rect.fromLTWH(150, 150, 40, 40)),
      Seat(id: "2G", position: Rect.fromLTWH(200, 150, 40, 40)),
    ];

    // Đánh dấu ghế có hành khách
    for (var passenger in passengers) {
      final seat = seats.firstWhere(
        (s) => s.id == passenger.seatId,
        orElse: () => Seat(id: "", position: Rect.zero),
      );
      if (seat.id.isNotEmpty) {
        seat.isOccupied = true;
      }
    }
  }

  void _handleSeatTap(String seatId) {
    setState(() {
      selectedSeatId = seatId;
    });

    // Tìm hành khách tương ứng với ghế được chọn
    final passenger = passengers.firstWhere(
      (p) => p.seatId == seatId,
      orElse: () => Passenger(seatId: seatId, name: "No passenger"),
    );

    // Đẩy màn hình chi tiết hành khách
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PassengerDetailScreen(passenger: passenger),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VN1805/19 JUN DIN-HAN"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTapUp: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localPosition = box.globalToLocal(details.globalPosition);
                final tappedSeat = seats.firstWhere(
                  (seat) => seat.position.contains(localPosition),
                  orElse: () => Seat(id: "", position: Rect.zero),
                );
                if (tappedSeat.id.isNotEmpty) {
                  _handleSeatTap(tappedSeat.id);
                }
              },
              child: CustomPaint(
                painter: SeatMapPainter(seats, selectedSeatId, passengers),
                size: Size(double.infinity, double.infinity),
                child: Container(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Có thể thêm logic để làm mới hoặc chuyển đổi chế độ xem
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Seat Map View")),
                    );
                  },
                  child: const Text("Seat Map"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Chuyển sang màn hình danh sách hành khách
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PassengerListScreen(passengers: passengers),
                      ),
                    );
                  },
                  child: const Text("Passenger List"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter để vẽ sơ đồ ghế
class SeatMapPainter extends CustomPainter {
  final List<Seat> seats;
  final String? selectedSeatId;
  final List<Passenger> passengers;

  SeatMapPainter(this.seats, this.selectedSeatId, this.passengers);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final textStyle = TextStyle(color: Colors.black, fontSize: 10);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Vẽ hình nền máy bay
    final planePath = Path()
      ..moveTo(50, 50)
      ..quadraticBezierTo(size.width / 2, 0, size.width - 50, 50)
      ..lineTo(size.width - 50, size.height - 50)
      ..quadraticBezierTo(size.width / 2, size.height, 50, size.height - 50)
      ..close();
    canvas.drawPath(planePath, Paint()..color = Colors.grey.withOpacity(0.3));

    // Vẽ đường trung tâm (lối đi)
    canvas.drawLine(
      Offset(size.width / 2, 50),
      Offset(size.width / 2, size.height - 50),
      Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..strokeWidth = 2,
    );

    // Vẽ các ghế
    for (var seat in seats) {
      // Màu sắc ghế
      paint.color = seat.isOccupied
          ? Colors.blue.withOpacity(0.5) // Ghế có hành khách
          : Colors.grey.withOpacity(0.2); // Ghế trống
      if (selectedSeatId == seat.id) {
        paint.color = Colors.blue; // Ghế được chọn
      }
      canvas.drawRect(seat.position, paint);

      // Vẽ viền ghế
      canvas.drawRect(
        seat.position,
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      // Vẽ văn bản ID ghế
      textPainter.text = TextSpan(text: seat.id, style: textStyle);
      textPainter.layout();
      final offset = Offset(
        seat.position.left + (seat.position.width - textPainter.width) / 2,
        seat.position.top + (seat.position.height - textPainter.height) / 2,
      );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Màn hình chi tiết hành khách
class PassengerDetailScreen extends StatelessWidget {
  final Passenger passenger;

  const PassengerDetailScreen({super.key, required this.passenger});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Passenger Detail")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Seat: ${passenger.seatId}", style: const TextStyle(fontSize: 20)),
            Text("Name: ${passenger.name}", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}

// Màn hình danh sách hành khách (bổ sung)
class PassengerListScreen extends StatelessWidget {
  final List<Passenger> passengers;

  const PassengerListScreen({super.key, required this.passengers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Passenger List")),
      body: ListView.builder(
        itemCount: passengers.length,
        itemBuilder: (context, index) {
          final passenger = passengers[index];
          return ListTile(
            title: Text(passenger.name),
            subtitle: Text("Seat: ${passenger.seatId}"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PassengerDetailScreen(passenger: passenger),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
