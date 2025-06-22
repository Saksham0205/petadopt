import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/pet.dart';
import '../providers/favorites_provider.dart';

class PetCard extends StatelessWidget {
  final Pet pet;
  final bool showFavoriteButton;

  const PetCard({
    super.key,
    required this.pet,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Opacity(
      opacity: pet.isAdopted ? 0.6 : 1.0,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: pet.isAdopted 
                ? theme.colorScheme.outline.withOpacity(0.3)
                : theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: pet.isAdopted ? null : () => context.push('/pet/${pet.id}'),
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(context),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: _buildPetInfo(context),
                        ),
                        const SizedBox(height: 4),
                        _buildLocationAndFee(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        Container(
            height: 140,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: pet.primaryImageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: pet.primaryImageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: theme.colorScheme.surfaceContainer,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: theme.colorScheme.surfaceContainer,
                        child: Icon(
                          Icons.pets_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : Container(
                      color: theme.colorScheme.surfaceContainer,
                      child: Icon(
                        Icons.pets_outlined,
                        size: 48,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
            ),
        ),
        if (showFavoriteButton) _buildFavoriteButton(context),
        _buildSpeciesBadge(context),
        if (pet.isAdopted) _buildAdoptedBadge(context),
      ],
    );
  }

  Widget _buildFavoriteButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return Positioned(
      top: 8,
      right: 8,
      child: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final isFavorite = favoritesProvider.isFavorite(pet.id);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => favoritesProvider.toggleFavorite(pet.id),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.outline.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isFavorite ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                  color: isFavorite ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant,
                  size: 18,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpeciesBadge(BuildContext context) {
    final theme = Theme.of(context);
    final speciesColor = _getSpeciesColor(theme);
    
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: speciesColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: speciesColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          pet.species,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.surface,
            fontSize: 10,
          ),
        ),
      ),
    );
  }

  Color _getSpeciesColor(ThemeData theme) {
    switch (pet.species.toLowerCase()) {
      case 'dog':
        return theme.colorScheme.primary;
      case 'cat':
        return theme.colorScheme.secondary;
      case 'bird':
        return theme.colorScheme.tertiary;
      default:
        return theme.colorScheme.primary;
    }
  }

  Widget _buildPetInfo(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          pet.name,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            fontSize: 12,
            height: 1.2, // Reduced line height
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1), // Further reduced
        Text(
          pet.breed,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 10,
            height: 1.2, // Reduced line height
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2), // Further reduced
        _buildPetDetails(context),
      ],
    );
  }

  Widget _buildPetDetails(BuildContext context) {
    final theme = Theme.of(context);
    
    return Wrap(
      spacing: 4, // Reduced spacing
      runSpacing: 2, // Reduced run spacing
      children: [
        _buildDetailChip(
          context,
          Icons.cake_outlined,
          pet.ageString,
          theme.colorScheme.primary.withOpacity(0.1),
          theme.colorScheme.primary,
        ),
        _buildDetailChip(
          context,
          pet.gender.toLowerCase() == 'male' 
              ? Icons.male_rounded 
              : Icons.female_rounded,
          pet.gender,
          theme.colorScheme.secondary.withOpacity(0.1),
          theme.colorScheme.secondary,
        ),
      ],
    );
  }

  Widget _buildDetailChip(
    BuildContext context,
    IconData icon,
    String label,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Further reduced
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4), // Smaller radius
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 8, // Smaller icon
            color: foregroundColor,
          ),
          const SizedBox(width: 2), // Reduced spacing
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
              fontSize: 8, // Smaller text
              height: 1.0, // Tighter line height
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationAndFee(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  pet.location,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            pet.adoptionFee > 0 ? '\$${pet.adoptionFee}' : 'Free',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 9,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdoptedBadge(BuildContext context) {
    final theme = Theme.of(context);
    
    return Positioned(
      bottom: 8,
      left: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.error.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.error.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Text(
          'Already Adopted',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onError,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
} 