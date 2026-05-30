import 'package:get/get.dart';
import '../api_services/video_api.dart';
import '../model/admin_video_model.dart';

class AdminVideoController extends GetxController {

  RxBool isLoading = false.obs;

  RxList<VideoModel> freeVideos = <VideoModel>[].obs;
  RxList<VideoModel> entryVideos = <VideoModel>[].obs;
  RxList<VideoModel> advanceVideos = <VideoModel>[].obs;

  @override
  void onInit() {
    fetchVideos();
    super.onInit();
  }

  Future<void> fetchVideos() async {

    try {

      isLoading(true);

      final data = await VideoApiService.getAllVideos();

      freeVideos.assignAll(data.freeVideos.videos.cast<VideoModel>());
      entryVideos.assignAll(data.entryVideos.videos.cast<VideoModel>());
      advanceVideos.assignAll(data.advanceVideos.videos.cast<VideoModel>());

    } catch (e) {

      print(e);

    } finally {

      isLoading(false);

    }
  }

  Future<void> deleteVideo(String id) async {

    try {

      bool success = await VideoApiService.deleteVideo(id);

      if(success){
        fetchVideos();
      }

    } catch (e) {

      print(e);

    }
  }
}