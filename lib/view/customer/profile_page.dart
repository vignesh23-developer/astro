import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';
import '../../api_services/video_api.dart';
import '../../controller/profile_controller.dart';
import '../../routes/SessionManger.dart';
import 'login_view.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final ProfileController profileController = Get.put(ProfileController());
  late AnimationController _animationController;
  bool _isEditing = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String _userName = "";
  String _userDob = "";
  String _userEmail = "";
  String _userPhone = "";
  String _userLocation = "";
  String _userBio =
      "Astrology enthusiast exploring celestial patterns and cosmic wisdom. Passionate about learning and sharing insights.";

  @override
  void initState() {
    super.initState();
    _nameController.text = _userName;
    _dobController.text = _userDob;
    _emailController.text = _userEmail;
    _phoneController.text = _userPhone;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final userId = await SessionManager.getUserId();

    final response = await VideoApiService.getProfile(int.parse(userId!));

    if (response.success == true) {
      setState(() {
        _userName = response.data!.name ?? "";
        _userEmail = response.data!.email ?? "";
        if (response.data!.dob != null && response.data!.dob!.isNotEmpty) {
          DateTime dob = DateTime.parse(response.data!.dob!);
          _userDob = DateFormat("yyyy-MM-dd").format(dob);
        } else {
          _userDob = "";
        }
        _userLocation = response.data!.address ?? "";

        _nameController.text = _userName;
        _emailController.text = _userEmail;
        _dobController.text = _userDob;
        _locationController.text = _userLocation;
      });
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) _saveChanges();
    });
  }

  void _saveChanges() async {
    await profileController.updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _locationController.text,
      dob: _dobController.text,
    );

    setState(() {
      _userName = _nameController.text;
      _userDob = _dobController.text;
      _userEmail = _emailController.text;
      _userPhone = _phoneController.text;
      _userLocation = _locationController.text;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 3, 15),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.day} ${_getMonthName(picked.month)}, ${picked.year}";
      });
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            pinned: true,
            expandedHeight: 220.h,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      // Profile avatar
                      Stack(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(
                                    'assets/profile_avatar.png',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        _userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isEditing ? Icons.check : Icons.edit,
                  color: Colors.white,
                ),
                onPressed: _toggleEditMode,
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Info
                  _buildSectionTitle("Personal Info"),
                  SizedBox(height: 8.h),
                  _buildEditableField(
                    label: "Full Name",
                    icon: Icons.person,
                    value: _userName,
                    controller: _nameController,
                  ),
                  SizedBox(height: 8.h),
                  _buildEditableField(
                    label: "Date of Birth",
                    icon: Icons.cake,
                    value: _userDob,
                    controller: _dobController,
                    isDate: true,
                  ),

                  SizedBox(height: 8.h),
                  _buildEditableField(
                    label: "Address",
                    icon: Icons.home,
                    value: _userLocation,
                    controller: _locationController,
                    keyboardType: TextInputType.streetAddress,
                  ),
                  SizedBox(height: 16.h),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showLogoutDialog();
                      },
                      child: Text(
                        "Log out",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),

                  // _buildSectionTitle("About Me"),
                  // SizedBox(height: 8.h),
                  // Container(
                  //   width: double.infinity,
                  //   padding: EdgeInsets.all(12.w),
                  //   decoration: BoxDecoration(
                  //       color: Colors.white12,
                  //       borderRadius: BorderRadius.circular(12.sp)),
                  //   child: Text(
                  //     _userBio,
                  //     style:
                  //     TextStyle(color: Colors.white70, fontSize: 14.sp),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, size: 50, color: Colors.redAccent),

              const SizedBox(height: 15),

              const Text(
                "Logout",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      Get.offAll(() => LoginView());
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required IconData icon,
    required String value,
    required TextEditingController controller,
    bool isDate = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: _isEditing
                ? TextFormField(
                    controller: controller,
                    readOnly: isDate,
                    onTap: isDate ? () => _selectDate(context) : null,
                    keyboardType: keyboardType,
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: label,
                      labelStyle: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String) onChange,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF1A1A2E),
        style: TextStyle(color: Colors.white, fontSize: 14.sp),
        onChanged: (val) {
          if (val != null) onChange(val);
        },
        items: items
            .map(
              (i) => DropdownMenuItem(
                value: i,
                child: Text(i, style: TextStyle(color: Colors.white)),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
