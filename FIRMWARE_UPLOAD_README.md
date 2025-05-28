# Firmware Upload Feature

## Overview
Form upload firmware yang terintegrasi dengan API untuk mengunggah firmware ke server menggunakan autentikasi Supabase.

## Features
✅ **File Selection**: Memilih file firmware (.bin, .hex, .ino, .cpp)
✅ **Form Validation**: Validasi input version dan node type
✅ **Progress Tracking**: Progress bar saat upload
✅ **Error Handling**: Menampilkan error jika upload gagal
✅ **Authentication**: Menggunakan access token dan refresh token Supabase
✅ **Modern UI**: Interface yang user-friendly dengan design modern

## API Integration

### Endpoint
```
POST https://update-firm-79269000209.asia-southeast2.run.app/upload
```

### Headers
```
Authorization: Bearer {access_token}
X-Refresh-Token: {refresh_token}
Content-Type: multipart/form-data
```

### Request Body (FormData)
- `firmware`: File (binary data)
- `version`: String (contoh: "v1.0.0")
- `description`: String (deskripsi firmware)
- `device_type`: String ("ESP 32", "ESP 8266", "Arduino Uno", "Arduino Nano")
- `node_type`: String ("Sensor Node", "Actuator Node", "Gateway Node", "Master Node")

## Usage

### 1. Navigasi ke Firmware Upload
- Buka aplikasi
- Login dengan akun Supabase
- Tap pada tab "Firmware" di bottom navigation

### 2. Mengisi Form
1. **Pilih Tipe Perangkat**: Tap dropdown untuk memilih (ESP 32, ESP 8266, dll)
2. **Pilih Tipe Node**: Tap dropdown untuk memilih (Sensor Node, Actuator Node, dll)
3. **Masukkan Versi**: Input versi firmware (contoh: v1.0.0)
4. **Masukkan Deskripsi**: Deskripsi optional tentang firmware
5. **Pilih File**: Tap area upload untuk memilih file firmware

### 3. Upload Firmware
- Pastikan semua field required sudah diisi
- Tap tombol "Upload Firmware"
- Tunggu hingga upload selesai
- Success message akan ditampilkan jika berhasil

## Supported File Types
- `.bin` - Binary firmware files
- `.hex` - Intel HEX format
- `.ino` - Arduino sketch files
- `.cpp` - C++ source files

## Error Handling

### Common Errors
1. **No file selected**: Pilih file firmware terlebih dahulu
2. **Missing version**: Masukkan versi firmware
3. **Node type not selected**: Pilih tipe node
4. **Authentication failed**: Login ulang jika session expired
5. **Network error**: Periksa koneksi internet
6. **Server error**: Coba lagi atau hubungi admin

### Error Messages
- Error akan ditampilkan di atas form upload
- SnackBar akan muncul untuk notifikasi error/success
- Upload button akan disabled saat proses upload

## Dependencies
```yaml
dependencies:
  file_picker: ^8.0.0+1
  dio: ^5.4.0
  supabase_flutter: ^2.9.0
```

## Permissions (Android)
```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

## Code Structure

### Key Files
- `lib/firmware.dart` - Main firmware upload page
- `android/app/src/main/AndroidManifest.xml` - Android permissions

### Key Classes
- `FirmwareUploadPage` - Main widget
- `_FirmwareUploadPageState` - State management
- `dio_package.Dio` - HTTP client untuk upload
- `FilePicker` - File selection functionality

### Key Methods
- `_selectFile()` - File selection handler
- `_uploadFirmware()` - Upload process with progress tracking
- `_showDeviceTypeDialog()` - Device type selection
- `_showNodeTypeDialog()` - Node type selection
- `_resetForm()` - Reset form after successful upload

## Testing

### Manual Testing Steps
1. Buka aplikasi dan login
2. Navigasi ke tab Firmware
3. Test semua dropdown selections
4. Test file selection dengan berbagai format
5. Test upload dengan dan tanpa network
6. Test form validation
7. Test progress tracking
8. Test error scenarios

### API Testing
```bash
# Test dengan curl
curl -X POST https://update-firm-79269000209.asia-southeast2.run.app/upload \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "X-Refresh-Token: YOUR_REFRESH_TOKEN" \
  -F "firmware=@firmware.bin" \
  -F "version=v1.0.0" \
  -F "description=Test firmware" \
  -F "device_type=ESP 32" \
  -F "node_type=Sensor Node"
```

## Future Improvements
- [ ] File validation (size, type check)
- [ ] Resume upload functionality
- [ ] Multiple file upload
- [ ] Upload queue management
- [ ] Firmware versioning history
- [ ] OTA update integration
- [ ] Compression before upload
- [ ] Checksum verification
