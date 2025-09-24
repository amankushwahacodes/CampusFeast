class Vendor {
  final String id;
  final String name;
  final String description;
  final String image;
  final String location;
  final bool isOpen;
  final double rating;
  final int reviewCount;
  final String openingHours;
  final VendorType type;
  final List<String> specialties;

  Vendor({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.location,
    required this.isOpen,
    required this.rating,
    required this.reviewCount,
    required this.openingHours,
    required this.type,
    required this.specialties,
  });
}

enum VendorType { canteen, stall, cafe, restaurant }

// Sample vendors data
final List<Vendor> sampleVendors = [
  Vendor(
    id: '1',
    name: 'Ballu Bhai Canteen',
    description: 'Authentic North Indian food with the best tea on campus',
    image: 'https://t3.ftcdn.net/jpg/06/29/07/22/360_F_629072294_l7NgGEUvrQOMJXqn10wpF4HGhrDfETOm.jpg',
    location: 'Main Building Ground Floor',
    isOpen: true,
    rating: 4.5,
    reviewCount: 234,
    openingHours: '7:00 AM - 8:00 PM',
    type: VendorType.canteen,
    specialties: ['Tea', 'Samosa', 'Paratha', 'Dal Rice'],
  ),
  Vendor(
    id: '2',
    name: 'South Corner Stall',
    description: 'Crispy dosas and authentic South Indian breakfast',
    image: 'https://pixabay.com/get/ga08de939dcc8023f9656ecbe2b1570bd905509df5347de88976d1868c844419863694d9f8edc8e2c16d83eddb613d2c1a429d7c8c1e73a048a7b7f9eef871c28_1280.jpg',
    location: 'Engineering Block Canteen',
    isOpen: true,
    rating: 4.3,
    reviewCount: 189,
    openingHours: '6:30 AM - 11:00 AM, 4:00 PM - 7:00 PM',
    type: VendorType.stall,
    specialties: ['Dosa', 'Idli', 'Vada', 'Sambhar'],
  ),
  Vendor(
    id: '3',
    name: 'Quick Bites Cafe',
    description: 'Fast food and quick snacks for busy students',
    image: 'https://pixabay.com/get/ga3ee3f3f776a0a8cbce52a83fb8a6f832216ac7d9ef936a9b0bb1542fc702f8db239c7f9e8384e4ee3f3291bb2e8fa93808860a234a51065d52545cebf661ff2_1280.jpg',
    location: 'Library Building',
    isOpen: false,
    rating: 4.1,
    reviewCount: 156,
    openingHours: '9:00 AM - 6:00 PM',
    type: VendorType.cafe,
    specialties: ['Sandwich', 'Burger', 'Fries', 'Cold Coffee'],
  ),
  Vendor(
    id: '4',
    name: 'Spicy Corner',
    description: 'Chinese and Indo-Chinese specialties',
    image: 'https://pixabay.com/get/g5b45123dff23cd9e98bf1db31cf95c8ab2103289d03cbc2e0bc1e75723b4d0c515109afd46ca17af4edae9074d0a38d0249f1e095b20dd24cc926a55d6e11376_1280.jpg',
    location: 'Hostel Block Canteen',
    isOpen: true,
    rating: 4.2,
    reviewCount: 278,
    openingHours: '11:00 AM - 10:00 PM',
    type: VendorType.stall,
    specialties: ['Noodles', 'Fried Rice', 'Manchurian', 'Momos'],
  ),
];