class OnboardingPageData {
  final String title;
  final String description;
  final String image;

  OnboardingPageData({
    required this.title,
    required this.description,
    required this.image,

  });

  factory OnboardingPageData.fromJson(Map<String, dynamic> json) {
    String rawImage = json['image'] ?? '';

    // Prepend base URL if not already full URL
    String fullImageUrl = rawImage.startsWith('http')
        ? rawImage
        : 'https://img.bookchor.com$rawImage';
    return OnboardingPageData(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: fullImageUrl,

    );
  }
}
