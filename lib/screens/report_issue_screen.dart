import 'package:flutter/material.dart';
import '../models/issue_report.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController(text: 'Current Location');
  
  String _detectedCategory = 'Analyzing...';
  bool _isAnalyzing = false;
  bool _imageSelected = false;

  void _simulateImageCapture() {
    setState(() {
      _imageSelected = true;
      _isAnalyzing = true;
    });
    
    // Simulate AI categorization delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          // Mock AI result based on text description
          if (_descController.text.toLowerCase().contains('water') || 
              _descController.text.toLowerCase().contains('flood')) {
            _detectedCategory = 'Flooding';
          } else if (_descController.text.toLowerCase().contains('road') || 
                     _descController.text.toLowerCase().contains('pothole')) {
            _detectedCategory = 'Road Maintenance';
          } else {
            _detectedCategory = 'General Issue';
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('AI categorized issue as: $_detectedCategory')),
        );
      }
    });
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      if (!_imageSelected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add a photo first')),
        );
        return;
      }
      
      final newReport = IssueReport(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descController.text,
        category: _detectedCategory == 'Analyzing...' ? 'General Issue' : _detectedCategory,
        status: 'Pending',
        dateReported: DateTime.now(),
        location: _locationController.text,
      );
      
      Navigator.pop(context, newReport);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Report'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Photo Area
            GestureDetector(
              onTap: _simulateImageCapture,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                child: _imageSelected 
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Icon(Icons.image, size: 80, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)),
                          if (_isAnalyzing)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(color: Colors.white),
                                    SizedBox(height: 16),
                                    Text('AI Analyzing Photo...', style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                            )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file, size: 48, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to upload a photo',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            
            // AI Category Tag
            if (_imageSelected && !_isAnalyzing)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Suggested Category',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            _detectedCategory,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Allow manual override
                      },
                      child: const Text('EDIT'),
                    ),
                  ],
                ),
              ),
              
            const SizedBox(height: 24),
            
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Issue Title',
                hintText: 'e.g., Deep pothole on 5th Ave',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe the issue in detail...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Getting current location...')),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).colorScheme.primary, const Color(0xFF0077B6)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              ),
              child: ElevatedButton(
                onPressed: _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('SUBMIT REPORT', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
