class MenuItem {
  final String id;
  final String vendorId;
  final String name;
  final String description;
  final String image;
  final double price;
  final double? walletDiscount;
  final bool isAvailable;
  final bool isVegetarian;
  final ItemCategory category;
  final int preparationTime;

  MenuItem({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.walletDiscount,
    this.isAvailable = true,
    this.isVegetarian = true,
    required this.category,
    this.preparationTime = 10,
  });

  double get finalPrice => walletDiscount != null ? price - walletDiscount! : price;
}

enum ItemCategory { beverages, snacks, meals, desserts, fastFood }

// Sample menu items
final List<MenuItem> sampleMenuItems = [
  // Ballu Bhai Canteen items
  MenuItem(
    id: '1',
    vendorId: '1',
    name: 'Masala Tea',
    description: 'Hot and refreshing masala tea with perfect spice blend',
    image: 'https://pixabay.com/get/g019115e23d2bcc1932f736182fd228781e260f96c974a17d7979af09e90e9b4af473638deca9c5333873f5b0b0d30834b78e3bbc3077f83b1a325321faf3eff9_1280.jpg',
    price: 10.0,
    walletDiscount: 1.0,
    category: ItemCategory.beverages,
    preparationTime: 5,
  ),
  MenuItem(
    id: '2',
    vendorId: '1',
    name: 'Aloo Samosa',
    description: 'Crispy golden samosa filled with spiced potato',
    image: 'https://pixabay.com/get/gdbcad6acde791c5a5adeaf9f02aa1cb609e50fe2dd0cc2e02dfacf0478ed5b54034103864acbdf9080c565ef76c5b2fb07ef99112d05353647955a826c56198b_1280.jpg',
    price: 20.0,
    walletDiscount: 2.0,
    category: ItemCategory.snacks,
    preparationTime: 8,
  ),
  MenuItem(
    id: '3',
    vendorId: '1',
    name: 'Dal Rice',
    description: 'Homestyle dal with steamed rice and pickle',
    image: 'https://pixabay.com/get/ga99ba75deaf157b8d166045170acf1e187d63187ff2aacc3f5e745841bd9619ae6278e80601f70da2def782fe13576fb2e5f0fc4d97985f513c29f8c4c04136f_1280.jpg',
    price: 60.0,
    walletDiscount: 5.0,
    category: ItemCategory.meals,
    preparationTime: 15,
  ),
  
  // South Corner Stall items
  MenuItem(
    id: '4',
    vendorId: '2',
    name: 'Plain Dosa',
    description: 'Crispy South Indian crepe served with sambhar and chutney',
    image: 'https://pixabay.com/get/ga08de939dcc8023f9656ecbe2b1570bd905509df5347de88976d1868c844419863694d9f8edc8e2c16d83eddb613d2c1a429d7c8c1e73a048a7b7f9eef871c28_1280.jpg',
    price: 40.0,
    walletDiscount: 3.0,
    category: ItemCategory.meals,
    preparationTime: 12,
  ),
  MenuItem(
    id: '5',
    vendorId: '2',
    name: 'Masala Dosa',
    description: 'Dosa filled with spiced potato curry',
    image: 'https://pixabay.com/get/ga08de939dcc8023f9656ecbe2b1570bd905509df5347de88976d1868c844419863694d9f8edc8e2c16d83eddb613d2c1a429d7c8c1e73a048a7b7f9eef871c28_1280.jpg',
    price: 50.0,
    walletDiscount: 4.0,
    category: ItemCategory.meals,
    preparationTime: 15,
  ),

  // Quick Bites Cafe items
  MenuItem(
    id: '6',
    vendorId: '3',
    name: 'Veg Sandwich',
    description: 'Grilled sandwich with fresh vegetables and cheese',
    image: 'https://pixabay.com/get/ga3ee3f3f776a0a8cbce52a83fb8a6f832216ac7d9ef936a9b0bb1542fc702f8db239c7f9e8384e4ee3f3291bb2e8fa93808860a234a51065d52545cebf661ff2_1280.jpg',
    price: 45.0,
    walletDiscount: 3.0,
    category: ItemCategory.snacks,
    preparationTime: 10,
  ),
  MenuItem(
    id: '7',
    vendorId: '3',
    name: 'Veg Burger',
    description: 'Delicious vegetarian burger with crispy patty',
    image: 'https://pixabay.com/get/gd51567bab0da3b2cd0b02bb3afbc56a631b657a8ba5d18cbf69f0dd342ad6f650e561be1c8d590c08567497a82c8cb27117e00585ee6e5521a98a818b2b1f491_1280.jpg',
    price: 65.0,
    walletDiscount: 5.0,
    category: ItemCategory.fastFood,
    preparationTime: 15,
    isAvailable: false,
  ),

  // Spicy Corner items
  MenuItem(
    id: '8',
    vendorId: '4',
    name: 'Veg Hakka Noodles',
    description: 'Stir-fried noodles with fresh vegetables and sauces',
    image: 'https://pixabay.com/get/g5b45123dff23cd9e98bf1db31cf95c8ab2103289d03cbc2e0bc1e75723b4d0c515109afd46ca17af4edae9074d0a38d0249f1e095b20dd24cc926a55d6e11376_1280.jpg',
    price: 70.0,
    walletDiscount: 6.0,
    category: ItemCategory.meals,
    preparationTime: 18,
  ),
];