import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'birth_chart_screen.dart';

class BirthDetailsFormScreen extends StatefulWidget {
  const BirthDetailsFormScreen({super.key});

  @override
  State<BirthDetailsFormScreen> createState() => _BirthDetailsFormScreenState();
}

class _BirthDetailsFormScreenState extends State<BirthDetailsFormScreen> {

  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _searchController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();

  DateTime _selectedDate = DateTime(1990, 1, 1);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 12, minute: 0);
  String _gender = 'female';

  bool _isFetchingCoords = false;
  bool _isDark = false;

  @override
  void dispose() {
    _nameController.dispose();
    _placeController.dispose();
    _searchController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  /// 📍 CURRENT LOCATION
  Future<void> _getCurrentLocation() async {
    setState(() => _isFetchingCoords = true);

    try {
      /// 🔐 CHECK PERMISSION
      var status = await Permission.location.status;

      if (status.isDenied) {
        status = await Permission.location.request();
      }

      if (status.isPermanentlyDenied) {
        openAppSettings();
        throw "Location permission permanently denied";
      }

      if (!status.isGranted) {
        throw "Location permission not granted";
      }

      /// 📍 CHECK GPS SERVICE
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw "Please enable GPS";
      }

      /// 📡 GET LOCATION
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _latController.text = position.latitude.toString();
      _lngController.text = position.longitude.toString();

      /// 🌍 GET ADDRESS
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        _placeController.text =
        "${p.locality}, ${p.administrativeArea}, ${p.country}";
      }

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      setState(() => _isFetchingCoords = false);
    }
  }

  /// 🔍 SEARCH LOCATION
  Future<void> _fetchCoordinatesFromLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isFetchingCoords = true);

    try {
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        _latController.text = loc.latitude.toString();
        _lngController.text = loc.longitude.toString();
        _placeController.text = query;
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$e")));
    } finally {
      setState(() => _isFetchingCoords = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final lat = double.tryParse(_latController.text);
    final lng = double.tryParse(_lngController.text);

    if (lat == null || lng == null) return;

    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BirthChartScreen(
          name: _nameController.text,
          dateTime: dateTime,
          latitude: lat,
          longitude: lng,
          placeOfBirth: _placeController.text,
          gender: _gender,
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      "${dt.day}/${dt.month}/${dt.year}";

  String _formatTime(TimeOfDay t) =>
      "${t.hour}:${t.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0F0524),
                Color(0xFF4B0082),
                Color(0xFF8A2BE2),
                Color(0xFFDA70D6),
              ],
            ),
          ),
        ),
        title: const Text("Birth Chart",style: TextStyle(color: Colors.white),),
      ),

      body: Stack(
        children: [

          /// 🌌 ASTRO BACKGROUND
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F0524),
                  Color(0xFF4B0082),
                  Color(0xFF8A2BE2),
                  Color(0xFFDA70D6),
                ],
              ),
            ),
          ),

          /// ⭐ STARS
          ...List.generate(
            40,
                (index) => Positioned(
              top: (index * 37) % 700,
              left: (index * 53) % 350,
              child: Container(
                height: 2,
                width: 2,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          /// 🌙 GLOW
          Positioned(
            top: 60,
            right: 40,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.7),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 FORM CONTENT
          Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [

                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20.r),
                  ),

                  child: Column(
                    children: [

                      _field("Full Name", _nameController, Icons.person),

                      SizedBox(height: 12.h),

                      /// SEARCH + GPS
                      Row(
                        children: [
                          Expanded(
                            child: _field("Search Location", _searchController, Icons.search),
                          ),
                          IconButton(
                            onPressed: _fetchCoordinatesFromLocation,
                            icon: const Icon(Icons.search,color: Colors.black,),
                          ),
                          _isFetchingCoords
                              ? SizedBox(
                            height: 30.h,
                            width: 30.w,
                            child: Lottie.asset(
                              'assets/ALogo/loading.json',
                              fit: BoxFit.cover,
                            ),
                          )
                              : IconButton(
                            onPressed: _getCurrentLocation,
                            icon: const Icon(Icons.my_location, color: Colors.black),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      _field("Place of Birth", _placeController, Icons.location_on),

                      SizedBox(height: 12.h),

                      _field("Latitude", _latController, Icons.map),

                      SizedBox(height: 12.h),

                      _field("Longitude", _lngController, Icons.map_outlined),

                      SizedBox(height: 16.h),

                      /// DATE & TIME
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _pickDate,
                              child: _pickerBox(Icons.calendar_today, _formatDate(_selectedDate)),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: _pickTime,
                              child: _pickerBox(Icons.access_time, _formatTime(_selectedTime)),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      /// GENDER
                      Row(
                        children: [
                          Expanded(child: _genderChip("Female", "female")),
                          SizedBox(width: 10.w),
                          Expanded(child: _genderChip("Male", "male")),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    backgroundColor: const Color(0xFF8E2DE2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(
                    "Generate Birth Chart",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c, IconData icon) {
    return TextFormField(
      controller: c,
      style: TextStyle(color: Colors.black, fontSize: 13.sp),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIcon: Icon(icon, color: Color(0xFF8E2DE2)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _pickerBox(IconData icon, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF8E2DE2)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _genderChip(String label, String value) {
    final selected = _gender == value;

    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          )
              : null,
          color: selected ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}