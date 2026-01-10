import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/common_widgets.dart';

class AddressDetailsPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String initialAddress;

  const AddressDetailsPage({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.initialAddress,
  });

  @override
  State<AddressDetailsPage> createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _areaController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _landmarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addressController.text = widget.initialAddress;
  }

  @override
  void dispose() {
    _addressController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'latitude': widget.latitude,
        'longitude': widget.longitude,
        'address': _addressController.text.trim(),
        'area': _areaController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'pincode': _pincodeController.text.trim(),
        'landmark': _landmarkController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Complete Address'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Complete Address Details',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please provide complete information about your business location',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),

                // Full Address
                AppLabels.label(context, 'Full Address *'),
                const SizedBox(height: 8),
                AppTextFields.textField(
                  context: context,
                  hintText: 'Building name, street name',
                  controller: _addressController,
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Area
                AppLabels.label(context, 'Area/Locality *'),
                const SizedBox(height: 8),
                AppTextFields.textField(
                  context: context,
                  hintText: 'Enter area or locality',
                  controller: _areaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter area';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // City and State in a row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLabels.label(context, 'City *'),
                          const SizedBox(height: 8),
                          AppTextFields.textField(
                            context: context,
                            hintText: 'City',
                            controller: _cityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppLabels.label(context, 'State *'),
                          const SizedBox(height: 8),
                          AppTextFields.textField(
                            context: context,
                            hintText: 'State',
                            controller: _stateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Landmark (Optional)
                AppLabels.label(context, 'Landmark (Optional)'),
                const SizedBox(height: 8),
                AppTextFields.textField(
                  context: context,
                  hintText: 'Nearby landmark',
                  controller: _landmarkController,
                ),
                const SizedBox(height: 24),

                // Location coordinates display
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Lat: ${widget.latitude.toStringAsFixed(6)}, '
                          'Long: ${widget.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: AppButtons.primaryButton(
                    text: 'Save Address',
                    onPressed: _saveAddress,
                    isLoading: false,
                    context: context,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
