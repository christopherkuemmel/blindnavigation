# Blind Navigation - LNDW 2019

This project contains the code for a flutter app for real-time object detection using the **tflite** plugin. 
Moreover it includes the communication to the **VibroTac**.

## Table of Contents

## Installation

1. Checkout this project and open the local directory
2. Make sure you have flutter **v1.5.4-hotfix.2** installed (we can't guarantee that other versions will work!)
3. Open your IDE (VSCode / Android Studio)
4. Get Flutter/Dart packages
5. Launch a virtual android device / plug in a physical device
6. Deploy/debug the code to the device

## Usage

To use the app, first you have to pair a VibroTac (Bluetooth) [link](https://www.sensodrive.de/products/vibrotactile-feedback.php) device to your smart phone (in general Settings of your smartphone).
After that start the app and klick on the bluetooth icon on the top right.
Choose your VibroTac device from the drop down and click connect (a blue light on the VibroTac should light up).
You can now test the connection to the device with the two left and right buttons in the bottom (still in bluetooth settings).
If the connection is confirmed you can go back to the main screen.
In the top bar are two sliders.
The red one is for starting the object detection + sending signals to the VibroTac.
The grey/green one is for activating the camera screen in the app.
Both sliders and functions work independently.

### Hint

If the camera stream is stuck or something seems wrong, try to flip the phone (landscape).
If the device orientation changes, the stream will be restarted and therefore is a nice tool to reset if something went wrong.

## Lessons Learned

The LNdW went well and the app got accepted well.
A lot of people were interested in information about real world application of the app and if we tested it with real blind people.
Those were keen about further improvements, features and how it could be accepted for real users.
We also got good feedback on the yet basic concept of detection and signal processing (vibration on the VibroTac).
However, different users made different comments on the clarity of control (Vibro-tactile concept).
Some find it more intuitive to walk into the direction of the vibration rather than away from it.
Some turned around to avoid the obstacles rather than doing side steps.
### Future Work

1. Improve the vibration concept (pointing to/away from the obstacles)
2. Classify (react) to other object classes
3. Evaluation study of the guiding concept
4. Real Navigation rather than obstacle hints

## Credits

Thanks to Nora Koreuber *nora@koreuber.de* for implementing the main part of the object detection.
Special thanks to all the SHKs for their work @ LNDW.
Use-case implementation by Christopher Kümmel.
