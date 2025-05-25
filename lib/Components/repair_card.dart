import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_repairing_application__prototype/Components/status_badge.dart';

class RepairCard extends StatelessWidget {
  final String repairId;
  final String deviceName;
  final String issue;
  final String technician;
  final String status;
  final double estimatedCost;
  final VoidCallback onViewDetails;

  const RepairCard({
    Key? key,
    required this.repairId,
    required this.deviceName,
    required this.issue,
    required this.technician,
    required this.status,
    required this.estimatedCost,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Repair #$repairId',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _getStatusBadge(status),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.phone_android, 'Device: $deviceName'),
              const SizedBox(height: 4),
              _buildInfoRow(Icons.build, 'Issue: $issue'),
              const SizedBox(height: 4),
              _buildInfoRow(Icons.person, 'Technician: $technician'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estimated Cost: \$${estimatedCost.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onViewDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  StatusBadge _getStatusBadge(String status) {
    switch (status.toLowerCase()) {
      case 'in progress':
        return StatusBadge.inProgress();
      case 'completed':
        return StatusBadge.completed();
      case 'pending':
        return StatusBadge.pending();
      case 'cancelled':
        return StatusBadge.cancelled();
      default:
        return StatusBadge(
          text: status,
          color: Colors.blue,
        );
    }
  }
}