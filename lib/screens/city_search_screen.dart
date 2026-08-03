import 'dart:async';
import 'package:flutter/material.dart';
import '../models/city_model.dart';
import '../services/geocoding_api_service.dart';
import '../core/network/api_exceptions.dart';

enum ViewStatus { idle, loading, loaded, error }

class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final GeocodingApiService _geocodingService = GeocodingApiService();

  Timer? _debounce;
  ViewStatus _status = ViewStatus.idle;
  List<CityModel> _cities = [];
  String _errorMessage = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // كل مرة تكتب المستخدمة حرف، نلغي التايمر القديم ونبلش واحد جديد
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (query.trim().isEmpty) {
      setState(() {
        _status = ViewStatus.idle;
        _cities = [];
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchCities(query.trim());
    });
  }

  Future<void> _searchCities(String query) async {
    setState(() => _status = ViewStatus.loading);

    try {
      final results = await _geocodingService.searchCities(query);
      if (!mounted) return;
      setState(() {
        _cities = results;
        _status = ViewStatus.loaded;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
        _status = ViewStatus.error;
      });
    }
  }

  void _onCitySelected(CityModel city) {
    Navigator.pushNamed(
      context,
      '/home',
      arguments: {
        'cityName': city.name,
        'latitude': city.latitude,
        'longitude': city.longitude,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختر مدينتك')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'ابحث عن مدينة...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case ViewStatus.idle:
        return const Center(child: Text('ابدأي بالكتابة للبحث عن مدينة'));

      case ViewStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case ViewStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _searchCities(_searchController.text.trim()),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );

      case ViewStatus.loaded:
        if (_cities.isEmpty) {
          return const Center(child: Text('لا توجد نتائج'));
        }
        return ListView.builder(
          itemCount: _cities.length,
          itemBuilder: (context, index) {
            final city = _cities[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.location_on)),
                title: Text(city.name),
                subtitle: Text(city.country),
                onTap: () => _onCitySelected(city),
              ),
            );
          },
        );
    }
  }
}
