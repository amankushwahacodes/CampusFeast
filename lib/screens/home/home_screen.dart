import 'package:flutter/material.dart';
import 'package:campus_feast/models/vendor.dart';
import 'package:campus_feast/screens/vendor/vendor_menu_screen.dart';
import 'package:campus_feast/widgets/vendor_card.dart';
import 'package:campus_feast/widgets/quick_stats_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchQuery = '';
  VendorType? selectedFilter;

  List<Vendor> get filteredVendors {
    var vendors = sampleVendors;
    
    if (searchQuery.isNotEmpty) {
      vendors = vendors.where((vendor) =>
          vendor.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          vendor.specialties.any((s) => s.toLowerCase().contains(searchQuery.toLowerCase()))).toList();
    }
    
    if (selectedFilter != null) {
      vendors = vendors.where((vendor) => vendor.type == selectedFilter).toList();
    }
    
    return vendors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning!',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Rahul Kumar',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats
            const QuickStatsWidget(),
            
            const SizedBox(height: 16),
            
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search vendors or food...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                onChanged: (value) {
                  setState(() => searchQuery = value);
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Filter Chips
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: selectedFilter == null,
                    onSelected: (selected) {
                      setState(() => selectedFilter = null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ...VendorType.values.map((type) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_getVendorTypeLabel(type)),
                      selected: selectedFilter == type,
                      onSelected: (selected) {
                        setState(() => selectedFilter = selected ? type : null);
                      },
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Vendors Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Available Vendors',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${filteredVendors.length} found',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Vendors List
            if (filteredVendors.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No vendors found',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search or filters',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredVendors.length,
                itemBuilder: (context, index) {
                  final vendor = filteredVendors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: VendorCard(
                      vendor: vendor,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VendorMenuScreen(vendor: vendor),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  String _getVendorTypeLabel(VendorType type) {
    switch (type) {
      case VendorType.canteen:
        return 'Canteen';
      case VendorType.stall:
        return 'Stall';
      case VendorType.cafe:
        return 'Cafe';
      case VendorType.restaurant:
        return 'Restaurant';
    }
  }
}