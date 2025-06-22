import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/pet_provider.dart';
import '../widgets/pet_card.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../utils/responsive_helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortBy = 'Recent';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final petProvider = Provider.of<PetProvider>(context, listen: false);
      if (petProvider.filteredPets.isEmpty) {
        petProvider.loadPets();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    petProvider.searchPets(query);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FilterBottomSheet(),
    );
  }

  List<dynamic> _getSortedPets(List<dynamic> pets) {
    final sortedPets = List.from(pets);
    switch (_sortBy) {
      case 'Name A-Z':
        sortedPets.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Name Z-A':
        sortedPets.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'Price Low-High':
        sortedPets.sort((a, b) => a.adoptionFee.compareTo(b.adoptionFee));
        break;
      case 'Price High-Low':
        sortedPets.sort((a, b) => b.adoptionFee.compareTo(a.adoptionFee));
        break;
      case 'Age Young-Old':
        sortedPets.sort((a, b) => a.age.compareTo(b.age));
        break;
      case 'Age Old-Young':
        sortedPets.sort((a, b) => b.age.compareTo(a.age));
        break;
      case 'Recent':
      default:
        sortedPets.sort((a, b) => b.datePosted.compareTo(a.datePosted));
        break;
    }
    return sortedPets;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Find Pets',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.surfaceTint,
      ),
      body: Column(
        children: [
          _buildSearchAndFilter(context),
          _buildSortAndResults(context),
          Expanded(
            child: _buildPetGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by name, breed, or location...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainer,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showFilterBottomSheet,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.tune_rounded,
                    color: theme.colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortAndResults(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        final hasFilters = petProvider.filters.isNotEmpty || 
                          petProvider.searchQuery.isNotEmpty;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${petProvider.filteredPets.length} pets found',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    if (hasFilters)
                      Text(
                        'Filters applied',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasFilters)
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: OutlinedButton.icon(
                        onPressed: () {
                          petProvider.clearFilters();
                          _searchController.clear();
                        },
                        icon: const Icon(Icons.clear_all_rounded, size: 16),
                        label: const Text('Clear'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          side: BorderSide(
                            color: theme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  _buildSortButton(context),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) {
          setState(() {
            _sortBy = value;
          });
        },
        itemBuilder: (context) => [
          'Recent',
          'Name A-Z',
          'Name Z-A',
          'Price Low-High',
          'Price High-Low',
          'Age Young-Old',
          'Age Old-Young',
        ].map((option) {
          return PopupMenuItem<String>(
            value: option,
            child: Row(
              children: [
                if (_sortBy == option)
                  Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                if (_sortBy == option) const SizedBox(width: 8),
                Text(
                  option,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: _sortBy == option 
                        ? FontWeight.w600 
                        : FontWeight.normal,
                    color: _sortBy == option 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.sort_rounded,
                size: 18,
                color: theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 4),
              Text(
                'Sort',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetGrid(BuildContext context) {
    final theme = Theme.of(context);
    
    return Consumer<PetProvider>(
      builder: (context, petProvider, child) {
        if (petProvider.isLoading && petProvider.filteredPets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Finding pets...',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        final sortedPets = _getSortedPets(petProvider.filteredPets);

        if (sortedPets.isEmpty) {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(32),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.pets_outlined,
                    size: 64,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No pets found',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Try adjusting your filters or search criteria',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () {
                      petProvider.clearFilters();
                      _searchController.clear();
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Clear Filters'),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.getMaxContentWidth(context),
            ),
            child: Padding(
              padding: ResponsiveHelper.getScreenPadding(context),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context),
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: sortedPets.length,
                itemBuilder: (context, index) {
                  return PetCard(pet: sortedPets[index]);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}