import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobile_repairing_application__prototype/services/session_service.dart';

class EarningsScreen extends StatefulWidget {
  final SessionService sessionService;

  const EarningsScreen({
    Key? key,
    required this.sessionService,
  }) : super(key: key);

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periodOptions = [
    'This Week',
    'This Month',
    'Last Month',
    'Last 3 Months',
    'This Year'
  ];

  // Sample earnings data
  final List<Map<String, dynamic>> _earningsData = [
    {
      'id': 1,
      'customerName': 'Ali Hamza',
      'deviceType': 'iPhone 13',
      'service': 'Screen replacement',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'amount': 120.00,
    },
    {
      'id': 2,
      'customerName': 'Ahmer',
      'deviceType': 'Samsung Galaxy S21',
      'service': 'Battery replacement',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'amount': 80.00,
    },
    {
      'id': 3,
      'customerName': 'SamiUllah',
      'deviceType': 'Google Pixel 6',
      'service': 'Software issues',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'amount': 60.00,
    },
    {
      'id': 4,
      'customerName': 'Sarah Williams',
      'deviceType': 'OnePlus 9',
      'service': 'Charging port repair',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'amount': 90.00,
    },
    {
      'id': 5,
      'customerName': 'David Brown',
      'deviceType': 'Xiaomi Mi 11',
      'service': 'Camera repair',
      'date': DateTime.now().subtract(const Duration(days: 30)),
      'amount': 110.00,
    },
    {
      'id': 6,
      'customerName': 'Emily Davis',
      'deviceType': 'iPhone 12',
      'service': 'Speaker replacement',
      'date': DateTime.now().subtract(const Duration(days: 45)),
      'amount': 75.00,
    },
    {
      'id': 7,
      'customerName': 'Robert Wilson',
      'deviceType': 'Samsung Galaxy Note 20',
      'service': 'Water damage repair',
      'date': DateTime.now().subtract(const Duration(days: 60)),
      'amount': 150.00,
    },
    {
      'id': 8,
      'customerName': 'Lisa Taylor',
      'deviceType': 'iPad Pro',
      'service': 'Screen replacement',
      'date': DateTime.now().subtract(const Duration(days: 75)),
      'amount': 200.00,
    },
  ];

  List<Map<String, dynamic>> get filteredEarnings {
    final now = DateTime.now();

    switch (_selectedPeriod) {
      case 'This Week':
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return _earningsData
            .where((earning) =>
                earning['date'].isAfter(startOfWeek) ||
                earning['date'].isAtSameMomentAs(startOfWeek))
            .toList();

      case 'This Month':
        final startOfMonth = DateTime(now.year, now.month, 1);
        return _earningsData
            .where((earning) =>
                earning['date'].isAfter(startOfMonth) ||
                earning['date'].isAtSameMomentAs(startOfMonth))
            .toList();

      case 'Last Month':
        final startOfLastMonth = DateTime(now.year, now.month - 1, 1);
        final endOfLastMonth = DateTime(now.year, now.month, 0);
        return _earningsData
            .where((earning) =>
                (earning['date'].isAfter(startOfLastMonth) ||
                    earning['date'].isAtSameMomentAs(startOfLastMonth)) &&
                (earning['date'].isBefore(endOfLastMonth) ||
                    earning['date'].isAtSameMomentAs(endOfLastMonth)))
            .toList();

      case 'Last 3 Months':
        final threeMonthsAgo = DateTime(now.year, now.month - 3, now.day);
        return _earningsData
            .where((earning) =>
                earning['date'].isAfter(threeMonthsAgo) ||
                earning['date'].isAtSameMomentAs(threeMonthsAgo))
            .toList();

      case 'This Year':
        final startOfYear = DateTime(now.year, 1, 1);
        return _earningsData
            .where((earning) =>
                earning['date'].isAfter(startOfYear) ||
                earning['date'].isAtSameMomentAs(startOfYear))
            .toList();

      default:
        return _earningsData;
    }
  }

  double get totalEarnings {
    return filteredEarnings.fold<double>(
        0, (sum, earning) => sum + (earning['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Earnings',
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
          _buildPeriodSelector(),
          _buildEarningsSummary(),
          Expanded(
            child: filteredEarnings.isEmpty
                ? _buildEmptyState()
                : _buildEarningsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(
            'Period:',
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
                  value: _selectedPeriod,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedPeriod = newValue;
                      });
                    }
                  },
                  items: _periodOptions
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

  Widget _buildEarningsSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total Earnings',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalEarnings.toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedPeriod,
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem('Services', filteredEarnings.length.toString()),
              _buildSummaryItem('Avg. Service',
                  '\$${(totalEarnings / (filteredEarnings.isEmpty ? 1 : filteredEarnings.length)).toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredEarnings.length,
      itemBuilder: (context, index) {
        final earning = filteredEarnings[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.build, color: Colors.blue),
            ),
            title: Text(
              earning['service'],
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${earning['customerName']} • ${earning['deviceType']}',
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(earning['date']),
                  style: GoogleFonts.poppins(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            trailing: Text(
              '\$${earning['amount'].toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.green[700],
              ),
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
            Icons.account_balance_wallet,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No earnings found',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your earnings will appear here',
            style: GoogleFonts.poppins(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
