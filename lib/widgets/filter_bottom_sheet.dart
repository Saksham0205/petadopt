import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pet_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;

  @override
  void initState() {
    super.initState();
    final petProvider = Provider.of<PetProvider>(context, listen: false);
    _filters = Map.from(petProvider.filters);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          _buildHandle(context),
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSpeciesFilter(),
                  const SizedBox(height: 32),
                  _buildSizeFilter(),
                  const SizedBox(height: 32),
                  _buildAgeFilter(),
                  const SizedBox(height: 32),
                  _buildGenderFilter(),
                  const SizedBox(height: 32),
                  _buildAdoptionFeeFilter(),
                  const SizedBox(height: 32),
                  _buildHealthFilters(),
                  const SizedBox(height: 32),
                  _buildBehaviorFilters(),
                ],
              ),
            ),
          ),
          _buildBottomActions(context),
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Filter Pets',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeciesFilter() {
    return _buildFilterSection(
      'Species',
      ['Dog', 'Cat', 'Bird', 'Other'],
      'species',
    );
  }

  Widget _buildSizeFilter() {
    return _buildFilterSection(
      'Size',
      ['Small', 'Medium', 'Large'],
      'size',
    );
  }

  Widget _buildAgeFilter() {
    return _buildFilterSection(
      'Age',
      ['Young', 'Adult', 'Senior'],
      'age',
    );
  }

  Widget _buildGenderFilter() {
    return _buildFilterSection(
      'Gender',
      ['Male', 'Female'],
      'gender',
    );
  }

  Widget _buildFilterSection(String title, List<String> options, String key) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final isSelected = _filters[key] == option;
            return FilterChip(
              selected: isSelected,
              label: Text(
                option,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isSelected 
                      ? theme.colorScheme.onPrimary 
                      : theme.colorScheme.onSurface,
                ),
              ),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _filters[key] = option;
                  } else {
                    _filters.remove(key);
                  }
                });
              },
              backgroundColor: theme.colorScheme.surfaceContainer,
              selectedColor: theme.colorScheme.primary,
              checkmarkColor: theme.colorScheme.onPrimary,
              side: BorderSide(
                color: isSelected 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.outline.withOpacity(0.5),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAdoptionFeeFilter() {
    final theme = Theme.of(context);
    final currentMaxFee = _filters['maxAdoptionFee']?.toDouble() ?? 500.0;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maximum Adoption Fee',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '\$${currentMaxFee.toInt()}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: theme.colorScheme.primary,
            inactiveTrackColor: theme.colorScheme.outline.withOpacity(0.3),
            thumbColor: theme.colorScheme.primary,
            overlayColor: theme.colorScheme.primary.withOpacity(0.1),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: Slider(
            value: currentMaxFee,
            min: 0,
            max: 500,
            divisions: 10,
            onChanged: (value) {
              setState(() {
                _filters['maxAdoptionFee'] = value;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '\$500',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHealthFilters() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Status',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _buildSwitchTile(
          'Vaccinated',
          Icons.medical_information_outlined,
          'isVaccinated',
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          'Spayed/Neutered',
          Icons.pets_outlined,
          'isSpayedNeutered',
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          'Health Checked',
          Icons.health_and_safety_outlined,
          'isHealthChecked',
        ),
      ],
    );
  }

  Widget _buildBehaviorFilters() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Behavior',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        _buildSwitchTile(
          'Good with Kids',
          Icons.child_care_outlined,
          'goodWithKids',
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          'Good with Pets',
          Icons.pets_outlined,
          'goodWithPets',
        ),
        const SizedBox(height: 12),
        _buildSwitchTile(
          'House Trained',
          Icons.home_outlined,
          'isHouseTrained',
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, IconData icon, String key) {
    final theme = Theme.of(context);
    final isSelected = _filters[key] == true;
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: Switch(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              if (value) {
                _filters[key] = true;
              } else {
                _filters.remove(key);
              }
            });
          },
          activeColor: theme.colorScheme.primary,
          activeTrackColor: theme.colorScheme.primary.withOpacity(0.3),
          inactiveThumbColor: theme.colorScheme.outline,
          inactiveTrackColor: theme.colorScheme.outline.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    final theme = Theme.of(context);
    final hasFilters = _filters.isNotEmpty;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (hasFilters)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _filters.clear();
                  });
                },
                icon: const Icon(Icons.clear_all_rounded),
                label: const Text('Clear All'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          if (hasFilters) const SizedBox(width: 16),
          Expanded(
            flex: hasFilters ? 2 : 1,
            child: FilledButton.icon(
              onPressed: () {
                final petProvider = Provider.of<PetProvider>(context, listen: false);
                petProvider.applyFilters(_filters);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_rounded),
              label: Text('Apply${hasFilters ? ' (${_filters.length})' : ''}'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 