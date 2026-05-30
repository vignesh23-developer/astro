// jodhidam_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controller/kundli_controller.dart';

class JodhidamScreen extends StatefulWidget {
  const JodhidamScreen({super.key});

  @override
  State<JodhidamScreen> createState() => _JodhidamScreenState();
}

class _JodhidamScreenState extends State<JodhidamScreen> {
  final KundliController controller = Get.put(KundliController());

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      // Don't call automatically, let user enter location
    } else if (status.isDenied) {
      Get.snackbar("Permission", "Location permission denied");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("ஜோதிடம்"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          Obx(() {
            if (controller.kundliData.value != null) {
              return IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                onPressed: () => controller.generatePDF(),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Location Field
              TextField(
                controller: controller.locationController,
                decoration: const InputDecoration(
                  labelText: "Enter Birth Place",
                  hintText: "Example: Coimbatore",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 15),

              // Date Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today,
                      color: Colors.deepPurple),
                  title: const Text("Select Date"),
                  subtitle: Text(
                    DateFormat("yyyy-MM-dd")
                        .format(controller.selectedDate.value),
                  ),
                  onTap: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      controller.selectedDate.value = date;
                    }
                  },
                ),
              ),
              const SizedBox(height: 15),

              // Time Card
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.access_time,
                      color: Colors.deepPurple),
                  title: const Text("Select Time"),
                  subtitle: Text(controller.selectedTime.value.format(context)),
                  onTap: () async {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      controller.selectedTime.value = time;
                    }
                  },
                ),
              ),
              const SizedBox(height: 25),

              // Generate Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: controller.isLoading.value ? null : () {
                    controller.fetchKundli();
                  },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Generate Kundli",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Result Card
              if (controller.kundliData.value != null && controller.kundliData.value!.data != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kundli Result",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 10),

                        // Nakshatra Info
                        if (controller.kundliData.value!.data!.kundli?.nakshatraDetails != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Nakshatra Details:",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("Nakshatra: ${controller.kundliData.value!.data!.kundli!.nakshatraDetails!.nakshatra?.name ?? 'N/A'}"),
                              Text("Pada: ${controller.kundliData.value!.data!.kundli!.nakshatraDetails!.nakshatra?.pada ?? 'N/A'}"),
                              Text("Moon Sign: ${controller.kundliData.value!.data!.kundli!.nakshatraDetails!.chandraRasi?.name ?? 'N/A'}"),
                              Text("Sun Sign: ${controller.kundliData.value!.data!.kundli!.nakshatraDetails!.sooryaRasi?.name ?? 'N/A'}"),
                              const SizedBox(height: 10),

                              // Additional Info
                              if (controller.kundliData.value!.data!.kundli!.nakshatraDetails!.additionalInfo != null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Additional Info:",
                                        style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text("Birth Stone: ${controller.kundliData.value!.data!.kundli!.nakshatraDetails!.additionalInfo!.birthStone}"),
                                    Text("Deity: ${controller.kundliData.value!.data!.kundli!.nakshatraDetails!.additionalInfo!.deity}"),
                                    Text("Ganam: ${controller.kundliData.value!.data!.kundli!.nakshatraDetails!.additionalInfo!.ganam}"),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                            ],
                          ),

                        // Mangal Dosha
                        if (controller.kundliData.value!.data!.kundli?.mangalDosha != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Mangal Dosha:",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(controller.kundliData.value!.data!.kundli!.mangalDosha!.description),
                              const SizedBox(height: 10),
                            ],
                          ),

                        // Yogas
                        if (controller.kundliData.value!.data!.kundli?.yogaDetails != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Yogas:",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              ...controller.kundliData.value!.data!.kundli!.yogaDetails!
                                  .map((yoga) => Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text("• ${yoga.name}: ${yoga.description}"),
                              ))
                                  .toList(),
                              const SizedBox(height: 10),
                            ],
                          ),

                        // Current Dasha
                        if (controller.kundliData.value!.data?.dasha?.dashaPeriods != null &&
                            controller.kundliData.value!.data!.dasha!.dashaPeriods!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Current Mahadasha:",
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("${controller.kundliData.value!.data!.dasha!.dashaPeriods![0].name}"),
                              Text("From: ${controller.kundliData.value!.data!.dasha!.dashaPeriods![0].start.split('T')[0]}"),
                              const SizedBox(height: 10),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}