import 'package:flutter/material.dart';
import 'package:m7_livelyness_detection/index.dart';

class ScreenUiTest extends StatefulWidget {
  const ScreenUiTest({super.key});

  @override
  State<ScreenUiTest> createState() => _ScreenUiTestState();
}

class _ScreenUiTestState extends State<ScreenUiTest> {
  M7CapturedImage? response;
  @override
  void initState() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        M7LivelynessDetection.instance.configure(
          lineColor: Colors.white,
          dotColor: Colors.purple.shade800,
          dotSize: 2.0,
          lineWidth: 1.6,
          displayDots: false,
          displayLines: true,
          dashValues: [2.0, 5.0], // <--- Dash Values
          thresholds: [
            M7SmileDetectionThreshold(
              probability: 0.8,
            ),
            M7BlinkDetectionThreshold(
              leftEyeProbability: 0.25,
              rightEyeProbability: 0.25,
            ),
          ],
        );
      });
    }
    steps.shuffle(Random());
    setState(() {});
    super.initState();
  }

  List<M7LivelynessStepItem> steps = [
    M7LivelynessStepItem(
      step: M7LivelynessStep.blink,
      title: "Blink",
      isCompleted: true,
      thresholdToCheck: 10.0,
    ),
    M7LivelynessStepItem(
      step: M7LivelynessStep.smile,
      title: "Smile",
      isCompleted: true,
      thresholdToCheck: 10.0,
    ),
    M7LivelynessStepItem(
      step: M7LivelynessStep.turnLeft,
      title: "turnLeft",
      isCompleted: true,
      thresholdToCheck: 10.0,
    ),
    M7LivelynessStepItem(
      step: M7LivelynessStep.turnRight,
      title: "turnRight",
      isCompleted: true,
      thresholdToCheck: 10.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (response?.imgPath.isNotEmpty ?? false)
            Container(
              clipBehavior: Clip.hardEdge,
              height: 400.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Image.file(
                File(response?.imgPath ?? ""),
                fit: BoxFit.contain, // Adjust this based on your requirement
                // You can also specify other properties like width, height, etc.
              ),
            ),
          const SizedBox(
            height: 30.0,
          ),
          Text(
            'Livelyness: ${response?.didCaptureAutomatically}',
          ),
          const SizedBox(
            height: 30.0,
          ),
          InkWell(
            onTap: () async {
              response = await M7LivelynessDetection.instance.detectLivelyness(
                context,
                config: M7DetectionConfig(
                  steps: steps,
                  startWithInfoScreen: true,
                  captureButtonColor: Colors.blue,
                  maxSecToDetect: 20,
                  allowAfterMaxSec: true,
                ),
              );
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                height: 60.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Text(
                    "Detection Config",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
