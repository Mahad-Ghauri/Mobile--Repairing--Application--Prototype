import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_repairing_application__prototype/services/session_service.dart';

class RepairHistoryScreen extends StatefulWidget {
  final SessionService sessionService;

  const RepairHistoryScreen({
    Key? key,
    required this.sessionService,
  }) : super(key: key);

  @override
  State<RepairHistoryScreen> createState() => _RepairHistoryScreenState();
}

class _RepairHistoryScreenState extends State<RepairHistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'This Week',
    'This Month',
    'Last Month'
  ];

  // Sample repair history data
  final List<Map<String, dynamic>> _repairHistory = [
    {
      'id': 1,
      'customerName': 'Ali Hamza',
      'deviceType': 'iPhone 13',
      'issue': 'Screen replacement',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'status': 'Completed',
      'amount': 120.00,
    },
    {
      'id': 2,
      'customerName': 'Ahmer',
      'deviceType': 'Samsung Galaxy S21',
      'issue': 'Battery replacement',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'status': 'Completed',
      'amount': 80.00,
    },
    {
      'id': 3,
      'customerName': 'SamiUllah',
      'deviceType': 'Google Pixel 6',
      'issue': 'Software issues',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'status': 'Completed',
      'amount': 60.00,
    },
    {
      'id': 4,
      'customerName': 'Fatima',
      'deviceType': 'OnePlus 9',
      'issue': 'Charging port repair',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'status': 'Completed',
      'amount': 90.00,
    },
    {
      'id': 5,
      'customerName': 'Talha Khan',
      'deviceType': 'Xiaomi Mi 11',
      'issue': 'Camera repair',
      'date': DateTime.now().subtract(const Duration(days: 30)),
      'status': 'Completed',
      'amount': 110.00,
    },
  ];

  List<Map<String, dynamic>> get filteredRepairs {
    switch (_selectedFilter) {
      case 'This Week':
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return _repairHistory
            .where((repair) =>
                repair['date'].isAfter(startOfWeek) ||
                repair['date'].isAtSameMomentAs(startOfWeek))
            .toList();
      case 'This Month':
        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month, 1);
        return _repairHistory
            .where((repair) =>
                repair['date'].isAfter(startOfMonth) ||
                repair['date'].isAtSameMomentAs(startOfMonth))
            .toList();
      case 'Last Month':
        final now = DateTime.now();
        final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
        final endOfLastMonth = DateTime(now.year, now.month, 0);
        return _repairHistory
            .where((repair) =>
                (repair['date'].isAfter(startOfLastMonth) ||
                    repair['date'].isAtSameMomentAs(startOfLastMonth)) &&
                (repair['date'].isBefore(endOfLastMonth) ||
                    repair['date'].isAtSameMomentAs(endOfLastMonth)))
            .toList();
      default:
        return _repairHistory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Repair History',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          _buildStatistics(),
          Expanded(
            child: filteredRepairs.isEmpty
                ? _buildEmptyState()
                : _buildRepairsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            'Filter by:',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFilter,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedFilter = newValue;
                      });
                    }
                  },
                  items: _filterOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics() {
    final totalRepairs = filteredRepairs.length;
    final totalEarnings = filteredRepairs.fold<double>(
        0, (sum, repair) => sum + (repair['amount'] as double));

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total Repairs', totalRepairs.toString(), Icons.build),
          _buildStatItem('Total Earnings',
              '\$${totalEarnings.toStringAsFixed(2)}', Icons.attach_money),
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
            fontSize: 20,
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

  Widget _buildRepairsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredRepairs.length,
      itemBuilder: (context, index) {
        final repair = filteredRepairs[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('MMM dd, yyyy').format(repair['date']),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        repair['status'],
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          repair['customerName'],
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          repair['deviceType'],
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Issue: ${repair['issue']}',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Amount: \$${repair['amount'].toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // View details action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Viewing details for repair #${repair['id']}'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No repair history found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your repair history will appear here',
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
