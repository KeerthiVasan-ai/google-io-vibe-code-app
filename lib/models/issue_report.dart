class IssueReport {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status; // Pending, In Progress, Resolved
  final DateTime dateReported;
  final String? imageUrl;
  final String location;

  IssueReport({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.dateReported,
    this.imageUrl,
    required this.location,
  });
}
