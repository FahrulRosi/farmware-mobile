import 'package:flutter/material.dart';

class FirmwareHistoryPage extends StatefulWidget {
  const FirmwareHistoryPage({super.key});

  @override
  State<FirmwareHistoryPage> createState() => _FirmwareHistoryPageState();
}

class _FirmwareHistoryPageState extends State<FirmwareHistoryPage> {
  // Sample data for firmware update history
  final List<FirmwareUpdate> _updateHistory = [
    FirmwareUpdate(
      deviceName: 'Smart Controller #3',
      fromVersion: 'v1.7.5',
      toVersion: 'v1.8.2',
      date: DateTime(2025, 4, 20),
      status: UpdateStatus.success,
      details: 'Peningkatan stabilitas dan kinerja perangkat',
    ),
    FirmwareUpdate(
      deviceName: 'Smart Controller #3',
      fromVersion: 'v1.7.5',
      toVersion: 'v1.8.0',
      date: DateTime(2025, 3, 15),
      status: UpdateStatus.rollback,
      details: 'Terdeteksi anomali kinerja oleh sistem ML',
      mlDetails: MLRollbackDetails(
        confidenceScore: 0.89,
        anomalyType: 'Memory usage spike',
        detectedAt: DateTime(2025, 3, 15, 14, 35),
      ),
    ),
    FirmwareUpdate(
      deviceName: 'IoT Sensor #1',
      fromVersion: 'v1.2.1',
      toVersion: 'v1.2.5',
      date: DateTime(2025, 3, 10),
      status: UpdateStatus.success,
      details: 'Perbaikan bug dan optimasi penggunaan baterai',
    ),
    FirmwareUpdate(
      deviceName: 'Gateway Node #2',
      fromVersion: 'v1.9.3',
      toVersion: 'v2.0.1',
      date: DateTime(2025, 2, 25),
      status: UpdateStatus.success,
      details: 'Fitur baru: dukungan untuk protokol MQTT 5.0',
    ),
    FirmwareUpdate(
      deviceName: 'Smart Controller #3',
      fromVersion: 'v1.7.0',
      toVersion: 'v1.7.5',
      date: DateTime(2025, 2, 1),
      status: UpdateStatus.success,
      details: 'Peningkatan keamanan dan enkripsi data',
    ),
  ];

  String _selectedFilter = 'Semua';
  final List<String> _filterOptions = ['Semua', 'Berhasil', 'Rollback'];

  List<FirmwareUpdate> get filteredUpdates {
    if (_selectedFilter == 'Semua') return _updateHistory;
    if (_selectedFilter == 'Berhasil') {
      return _updateHistory.where((u) => u.status == UpdateStatus.success).toList();
    }
    if (_selectedFilter == 'Rollback') {
      return _updateHistory.where((u) => u.status == UpdateStatus.rollback).toList();
    }
    return _updateHistory;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _selectedFilter = 'Semua'),
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: _selectedFilter == 'Semua' 
                              ? const Color(0xFF00A86B) // Dark green when selected
                              : Colors.white,
                          borderRadius: BorderRadius.circular(50), // More rounded corners
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            if (_selectedFilter == 'Semua')
                              BoxShadow(
                                color: const Color(0xFF00A86B).withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Semua',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _selectedFilter == 'Semua' 
                                  ? Colors.white 
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _selectedFilter = 'Berhasil'),
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: _selectedFilter == 'Berhasil' 
                              ? const Color(0xFF00A86B) // Dark green when selected
                              : Colors.white,
                          borderRadius: BorderRadius.circular(50), // More rounded corners
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            if (_selectedFilter == 'Berhasil')
                              BoxShadow(
                                color: const Color(0xFF00A86B).withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Berhasil',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _selectedFilter == 'Berhasil' 
                                  ? Colors.white 
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setState(() => _selectedFilter = 'Rollback'),
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: _selectedFilter == 'Rollback' 
                              ? const Color(0xFF00A86B) // Dark green when selected
                              : Colors.white,
                          borderRadius: BorderRadius.circular(50), // More rounded corners
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            if (_selectedFilter == 'Rollback')
                              BoxShadow(
                                color: const Color(0xFF00A86B).withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Rollback',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: _selectedFilter == 'Rollback' 
                                  ? Colors.white 
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: filteredUpdates.length,
                    itemBuilder: (context, index) {
                      return _buildUpdateHistoryItem(filteredUpdates[index]);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00A86B),
            Color(0xFF00C853),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: const [
                Text(
                  'Riwayat Pembaruan',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF424242),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Container(
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(24), // Made more rounded
        border: Border.all(
          color: isSelected 
              ? Theme.of(context).primaryColor 
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16), // Slightly wider padding
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateHistoryItem(FirmwareUpdate update) {
    // Format date manually without intl package
    String formatDate(DateTime date) {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
    }

    String formatTime(DateTime date) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (update.status) {
      case UpdateStatus.success:
        statusColor = const Color(0xFF2E7D32);
        statusIcon = Icons.check_circle;
        statusText = 'Berhasil';
        break;
      case UpdateStatus.rollback:
        statusColor = const Color(0xFFC62828);
        statusIcon = Icons.restore;
        statusText = 'Rollback';
        break;
      case UpdateStatus.inProgress:
        statusColor = const Color(0xFF1565C0);
        statusIcon = Icons.update;
        statusText = 'Sedang Berjalan';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              update.deviceName,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatDate(update.date),
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      update.fromVersion,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      update.toVersion,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      statusIcon,
                      size: 16,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  update.details,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                if (update.status == UpdateStatus.rollback && update.mlDetails != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.psychology,
                          size: 16,
                          color: Color(0xFF0277BD),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Rollback otomatis oleh ML',
                          style: TextStyle(
                            color: const Color(0xFF0277BD),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRollbackDetailsDialog(FirmwareUpdate update) {
    final mlDetails = update.mlDetails!;
    
    // Format dates manually
    String formatDate(DateTime date) {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
    }

    String formatTime(DateTime date) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text('Detail Rollback ML'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Perangkat', update.deviceName),
            _buildDetailRow('Tanggal & Waktu',
                '${formatDate(mlDetails.detectedAt)} ${formatTime(mlDetails.detectedAt)}'),
            _buildDetailRow('Versi', '${update.fromVersion} → ${update.toVersion}'),
            _buildDetailRow('Jenis Anomali', mlDetails.anomalyType),
            _buildDetailRow(
                'Confidence Score', '${(mlDetails.confidenceScore * 100).toStringAsFixed(0)}%'),
            const SizedBox(height: 16),
            const Text(
              'Grafik Performa',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Grafik performa perangkat',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle download detailed report action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D62),
            ),
            child: const Text('Unduh Laporan'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Riwayat'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _filterOptions
              .map(
                (filter) => RadioListTile<String>(
                  title: Text(filter),
                  value: filter,
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.of(context).pop();
                  },
                  activeColor: const Color(0xFF2E7D62),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

}

// Model classes
enum UpdateStatus { success, rollback, inProgress }

class FirmwareUpdate {
  final String deviceName;
  final String fromVersion;
  final String toVersion;
  final DateTime date;
  final UpdateStatus status;
  final String details;
  final MLRollbackDetails? mlDetails;

  FirmwareUpdate({
    required this.deviceName,
    required this.fromVersion,
    required this.toVersion,
    required this.date,
    required this.status,
    required this.details,
    this.mlDetails,
  });
}

class MLRollbackDetails {
  final double confidenceScore;
  final String anomalyType;
  final DateTime detectedAt;

  MLRollbackDetails({
    required this.confidenceScore,
    required this.anomalyType,
    required this.detectedAt,
  });
}