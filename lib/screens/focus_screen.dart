import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/tree_widget.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Large START/STOP button at top
              Consumer<TimerProvider>(
                builder: (context, timerProvider, child) {
                  return Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 60),
                    child: ElevatedButton(
                      onPressed: () {
                        if (timerProvider.isRunning) {
                          timerProvider.stopTimer();
                        } else {
                          timerProvider.startTimer();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2A2A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            timerProvider.isRunning ? Icons.close : Icons.play_arrow,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            timerProvider.isRunning ? 'STOP' : 'START',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 30),
              
              // Main timer card - larger and more prominent
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Enhanced Tree visualization - much larger
                        SizedBox(
                          height: 300,
                          width: double.infinity,
                          child: const TreeWidget(),
                        ),
                        
                        const SizedBox(height: 50),
                        
                        // Timer display - larger and more prominent
                        Consumer<TimerProvider>(
                          builder: (context, timerProvider, child) {
                            return Text(
                              timerProvider.formattedTime,
                              style: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                fontFamily: 'Roboto',
                                letterSpacing: 2.0,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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