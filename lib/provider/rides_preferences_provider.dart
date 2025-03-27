import 'package:flutter/material.dart';
import '../model/ride/ride_pref.dart';
import '../repository/ride_preferences_repository.dart';
import 'async_value.dart'; 

/// This provider manages the ride preferences data:
/// - Holds the current ride preference
/// - Fetches and stores past ride preferences
class RidesPreferencesProvider extends ChangeNotifier {
  RidePreference? _currentPreference; 
  late AsyncValue<List<RidePreference>> pastPreferences; 

  final RidePreferencesRepository repository;

  /// Constructor: Fetch past preferences when the provider is initialized
  RidesPreferencesProvider({required this.repository}) {
    fetchPastPreferences();
  }

  /// Getter to retrieve the current ride preference
  RidePreference? get currentPreference => _currentPreference;

  /// Updates the current ride preference
  void setCurrentPreference(RidePreference pref) {
    if (_currentPreference != pref) { 
      _currentPreference = pref;
      _addPreference(pref); 
      notifyListeners(); 
    }
  }

  /// Fetches past ride preferences from the repository
  Future<void> fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading(); // Set loading state
    notifyListeners(); 

    try {
      List<RidePreference> pastPrefs = await repository.getPastPreferences(); // Fetch data from repository
      pastPreferences = AsyncValue.success(pastPrefs); // Store successful data
    } catch (error) {
      pastPreferences = AsyncValue.error(error); // Handle errors
    }
    notifyListeners();
  }

  /// Adds a new ride preference to the repository and updates past preferences
  Future<void> _addPreference(RidePreference preference) async {
    await repository.addPreference(preference); 
    fetchPastPreferences(); // Fetch updated list of past preferences (ensuring sync with stored data)
  }

  /// Returns the list of past ride preferences, or an empty list if data isn't available
  List<RidePreference> get preferencesHistory => pastPreferences.data ?? [];
}
