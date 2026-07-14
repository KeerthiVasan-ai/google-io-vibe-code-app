import 'package:flutter/material.dart';
import '../models/issue_report.dart';
import '../widgets/issue_card.dart';
import 'report_issue_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data
  final List<IssueReport> _issues = [
    IssueReport(
      id: '1',
      title: 'Pothole on Main St',
      description: 'Large pothole causing damage to vehicles.',
      category: 'Road Maintenance',
      status: 'Pending',
      dateReported: DateTime.now().subtract(const Duration(hours: 2)),
      location: '123 Main St, City Center',
    ),
    IssueReport(
      id: '2',
      title: 'Flooded Underpass',
      description: 'The underpass is completely flooded after the heavy rain. Impassable for small cars.',
      category: 'Flooding',
      status: 'In Progress',
      dateReported: DateTime.now().subtract(const Duration(days: 1)),
      location: 'Oak Ave Underpass',
    ),
    IssueReport(
      id: '3',
      title: 'Broken Streetlight',
      description: 'Streetlight is flickering and sometimes turns off completely.',
      category: 'Utility Failure',
      status: 'Resolved',
      dateReported: DateTime.now().subtract(const Duration(days: 3)),
      location: '45 Pine Lane',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Issues', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).colorScheme.primary, const Color(0xFF0077B6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // Add filter functionality
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _issues.isEmpty
          ? const Center(child: Text('No issues reported nearby.'))
          : ListView.builder(
              itemCount: _issues.length,
              itemBuilder: (context, index) {
                return IssueCard(issue: _issues[index]);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportIssueScreen()),
          ).then((newIssue) {
            if (newIssue != null && newIssue is IssueReport) {
              setState(() {
                _issues.insert(0, newIssue);
              });
            }
          });
        },
        icon: const Icon(Icons.upload_file),
        label: const Text('Report Issue'),
      ),
    );
  }
}
