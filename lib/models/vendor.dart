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
    image: 'https://t4.ftcdn.net/jpg/02/74/99/21/360_F_274992194_1MDSPiaalQe5Rx26IotuQ0j4TieiMROE.jpg',
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
    image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f2/Infosys.Electronic.City.Cafeteria.JPG/960px-Infosys.Electronic.City.Cafeteria.JPG',
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
    image: 'https://5.imimg.com/data5/SELLER/Default/2024/2/389847446/ZV/FB/ED/181942627/school-canteen-service.jpg',
    location: 'Hostel Block Canteen',
    isOpen: true,
    rating: 4.2,
    reviewCount: 278,
    openingHours: '11:00 AM - 10:00 PM',
    type: VendorType.stall,
    specialties: ['Noodles', 'Fried Rice', 'Manchurian', 'Momos'],
  ),
];