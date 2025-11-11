import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class FilterDialog extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;
  final Function(Map<String, dynamic>)? onApply;

  const FilterDialog({
    Key? key,
    this.initialFilters,
    this.onApply,
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Filters'),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['All', 'SCHEDULED', 'DEPARTED', 'ARRIVED', 'CANCELLED']
                  .map((status) => FilterChip(
                        label: Text(status),
                        selected: _filters['status'] == status,
                        onSelected: (selected) {
                          setState(() {
                            _filters['status'] = selected ? status : null;
                          });
                        },
                      ))
                  .toList(),
            ),
            SizedBox(height: 16),
            Text(
              'Price Range',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            RangeSlider(
              values: RangeValues(
                (_filters['minPrice'] ?? 0).toDouble(),
                (_filters['maxPrice'] ?? 50000).toDouble(),
              ),
              min: 0,
              max: 50000,
              divisions: 100,
              labels: RangeLabels(
                '₹${_filters['minPrice'] ?? 0}',
                '₹${_filters['maxPrice'] ?? 50000}',
              ),
              onChanged: (values) {
                setState(() {
                  _filters['minPrice'] = values.start.toInt();
                  _filters['maxPrice'] = values.end.toInt();
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() => _filters.clear());
          },
          child: Text('Clear All'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onApply?.call(_filters);
            Navigator.pop(context, _filters);
          },
          child: Text('Apply'),
        ),
      ],
    );
  }

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    Map<String, dynamic>? initialFilters,
  }) {
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FilterDialog(initialFilters: initialFilters),
    );
  }
}
