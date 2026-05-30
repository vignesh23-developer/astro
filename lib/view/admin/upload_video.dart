import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:video_player/video_player.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../../controller/video_controller.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with SingleTickerProviderStateMixin {
  String? selectedType;
  File? selectedFile;
  VideoPlayerController? _videoController;
  bool isLoading = false;

  final List<String> types = ["free", "entry", "advance"];
  final Dio dio = Dio();

  late AnimationController _borderController;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _borderController.dispose();
    super.dispose();
  }

  Future<void> pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      selectedFile = File(result.files.single.path!);
      _videoController = VideoPlayerController.file(selectedFile!)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
        });
    }
  }

  Future<void> uploadVideo() async {
    if (selectedType == null || selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select type & video")),
      );
      return;
    }

    final videoController = Get.find<VideoController>();
    try {
      setState(() => isLoading = true);
      videoController.uploadProgress.value = 0;

      String cloudName = "dpzmoqjtv";
      String uploadPreset = "flutter_upload";

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          selectedFile!.path,
          filename: selectedFile!.path.split('/').last,
        ),
        "upload_preset": uploadPreset,
      });

      final response = await dio.post(
        "https://api.cloudinary.com/v1_1/$cloudName/video/upload",
        data: formData,
        onSendProgress: (sent, total) {
          videoController.uploadProgress.value = sent / total;
        },
      );

      String videoUrl = response.data["secure_url"];

      await videoController.uploadVideo(
        videoUrl: videoUrl,
        type: selectedType!,
      );

      await videoController.adminVideos("admin");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload Successful 🚀")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title
            Text(
              "Upload Your Video",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),

            /// Dropdown for Type
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                  color: Colors.purple.shade200,
                  width: 1.5,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedType,
                  hint: Row(
                    children: const [
                      Icon(Icons.video_collection_rounded, color: Colors.purple),
                      SizedBox(width: 8),
                      Text(
                        "Select Video Type",
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF6A5AE0),
                    size: 28,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                  items: types
                      .map(
                        (type) => DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Icon(
                            Icons.videocam_rounded,
                            color: type == "free"
                                ? Colors.green
                                : type == "entry"
                                ? Colors.orange
                                : Colors.redAccent,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            type[0].toUpperCase() + type.substring(1),style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() => selectedType = value);
                  },
                ),
              ),
            ),
            SizedBox(height: 30.h),

            /// Video Preview Card
            GestureDetector(
              onTap: pickVideo,
              child: Container(
                height: 220.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      /// Background
                      selectedFile == null
                          ? Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Text(
                            "Tap to select video",
                            style: TextStyle(
                              color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      )
                          : _videoController != null &&
                          _videoController!.value.isInitialized
                          ? VideoPlayer(_videoController!)
                          : Container(),

                      /// Play Overlay
                      Positioned.fill(
                        child: Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white.withOpacity(0.8),
                            size: 60.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 40.h),

            /// Wave Progress
            Obx(() {
              final progress = Get.find<VideoController>().uploadProgress.value;
              if (progress <= 0 || progress >= 1) return const SizedBox();

              return Column(
                children: [
                  Text(
                    "Uploading...",
                    style:
                    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 120.h,
                    width: 120.w,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        /// Circle
                        Container(
                          height: 120.h,
                          width: 120.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xff6C63FF), width: 5),
                          ),
                        ),

                        /// Wave Fill
                        ClipOval(
                          child: WaveWidget(
                            config: CustomConfig(
                              gradients: [
                                [Color(0xff6C63FF), Color(0xff8E7CFF)],
                                [Color(0xff8E7CFF), Color(0xffB3A8FF)],
                              ],
                              durations: [3500, 19440],
                              heightPercentages: [1 - progress, 1 - progress],
                              gradientBegin: Alignment.bottomLeft,
                              gradientEnd: Alignment.topRight,
                            ),
                            waveAmplitude: 8,
                            size: const Size(double.infinity, double.infinity),
                          ),
                        ),

                        /// Percent
                        Text(
                          "${(progress * 100).toStringAsFixed(0)}%",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),

            SizedBox(height: 30.h),

            /// Upload Button
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: InkWell(
                onTap: isLoading ? null : uploadVideo,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6A5AE0), Color(0xFF8E7BFF)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isLoading ? "Uploading..." : "Upload Video",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}