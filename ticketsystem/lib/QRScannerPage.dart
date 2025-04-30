import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:ticketsystem/features/auth/presentation/provider/AuthProvider.dart';
import 'package:ticketsystem/features/auth/presentation/screens/LoginScreen.dart';
import 'package:ticketsystem/models/Ticket.dart';
import 'package:ticketsystem/models/UserTicketMap.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage>
    with SingleTickerProviderStateMixin {
  String scanResult = 'No QR code scanned yet';
  bool isScanning = false;
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  List<UserTicketMap> tickets = [];
  int ticketCount = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final Dio dio = Dio();
  final token =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7ImlkIjoiNjdmNjM0YTI2MjNkOGE5OGYyNWQzY2MwIn0sImlhdCI6MTc0NDcwMDgwNSwiZXhwIjoxNzQ0Nzg3MjA1fQ.V-nLrJSufPMDydJGMW7vGRZaZqXIIeqaD1gPHFI5F4E";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  Future<void> processQrCode(String userId) async {
    try {
      final response = await dio.get(
        '${dotenv.env["BASE_URL"]}userTicketMap/user/$userId',
        options: Options(
          headers: {
            'Authorization': "Bearer $token",
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data;

      if (data is List) {
        final ticketList =
            data.map((json) => UserTicketMap.fromJson(json)).toList();

        setState(() {
          tickets = List<UserTicketMap>.from(ticketList);
          ticketCount = tickets.length;
          scanResult = 'Found $ticketCount tickets.';
        });
      } else {
        setState(() {
          scanResult = 'Unexpected response format';
        });
      }
    } catch (e) {
      setState(() {
        scanResult = 'API call failed: $e';
      });
      print(scanResult);
    }
    setState(() {
      isScanning = false;
    });
    controller.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return Scaffold(
        backgroundColor: const Color(0xFF1E1E2C),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'QR Scanner',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            if (isScanning)
              Expanded(
                flex: 5,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MobileScanner(
                      controller: controller,
                      onDetect: (capture) async {
                        final List<Barcode> barcodes = capture.barcodes;
                        if (barcodes.isNotEmpty) {
                          final Barcode barcode = barcodes.first;
                          final userId = barcode.rawValue!;
                          await processQrCode(userId);
                        }
                      },
                    ),
                    CustomPaint(
                      painter: ScannerOverlay(),
                      child: Container(),
                    ),
                    // Animated scanner line
                    AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final scanAreaSize =
                            MediaQuery.of(context).size.width * 0.8;
                        final left =
                            (MediaQuery.of(context).size.width - scanAreaSize) /
                                2;
                        final top = (MediaQuery.of(context).size.height * 0.5 -
                                scanAreaSize) /
                            2;

                        return Positioned(
                          left: left,
                          top: top + (_animation.value * scanAreaSize),
                          child: Container(
                            width: scanAreaSize,
                            height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.withOpacity(0),
                                  Colors.blue.withOpacity(0.8),
                                  Colors.blue.withOpacity(0),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      bottom: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  icon: const Icon(Icons.flip_camera_ios,
                                      color: Colors.white),
                                  onPressed: () => controller.switchCamera(),
                                  iconSize: 28,
                                  splashRadius: 24,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ValueListenableBuilder(
                                valueListenable: controller,
                                builder: (context, state, child) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                      icon: Icon(
                                        state == TorchState.on
                                            ? Icons.flash_off
                                            : Icons.flash_on,
                                        color: Colors.white,
                                      ),
                                      onPressed: () => controller.toggleTorch(),
                                      iconSize: 28,
                                      splashRadius: 24,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 100,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Scan QR Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Expanded(
                flex: 5,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2C3E50), Color(0xFF1E1E2C)],
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.white.withOpacity(0.9),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.qr_code_scanner,
                                  size: 64,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                scanResult == 'No QR code scanned yet'
                                    ? 'Ready to Scan'
                                    : 'Scan Complete',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                              const SizedBox(height: 16),
                              if (ticketCount > 0) ...[
                                Text(
                                  'Ticket Count: $ticketCount',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C3E50),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: tickets.isEmpty
                                      ? const Center(
                                          child: Text('No tickets found'),
                                        )
                                      : ListView.builder(
                                          itemCount: tickets.length,
                                          padding: const EdgeInsets.all(8),
                                          itemBuilder: (context, index) {
                                            final ticket = tickets[index];
                                            return Card(
                                              elevation: 2,
                                              margin: const EdgeInsets.only(
                                                  bottom: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ListTile(
                                                leading: const CircleAvatar(
                                                  backgroundColor: Colors.blue,
                                                  child: Icon(
                                                      Icons.confirmation_number,
                                                      color: Colors.white),
                                                ),
                                                title: Text(
                                                  ticket.eventName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                trailing: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Text(
                                                    '${ticket.ticketCount}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ] else ...[
                                Text(
                                  scanResult,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                              if (scanResult != 'No QR code scanned yet') ...[
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      scanResult = 'No QR code scanned yet';
                                      tickets = [];
                                      ticketCount = 0;
                                    });
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Clear Result'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.black87,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isScanning = !isScanning;
                          if (isScanning) {
                            controller.start();
                          } else {
                            controller.stop();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isScanning ? Colors.red : Colors.blue,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(isScanning ? Icons.stop : Icons.qr_code_scanner,
                              size: 24),
                          const SizedBox(width: 12),
                          Text(
                            isScanning ? 'Stop Scanning' : 'Start Scanning',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await provider.logout();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false, // Removes all previous routes
                          );
                        },
                        child: Text("Logout"))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }
}

class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double scanAreaSize = width * 0.8;
    final double left = (width - scanAreaSize) / 2;
    final double top = (height - scanAreaSize) / 2;
    final double right = left + scanAreaSize;
    final double bottom = top + scanAreaSize;

    // Semi-transparent background
    final Paint backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.7);

    // Scanner cutout
    final Path backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, width, height))
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTRB(left, top, right, bottom), const Radius.circular(12)))
      ..fillType = PathFillType.evenOdd;

    // Draw the semi-transparent overlay excluding the scanner area
    canvas.drawPath(backgroundPath, backgroundPaint);

    // Scanner border
    final Paint borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw scanner border with rounded corners
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTRB(left, top, right, bottom), const Radius.circular(12)),
        borderPaint);

    // Draw corner marks
    final double cornerSize = 30;
    final Paint cornerPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // Top left corner
    canvas.drawLine(
        Offset(left, top + cornerSize), Offset(left, top + 5), cornerPaint);
    canvas.drawLine(
        Offset(left + 5, top), Offset(left + cornerSize, top), cornerPaint);

    // Top right corner
    canvas.drawLine(
        Offset(right - cornerSize, top), Offset(right - 5, top), cornerPaint);
    canvas.drawLine(
        Offset(right, top + 5), Offset(right, top + cornerSize), cornerPaint);

    // Bottom left corner
    canvas.drawLine(Offset(left, bottom - cornerSize), Offset(left, bottom - 5),
        cornerPaint);
    canvas.drawLine(Offset(left + 5, bottom), Offset(left + cornerSize, bottom),
        cornerPaint);

    // Bottom right corner
    canvas.drawLine(Offset(right - cornerSize, bottom),
        Offset(right - 5, bottom), cornerPaint);
    canvas.drawLine(Offset(right, bottom - cornerSize),
        Offset(right, bottom - 5), cornerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
