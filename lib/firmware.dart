import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firmware Upload',
      theme: ThemeData(
        primaryColor: const Color(0xFF00875A),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00875A),
          primary: const Color(0xFF00875A),
          secondary: const Color(0xFF3F51B5),
        ),
      ),
      home: const FirmwareUploadPage(),
    );
  }
}

class FirmwareUploadPage extends StatefulWidget {
  const FirmwareUploadPage({Key? key}) : super(key: key);

  @override
  State<FirmwareUploadPage> createState() => _FirmwareUploadPageState();
}

class _FirmwareUploadPageState extends State<FirmwareUploadPage> {
  final TextEditingController _versionController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _deviceType = 'ESP 32';
  String _nodeType = 'Pilih Tipe Node';

  // File upload related variables
  File? _selectedFile;
  String? _selectedFileName;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  // API endpoint
  static const String _uploadEndpoint =
      'https://update-firm-79269000209.asia-southeast2.run.app/upload';
  // Device types and node types options
  final List<String> _deviceTypes = [
    'ESP 32',
    'Arduino Uno',
    'Arduino Nano',
    'ESP8266'
  ];
  final List<String> _nodeTypes = [
    'Soil Moisture',
    'Humidity Sensor',
  ];
  // Mapping dari tampilan UI ke nilai API untuk node type
  final Map<String, String> _nodeTypeMapping = {
    'Soil Moisture': 'soil-moisture',
    'Humidity Sensor': 'temp-measure',
  };

  // Mapping dari tampilan UI ke nilai API untuk device type
  final Map<String, String> _deviceTypeMapping = {
    'ESP 32': 'esp32',
    'Arduino Uno': 'arduino-uno',
    'Arduino Nano': 'arduino-nano',
    'ESP8266': 'esp8266',
  };

  @override
  void dispose() {
    _versionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDeviceBadge(),
                    const SizedBox(height: 16),
                    _buildDeviceCard(),
                    const SizedBox(height: 16),
                    _buildVersionCard(),
                    const SizedBox(height: 16),
                    _buildFileUpload(),
                    const SizedBox(height: 20),
                    _buildUploadButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
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
            Color(0xFF00A86B), // Darker green
            Color(0xFF00C853), // Lighter green
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
          // Add circular gradient overlays
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
                  'Upload Firmware',
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

  Widget _buildDeviceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF3F51B5).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'IoT Device',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Color(0xFF3F51B5),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDeviceCard() {
    return _buildCard(
      title: 'Detail Perangkat',
      icon: Icons.computer,
      children: [
        _buildDropdownField(
          label: 'Tipe Perangkat',
          value: _deviceType,
          onTap: () {
            _showDeviceTypeDropdown();
          },
        ),
        const SizedBox(height: 16),
        _buildDropdownField(
          label: 'Tipe Node',
          value: _nodeType,
          onTap: () {
            _showNodeTypeDropdown();
          },
        ),
      ],
    );
  }

  Widget _buildVersionCard() {
    return _buildCard(
      title: 'Informasi Versi',
      icon: Icons.trending_up,
      children: [
        _buildTextField(
          label: 'Versi',
          controller: _versionController,
          placeholder: 'Contoh: v1.0.0',
          required: true,
        ),
        const SizedBox(height: 16), // Add spacing between fields
        _buildTextField(
          label: 'Deskripsi',
          controller: _descriptionController,
          placeholder: 'Masukkan deskripsi firmware',
          required: false,
          maxLines: 3, // Allow multiple lines for description
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF424242),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Color(0xFF263238),
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    bool required = false,
    int maxLines = 1, // Add maxLines parameter
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF424242),
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines, // Use the maxLines parameter
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.grey,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileUpload() {
    return Center(
      child: InkWell(
        onTap: _isUploading ? null : _selectFile,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: _selectedFile != null ? Colors.green.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _selectedFile != null
                  ? Colors.green
                  : Theme.of(context).primaryColor.withOpacity(0.5),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _selectedFile != null
                    ? Icons.check_circle
                    : Icons.upload_file_outlined,
                size: 48,
                color: _selectedFile != null
                    ? Colors.green
                    : Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                _selectedFile != null ? 'File Terpilih' : 'Upload Firmware',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: _selectedFile != null
                      ? Colors.green
                      : Theme.of(context).primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _selectedFile != null
                    ? _selectedFileName ?? 'File terpilih'
                    : 'Klik untuk memilih atau seret file di sini',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              if (_isUploading) ...[
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: _uploadProgress,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mengupload... ${(_uploadProgress * 100).toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isUploading ? null : _uploadFirmware,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
            backgroundColor:
                _isUploading ? Colors.grey : Theme.of(context).primaryColor,
            minimumSize: const Size(double.infinity, 56),
          ),
          child: _isUploading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Mengupload...',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                )
              : const Text(
                  'Upload Firmware',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }

  // File selection method
  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['bin', 'hex', 'ino', 'cpp', 'elf'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _selectedFileName = result.files.single.name;
        });
        _showSnackBar(
            'File berhasil dipilih: $_selectedFileName', Colors.green);
      }
    } catch (e) {
      _showSnackBar('Gagal memilih file: $e', Colors.red);
    }
  }

  // Upload firmware method
  Future<void> _uploadFirmware() async {
    if (!_validateForm()) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw 'User tidak terautentikasi';
      }

      final session = Supabase.instance.client.auth.currentSession;
      if (session == null) {
        throw 'Session tidak ditemukan';
      }

      var request = http.MultipartRequest('POST', Uri.parse(_uploadEndpoint));

      // Add headers for authentication
      request.headers.addAll({
        'Authorization': 'Bearer ${session.accessToken}',
        'X-Refresh-Token': session.refreshToken ?? '',
      }); // Add form fields
      request.fields['version'] = _versionController.text.trim();

      // Konversi nilai device_type untuk API
      String deviceTypeValue = _deviceTypeMapping[_deviceType] ?? _deviceType;
      request.fields['device_type'] = deviceTypeValue;

      // Konversi nilai node_type untuk API menggunakan mapping
      String nodeTypeValue = _nodeTypeMapping[_nodeType] ?? _nodeType;
      request.fields['node_type'] = nodeTypeValue;

      request.fields['description'] = _descriptionController.text.trim();

      // Add file
      if (_selectedFile != null) {
        var fileStream = http.ByteStream(_selectedFile!.openRead());
        var length = await _selectedFile!.length();
        var multipartFile = http.MultipartFile(
          'file',
          fileStream,
          length,
          filename: _selectedFileName,
        );
        request.files.add(multipartFile);
      }

      // Send request with progress tracking
      var streamedResponse = await request.send();

      // Update progress
      setState(() {
        _uploadProgress = 1.0;
      });

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        _showSnackBar('Firmware berhasil diupload!', Colors.green);
        _resetForm();
      } else {
        String errorMessage = 'Upload gagal (${response.statusCode})';
        try {
          // Try to parse error message from response
          var responseBody = response.body;
          if (responseBody.contains('error')) {
            errorMessage = responseBody;
          }
        } catch (e) {
          // Use default error message
        }
        throw errorMessage;
      }
    } catch (e) {
      _showSnackBar('Upload gagal: $e', Colors.red);
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  // Form validation
  bool _validateForm() {
    if (_versionController.text.trim().isEmpty) {
      _showSnackBar('Versi firmware harus diisi', Colors.orange);
      return false;
    }

    if (_nodeType == 'Pilih Tipe Node') {
      _showSnackBar('Pilih tipe node terlebih dahulu', Colors.orange);
      return false;
    }

    if (_selectedFile == null) {
      _showSnackBar('Pilih file firmware terlebih dahulu', Colors.orange);
      return false;
    }

    return true;
  }

  // Reset form after successful upload
  void _resetForm() {
    _versionController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedFile = null;
      _selectedFileName = null;
      _deviceType = 'ESP 32';
      _nodeType = 'Pilih Tipe Node';
    });
  }

  // Show snackbar
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show device type dropdown
  void _showDeviceTypeDropdown() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Tipe Perangkat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Menampilkan ESP 32 sebagai pilihan yang bisa dipilih
            ListTile(
              title: const Text('ESP 32'),
              onTap: () {
                setState(() {
                  _deviceType = 'ESP 32';
                });
                Navigator.pop(context);
              },
              selected: _deviceType == 'ESP 32',
            ),
            // Untuk device type lainnya, tampilkan sebagai disabled dengan pesan pengembangan
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Perangkat dalam pengembangan:',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ..._deviceTypes
                .where((type) => type != 'ESP 32')
                .map((type) => ListTile(
                      title: Text(type),
                      onTap: () {
                        // Tampilkan pesan bahwa fitur masih dalam pengembangan
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Fitur untuk perangkat ini masih dalam pengembangan.'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      trailing: const Chip(
                        label: Text('Coming Soon'),
                        labelStyle:
                            TextStyle(fontSize: 10, color: Colors.white),
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.zero,
                      ),
                      enabled: false,
                      textColor: Colors.grey,
                    )),
          ],
        ),
      ),
    );
  }

  // Show node type dropdown
  void _showNodeTypeDropdown() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Tipe Node',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._nodeTypes.map((type) => ListTile(
                  title: Text(type),
                  onTap: () {
                    setState(() {
                      _nodeType = type;
                    });
                    Navigator.pop(context);
                  },
                  selected: _nodeType == type,
                )),
          ],
        ),
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double value;
  final Color color;

  CircularProgressPainter({
    required this.value,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * value,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
