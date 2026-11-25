import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const OscarInvictusApp());
}

class OscarInvictusApp extends StatelessWidget {
  const OscarInvictusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OSCAR INVICTUS',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0D12),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const StressTestPage(),
    );
  }
}

class StressTestPage extends StatefulWidget {
  const StressTestPage({super.key});

  @override
  State<StressTestPage> createState() => _StressTestPageState();
}

class _StressTestPageState extends State<StressTestPage> {
  Timer? _timer;
  bool _running = false;
  int _ticks = 0;
  double _progress = 0;

  void _start() {
    if (_running) return;
    setState(() => _running = true);

    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!mounted) return;
      // Bounded local computation for testing this app/device only.
      var value = 0.0;
      for (var i = 1; i <= 25000; i++) {
        value += sqrt(i) * sin(i);
      }
      if (value.isNaN) return;

      setState(() {
        _ticks++;
        _progress = (_progress + 0.008) % 1.0;
      });
    });
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
    if (mounted) setState(() => _running = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OSCAR INVICTUS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(Icons.bolt_rounded, size: 82, color: Colors.deepPurpleAccent),
              const SizedBox(height: 18),
              const Text(
                'DEVICE STRESS TEST',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text(
                'Pengujian beban komputasi lokal pada aplikasi ini. '
                'Tidak mengganggu aplikasi atau perangkat lain.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade400, height: 1.5),
              ),
              const SizedBox(height: 28),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      LinearProgressIndicator(value: _running ? _progress : 0),
                      const SizedBox(height: 18),
                      Text(
                        _running ? 'TEST BERJALAN' : 'SIAP DIUJI',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Cycle: $_ticks'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: _running ? _stop : _start,
                  icon: Icon(_running ? Icons.stop_rounded : Icons.play_arrow_rounded),
                  label: Text(_running ? 'STOP TEST' : 'START TEST'),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Gunakan hanya untuk pengujian perangkat sendiri.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
