class OnboardingPageData {
  final String image, title, description;

  OnboardingPageData({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnboardingPageData> onboardingPages = [
  OnboardingPageData(
    image: 'assets/images/management_image.png',
    title: 'Track Employee Attendance',
    description: 'Easily monitor who’s clocked in, who’s on leave, and who’s yet to check in—all in real-time. Stay informed and manage your team more efficiently.',
  ),
  OnboardingPageData(
    image: 'assets/images/salary_image.png',
    title: 'Simplify Payroll',
    description: 'View, manage, and process employee salaries in one place. Get a quick overview of total payouts and individual earnings with ease.',
  ),
  OnboardingPageData(
    image: 'assets/images/manage_employee_image.png',
    title: 'Organize Your Workforce',
    description: 'Manage departments, view employee status, and track your team’s structure. Stay on top of hiring types and department distribution at a glance.',
  ),
];
