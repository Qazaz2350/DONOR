class AdminMenuItem {
  final String title;
  final String
  iconName; // optional if needed, we can map to IconData in ViewModel
  final int id;

  AdminMenuItem({required this.title, required this.id, this.iconName = ""});
}
