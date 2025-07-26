import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationInputField extends StatefulWidget {
  final String selectedLocation;
  final Function(String) onLocationSelected;

  const LocationInputField({
    super.key,
    required this.selectedLocation,
    required this.onLocationSelected,
  });

  @override
  State<LocationInputField> createState() => _LocationInputFieldState();
}

class _LocationInputFieldState extends State<LocationInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _showSuggestions = false;

  final List<String> _suggestions = [
    'Delhi',
    'Mumbai',
    'Bangalore',
    'Chennai',
    'Kolkata',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Jaipur',
    'Surat',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Thane',
    'Bhopal',
    'Visakhapatnam',
    'Pimpri-Chinchwad',
    'Patna',
    'Vadodara',
  ];

  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.selectedLocation;
    _filteredSuggestions = _suggestions;
  }

  void _filterSuggestions(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredSuggestions = _suggestions;
        _showSuggestions = false;
      } else {
        _filteredSuggestions = _suggestions
            .where(
              (location) =>
                  location.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        _showSuggestions = _filteredSuggestions.isNotEmpty;
      }
    });
  }

  void _selectLocation(String location) {
    setState(() {
      _controller.text = location;
      _showSuggestions = false;
    });
    widget.onLocationSelected(location);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter Your Location",
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.onSurfacePrimary,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          "This helps us create content relevant to your local area",
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.onSurfaceSecondary,
          ),
        ),
        SizedBox(height: 2.h),
        TextField(
          controller: _controller,
          onChanged: (value) {
            _filterSuggestions(value);
            widget.onLocationSelected(value);
          },
          onTap: () {
            setState(() {
              _showSuggestions = _filteredSuggestions.isNotEmpty;
            });
          },
          decoration: InputDecoration(
            hintText: "e.g., Delhi, Mumbai, Bangalore...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            filled: true,
            fillColor: AppTheme.lightTheme.colorScheme.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 4.w,
              vertical: 2.h,
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.onSurfaceSecondary,
                size: 5.w,
              ),
            ),
          ),
          style: AppTheme.lightTheme.textTheme.bodyLarge,
        ),
        if (_showSuggestions) ...[
          SizedBox(height: 1.h),
          Container(
            constraints: BoxConstraints(maxHeight: 20.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _filteredSuggestions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline.withValues(
                  alpha: 0.3,
                ),
              ),
              itemBuilder: (context, index) {
                final location = _filteredSuggestions[index];
                return ListTile(
                  dense: true,
                  leading: CustomIconWidget(
                    iconName: 'location_city',
                    color: AppTheme.onSurfaceSecondary,
                    size: 4.w,
                  ),
                  title: Text(
                    location,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  onTap: () => _selectLocation(location),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
