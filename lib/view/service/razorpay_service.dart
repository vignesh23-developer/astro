import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get.dart';
import '../../api_services/video_api.dart';
import '../../controller/video_controller.dart';
import '../../routes/SessionManger.dart';

class RazorpayService {
  String paymentType = "";
  int currentAmount = 0;
  late Razorpay _razorpay;
  final VideoController videoController = Get.find();
  Function()? onPaymentSuccessCallback;
  RazorpayService({this.onPaymentSuccessCallback}) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(String type, {required int amount}) {
    paymentType = type;
    currentAmount = amount;

    var options = {
      'key': 'rzp_live_Sfcja4KWsRa9YJ',
      'amount': amount * 100,
      'name': 'Astrology Learning',
      'description': 'Premium Video Access',
      'prefill': {
        'contact': '7397070682',
        'email': 'yamirukabayamen2026@gmail.com'
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      String? userId = await SessionManager.getUserId();

      if (userId == null) {
        Get.snackbar("Error", "User not found");
        return;
      }

      final res = await VideoApiService.savePayment(
        userId: int.parse(userId),
        paymentType: paymentType,
        paymentId: response.paymentId!,
        amount: currentAmount,
      );

      print("✅ Payment Saved: $res");

      // 🔥 Unlock AFTER backend success
      if (paymentType == "Entry") {
        videoController.unlockBasicVideos();
      } else if (paymentType == "Advance") {
        videoController.unlockAdvanceVideos();
      }
      bool isOpened = await SessionManager.isGiftOpened();

      if (!isOpened && paymentType == "Entry") {
        onPaymentSuccessCallback?.call();
      }

    } catch (e) {
      print("❌ Payment Save Error: $e");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
      "Payment Failed",
      response.message ?? "Payment error",
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );

    print("ERROR: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Wallet: ${response.walletName}");
  }

  void dispose() {
    _razorpay.clear();
  }
}
