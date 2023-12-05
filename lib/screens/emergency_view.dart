// emergency_view.dart

import 'package:flutter/material.dart';
import '../controllers/emergency.dart';

class EmergencyView extends StatelessWidget {
  final EmergencyController controller;

  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final emailController = TextEditingController();

  EmergencyView({Key? key, required this.controller}) : super(key: key);
  // Function to clear form fields
  void clearFields() {
    typeController.clear();
    nameController.clear();
    emailController.clear();
  }

  // Function to show success dialogue
  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Emergency submitted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialogue
                // You can add additional actions if needed
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Emergency',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Card(
                elevation: 4.0,
                // Set card color to white
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    autovalidateMode:
                        AutovalidateMode.onUserInteraction, // Add this line
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Submit your emergency ',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 10),
                        const Text(
                          "Please enter your details",
                          style: TextStyle(color: Colors.green),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          onChanged: (value) =>
                              controller.type.text = value as String,
                          decoration: InputDecoration(
                            labelText: 'Type of Emergency',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the type of emergency';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          onChanged: (value) =>
                              controller.name.text = value as String,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter name here',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          onChanged: (value) =>
                              controller.email.text = value as String,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter email here',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a email';
                            }
                            return null;
                          },
                        ),

                        /* TextFormField(
                          readOnly: true,
                          controller: timeController,
                          decoration: InputDecoration(
                            labelText: 'Time of Incident',
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            TimeOfDay? selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (selectedTime != null) {
                              String formattedTime =
                                  selectedTime.format(context);
                              timeController.text = formattedTime;
                              controller.updateTime(selectedTime);
                            }
                          },
                          validator: (value) {
                            // Add this block
                            if (value == null || value.isEmpty) {
                              return 'Please enter the time of incident';
                            }
                            return null;
                          },
                        ),*/
                        SizedBox(height: 40.0),
                        ElevatedButton(
                          onPressed: () async {
                            await controller
                                .submitEmergency(); // Wait for submission
                            showSuccessDialog(context);
                            clearFields(); // Clear form fields // Call success dialogue
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .green, // Set button background color to green
                              foregroundColor: Colors.white),
                          child: Text(
                            'Submit Emergency',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32.0),
            ],
          ),
        ),
      ),
    );
  }
}

void clearFields() {}
