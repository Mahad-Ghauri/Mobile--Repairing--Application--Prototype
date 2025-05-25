import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_repairing_application__prototype/Components/custom_app_bar.dart';
import 'package:mobile_repairing_application__prototype/Components/shop_card.dart';
import 'package:mobile_repairing_application__prototype/models/shop_model.dart';
import 'package:mobile_repairing_application__prototype/Views/shops/shop_detail_screen.dart';

class ShopListingScreen extends StatefulWidget {
  const ShopListingScreen({Key? key}) : super(key: key);

  @override
  State<ShopListingScreen> createState() => _ShopListingScreenState();
}

class _ShopListingScreenState extends State<ShopListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Mock data for shops - in a real app, this would come from a service
  final List<Shop> _shops = [
    Shop(
      id: 1,
      name: 'Ghani Mobile Repair',
      address: 'Gardezi Market Multan, Pakistan',
      phone: '06123456789',
      description:
          'Fast and reliable mobile repair services. We specialize in screen replacements, battery replacements, and water damage repair.',
      imageUrl:
          'https://images.unsplash.com/photo-1581287053822-fd7bf4f4bfec?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
      rating: 4.8,
      services: ['Screen Repair', 'Battery Replacement', 'Water Damage'],
      ownerId: '1',
      isVerified: true,
    ),
    Shop(
      id: 2,
      name: 'Khan Mobile Services',
      address: 'Khan Market, Lahore, Pakistan',
      phone: '031020264989',
      description:
          'Professional repair services for all types of mobile devices. Same-day service available.',
      imageUrl:
          'https://images.unsplash.com/photo-1546027658-7aa750153465?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
      rating: 4.5,
      services: [
        'iPhone Repair',
        'Android Repair',
        'Tablet Repair',
        'Data Recovery'
      ],
      ownerId: '2',
    ),
    Shop(
      id: 3,
      name: 'Malik Phone Lab',
      address: 'Khan Plaza Multan, Pakistan',
      phone: '03001234567',
      description:
          'Expert phone repair with lifetime warranty. We fix all brands and models.',
      imageUrl:
          'https://images.unsplash.com/photo-1542744095-fcf48d80b0fd?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
      rating: 4.7,
      services: [
        'Screen Repair',
        'Battery Replacement',
        'Charging Port Repair'
      ],
      ownerId: '3',
      isVerified: true,
    ),
    Shop(
      id: 4,
      name: 'iPoint',
      address: 'lahore city center, pakistan',
      phone: '9231045689',
      description:
          'Specialized in Apple device repairs. Certified technicians and genuine parts.',
      imageUrl:
          'https://images.unsplash.com/photo-1551434678-e076c223a692?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
      rating: 4.9,
      services: ['iPhone Repair', 'iPad Repair', 'MacBook Repair'],
      ownerId: '4',
    ),
    Shop(
      id: 5,
      name: 'Multan Electronics Repair',
      address: 'Multan Electronics Market, Pakistan',
      phone: '06123456789',
      description:
          'Fast and affordable mobile repair services. Most repairs done in 30 minutes or less.',
      imageUrl:
          'https://images.unsplash.com/photo-1570126688035-1e6adbd61053?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60',
      rating: 4.3,
      services: ['Screen Repair', 'Battery Replacement', 'Software Issues'],
      ownerId: '5',
    ),
  ];

  List<Shop> get _filteredShops {
    if (_searchQuery.isEmpty) {
      return _shops;
    }
    return _shops.where((shop) {
      return shop.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          shop.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          shop.services.any((service) =>
              service.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Repair Shops',
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search shops, services, location...',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                  ),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),

          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', true),
                  _buildFilterChip('Screen Repair', false),
                  _buildFilterChip('Battery Replacement', false),
                  _buildFilterChip('Water Damage', false),
                  _buildFilterChip('Data Recovery', false),
                ],
              ),
            ),
          ),

          // Shop List
          Expanded(
            child: _filteredShops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No shops found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try a different search term',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredShops.length,
                    itemBuilder: (context, index) {
                      final shop = _filteredShops[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ShopCard(
                          shop: shop,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShopDetailScreen(shop: shop),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          // Implement filter logic
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Theme.of(context).primaryColor,
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
