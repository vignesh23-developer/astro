// kundli_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../api_services/kundli_api_service.dart';
import '../model/kudli_model.dart';


class KundliController extends GetxController {
  final KundliApiService apiService = KundliApiService();

  RxBool isLoading = false.obs;
  TextEditingController locationController = TextEditingController();
  RxString coordinates = "".obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  Rx<KundliModel?> kundliData = Rx<KundliModel?>(null);

  Future<void> getCoordinatesFromLocation() async {
    if (locationController.text.isEmpty) {
      Get.snackbar("Warning", "Please enter a location");
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(locationController.text);
      if (locations.isNotEmpty) {
        coordinates.value = "${locations.first.latitude},${locations.first.longitude}";
        debugPrint("Manual Location Coordinates -> ${coordinates.value}");
      } else {
        Get.snackbar("Error", "Location not found");
      }
    } catch (e) {
      Get.snackbar("Error", "Location not found: $e");
      debugPrint("Location error: $e");
    }
  }

  String getFormattedDateTime() {
    DateTime combined = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );
    return DateFormat("yyyy-MM-ddTHH:mm:ss+05:30").format(combined);
  }

  Future<void> fetchKundli() async {
    if (locationController.text.isEmpty) {
      Get.snackbar("Warning", "Please enter birth place");
      return;
    }

    if (coordinates.value.isEmpty) {
      await getCoordinatesFromLocation();
    }

    isLoading.value = true;

    try {
      final result = await apiService.getKundli(
        datetime: getFormattedDateTime(),
        coordinates: coordinates.value,
      );

      if (result != null) {
        kundliData.value = result;
        Get.snackbar("Success", "Kundli generated successfully!");
      } else {
        Get.snackbar("Error", "Failed to generate Kundli");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to generate Kundli: $e");
      debugPrint("API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> generatePDF() async {
    if (kundliData.value == null) return;

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text('Kundli Details',
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),

            // Birth Details
            pw.Header(level: 1, child: pw.Text('Birth Details')),
            pw.SizedBox(height: 10),
            pw.Text('Birth Date: ${getFormattedDateTime()}'),
            pw.Text('Birth Place: ${locationController.text}'),
            pw.Text('Coordinates: ${coordinates.value}'),
            pw.SizedBox(height: 20),

            // Nakshatra Details
            if (kundliData.value!.data?.kundli?.nakshatraDetails != null) ...[
              pw.Header(level: 1, child: pw.Text('Nakshatra Details')),
              pw.SizedBox(height: 10),
              pw.Text('Nakshatra: ${kundliData.value!.data!.kundli!.nakshatraDetails!.nakshatra?.name ?? 'N/A'}'),
              pw.Text('Pada: ${kundliData.value!.data!.kundli!.nakshatraDetails!.nakshatra?.pada ?? 'N/A'}'),
              pw.Text('Moon Sign: ${kundliData.value!.data!.kundli!.nakshatraDetails!.chandraRasi?.name ?? 'N/A'}'),
              pw.Text('Sun Sign: ${kundliData.value!.data!.kundli!.nakshatraDetails!.sooryaRasi?.name ?? 'N/A'}'),
              pw.SizedBox(height: 20),

              // Additional Info
              if (kundliData.value!.data!.kundli!.nakshatraDetails!.additionalInfo != null) ...[
                pw.Header(level: 1, child: pw.Text('Additional Information')),
                pw.SizedBox(height: 10),
                pw.Text('Deity: ${kundliData.value!.data!.kundli!.nakshatraDetails!.additionalInfo!.deity}'),
                pw.Text('Ganam: ${kundliData.value!.data!.kundli!.nakshatraDetails!.additionalInfo!.ganam}'),
                pw.Text('Symbol: ${kundliData.value!.data!.kundli!.nakshatraDetails!.additionalInfo!.symbol}'),
                pw.Text('Animal Sign: ${kundliData.value!.data!.kundli!.nakshatraDetails!.additionalInfo!.animalSign}'),
                pw.Text('Birth Stone: ${kundliData.value!.data!.kundli!.nakshatraDetails!.additionalInfo!.birthStone}'),
                pw.SizedBox(height: 20),
              ],
            ],

            // Mangal Dosha
            if (kundliData.value!.data?.kundli?.mangalDosha != null) ...[
              pw.Header(level: 1, child: pw.Text('Mangal Dosha')),
              pw.SizedBox(height: 10),
              pw.Text('Status: ${kundliData.value!.data!.kundli!.mangalDosha!.hasDosha ? "Yes" : "No"}'),
              pw.Text('Description: ${kundliData.value!.data!.kundli!.mangalDosha!.description}'),
              pw.SizedBox(height: 20),
            ],

            // Yogas
            if (kundliData.value!.data?.kundli?.yogaDetails != null) ...[
              pw.Header(level: 1, child: pw.Text('Yogas')),
              pw.SizedBox(height: 10),
              ...kundliData.value!.data!.kundli!.yogaDetails!.map((yoga) =>
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ${yoga.name}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('  ${yoga.description}'),
                      pw.SizedBox(height: 5),
                    ],
                  )
              ).toList(),
              pw.SizedBox(height: 20),
            ],

            // Planet Positions
            if (kundliData.value!.data?.planet?.planetPosition != null) ...[
              pw.Header(level: 1, child: pw.Text('Planet Positions')),
              pw.SizedBox(height: 10),
              ...kundliData.value!.data!.planet!.planetPosition!
                  .where((p) => p.id <= 6)
                  .map((planet) =>
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${planet.name}:',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text('  Rasi: ${planet.rasi?.name ?? 'N/A'}'),
                      pw.Text('  Degree: ${planet.degree.toStringAsFixed(2)}°'),
                      pw.Text('  Retrograde: ${planet.isRetrograde ? "Yes" : "No"}'),
                      pw.SizedBox(height: 5),
                    ],
                  )
              ).toList(),
              pw.SizedBox(height: 20),
            ],

            // Current Dasha
            if (kundliData.value!.data?.dasha?.dashaPeriods != null &&
                kundliData.value!.data!.dasha!.dashaPeriods!.isNotEmpty) ...[
              pw.Header(level: 1, child: pw.Text('Current Dasha Period')),
              pw.SizedBox(height: 10),
              pw.Text('Mahadasha: ${kundliData.value!.data!.dasha!.dashaPeriods![0].name}'),
              pw.Text('Start: ${kundliData.value!.data!.dasha!.dashaPeriods![0].start}'),
              pw.Text('End: ${kundliData.value!.data!.dasha!.dashaPeriods![0].end}'),
              pw.SizedBox(height: 20),
            ],

            // Dasha Balance
            if (kundliData.value!.data?.dasha?.dashaBalance != null) ...[
              pw.Header(level: 1, child: pw.Text('Dasha Balance')),
              pw.SizedBox(height: 10),
              pw.Text('Lord: ${kundliData.value!.data!.dasha!.dashaBalance!.lord?.name ?? 'N/A'}'),
              pw.Text('Duration: ${kundliData.value!.data!.dasha!.dashaBalance!.duration}'),
              pw.Text('Description: ${kundliData.value!.data!.dasha!.dashaBalance!.description}'),
              pw.SizedBox(height: 20),
            ],
          ],
        ),
      );

      // Save PDF
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/kundli_${DateTime.now().millisecondsSinceEpoch}.pdf");
      await file.writeAsBytes(await pdf.save());

      // Open PDF
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'kundli.pdf');

      Get.snackbar("Success", "PDF generated successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to generate PDF: $e");
      debugPrint("PDF Error: $e");
    }
  }
}