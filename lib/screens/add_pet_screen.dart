import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';
import '../providers/pet_provider.dart';

class AddPetScreen extends StatefulWidget {
  const AddPetScreen({super.key});

  @override
  State<AddPetScreen> createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _colorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerContactController = TextEditingController();
  final _adoptionFeeController = TextEditingController();

  String _selectedSpecies = 'Dog';
  String _selectedGender = 'Male';
  String _selectedSize = 'Medium';
  bool _isVaccinated = false;
  bool _isNeutered = false;
  bool _isHouseTrained = false;
  bool _goodWithKids = false;
  bool _goodWithPets = false;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _colorController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _ownerNameController.dispose();
    _ownerContactController.dispose();
    _adoptionFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet for Adoption'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitForm,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('PUBLISH'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images Section
              _buildSectionTitle('Pet Photos'),
              _buildImagePicker(),
              const SizedBox(height: 24),

              // Basic Information
              _buildSectionTitle('Basic Information'),
              _buildBasicInfoSection(),
              const SizedBox(height: 24),

              // Physical Characteristics
              _buildSectionTitle('Physical Characteristics'),
              _buildPhysicalSection(),
              const SizedBox(height: 24),

              // Health & Behavior
              _buildSectionTitle('Health & Behavior'),
              _buildHealthBehaviorSection(),
              const SizedBox(height: 24),

              // Description
              _buildSectionTitle('Description'),
              _buildDescriptionSection(),
              const SizedBox(height: 24),

              // Contact Information
              _buildSectionTitle('Contact Information'),
              _buildContactSection(),
              const SizedBox(height: 24),

              // Adoption Fee
              _buildSectionTitle('Adoption Fee'),
              _buildAdoptionFeeSection(),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _submitForm,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.pets),
                  label: Text(_isLoading ? 'Publishing...' : 'Publish Pet'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate,
                size: 48,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                'Photo Upload',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
              Text(
                'Feature coming soon',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Pet Name *',
                hintText: 'Enter pet name',
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Please enter pet name' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSpecies,
              decoration: const InputDecoration(labelText: 'Species *'),
              items: ['Dog', 'Cat', 'Bird', 'Rabbit', 'Other']
                  .map((species) => DropdownMenuItem(
                        value: species,
                        child: Text(species),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedSpecies = value!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(
                labelText: 'Breed *',
                hintText: 'Enter breed',
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Please enter breed' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age (months) *',
                      hintText: 'e.g., 24',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) =>
                        value?.isEmpty == true ? 'Please enter age' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: const InputDecoration(labelText: 'Gender *'),
                    items: ['Male', 'Female']
                        .map((gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedGender = value!),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedSize,
                    decoration: const InputDecoration(labelText: 'Size *'),
                    items: ['Small', 'Medium', 'Large']
                        .map((size) => DropdownMenuItem(
                              value: size,
                              child: Text(size),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedSize = value!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg) *',
                      hintText: 'e.g., 15.5',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty == true ? 'Please enter weight' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: 'Color *',
                hintText: 'e.g., Brown and White',
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Please enter color' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthBehaviorSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CheckboxListTile(
              title: const Text('Vaccinated'),
              value: _isVaccinated,
              onChanged: (value) => setState(() => _isVaccinated = value!),
            ),
            CheckboxListTile(
              title: const Text('Neutered/Spayed'),
              value: _isNeutered,
              onChanged: (value) => setState(() => _isNeutered = value!),
            ),
            CheckboxListTile(
              title: const Text('House Trained'),
              value: _isHouseTrained,
              onChanged: (value) => setState(() => _isHouseTrained = value!),
            ),
            CheckboxListTile(
              title: const Text('Good with Kids'),
              value: _goodWithKids,
              onChanged: (value) => setState(() => _goodWithKids = value!),
            ),
            CheckboxListTile(
              title: const Text('Good with Other Pets'),
              value: _goodWithPets,
              onChanged: (value) => setState(() => _goodWithPets = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description *',
            hintText: 'Tell us about this pet\'s personality, habits, and any special needs...',
            border: InputBorder.none,
          ),
          maxLines: 5,
          validator: (value) =>
              value?.isEmpty == true ? 'Please enter description' : null,
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location *',
                hintText: 'City, State',
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Please enter location' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ownerNameController,
              decoration: const InputDecoration(
                labelText: 'Your Name *',
                hintText: 'Enter your name',
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _ownerContactController,
              decoration: const InputDecoration(
                labelText: 'Contact Information *',
                hintText: 'Phone number or email',
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Please enter contact information' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdoptionFeeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          controller: _adoptionFeeController,
          decoration: const InputDecoration(
            labelText: 'Adoption Fee (\$) *',
            hintText: 'Enter adoption fee',
            prefixText: '\$ ',
          ),
          keyboardType: TextInputType.number,
          validator: (value) =>
              value?.isEmpty == true ? 'Please enter adoption fee' : null,
        ),
      ),
    );
  }



  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Note: Image functionality will be added later

    setState(() {
      _isLoading = true;
    });

    try {
      final pet = Pet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        species: _selectedSpecies,
        breed: _breedController.text.trim(),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        size: _selectedSize,
        weight: double.parse(_weightController.text),
        color: _colorController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrls: ['https://via.placeholder.com/400x300/FFE0E6/8B5A6B?text=No+Image'],
        location: _locationController.text.trim(),
        ownerName: _ownerNameController.text.trim(),
        ownerContact: _ownerContactController.text.trim(),
        ownerEmail: _ownerContactController.text.trim(),
        datePosted: DateTime.now(),
        adoptionFee: double.parse(_adoptionFeeController.text),
        isVaccinated: _isVaccinated,
        isNeutered: _isNeutered,
        isHouseTrained: _isHouseTrained,
        goodWithKids: _goodWithKids,
        goodWithPets: _goodWithPets,
      );

      await context.read<PetProvider>().addPet(pet);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pet published successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error publishing pet: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
} 