// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_repairing_application__prototype/services/session_service.dart';
import 'package:mobile_repairing_application__prototype/Views/Authentication/login_screen.dart';
import 'package:mobile_repairing_application__prototype/Views/Technician/schedule_screen.dart';
import 'package:mobile_repairing_application__prototype/Views/Technician/repair_history_screen.dart';
import 'package:mobile_repairing_application__prototype/Views/Technician/earnings_screen.dart';
import 'package:mobile_repairing_application__prototype/Views/Technician/profile_screen.dart';

class TechnicianDashboard extends StatelessWidget {
  final SessionService sessionService;

  const TechnicianDashboard({
    Key? key,
    required this.sessionService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = sessionService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome, ${user?.name ?? "Technician"}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await sessionService.clearSession();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Section
            _buildStatsSection(),
            const SizedBox(height: 32),
            // Today's Appointments
            Text(
              'Today\'s Appointments',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildAppointmentsList(),
            const SizedBox(height: 32),
            // Quick Actions
            Text(
              'Quick Actions',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildActionCard(
                  context,
                  'View Schedule',
                  Icons.calendar_month,
                  Colors.blue,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleScreen(
                          sessionService: sessionService,
                        ),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  'Repair History',
                  Icons.history,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RepairHistoryScreen(
                          sessionService: sessionService,
                        ),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  'Earnings',
                  Icons.attach_money,
                  Colors.orange,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EarningsScreen(
                          sessionService: sessionService,
                        ),
                      ),
                    );
                  },
                ),
                _buildActionCard(
                  context,
                  'Profile',
                  Icons.person,
                  Colors.purple,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          sessionService: sessionService,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Today', '5', Icons.calendar_today),
              _buildStatItem('Pending', '3', Icons.pending_actions),
              _buildStatItem('Completed', '12', Icons.check_circle),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentsList() {
    // TODO: Replace with actual appointments data
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: const Icon(Icons.person, color: Colors.blue),
            ),
            title: Text(
              'Appointment #${index + 1}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer: Ali Hamza',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  'Time: ${9 + index}:00 AM',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                // TODO: Handle appointment action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.7),
                color,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
