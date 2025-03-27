import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ride/ride_filter.dart';
import '../../../provider/rides_preferences_provider.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onBackPressed(BuildContext context) {
    // Back to the previous view
    Navigator.of(context).pop();
  }

  Future<void> onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    // Update the current preference
    context.read<RidesPreferencesProvider>().setCurrentPreference(newPreference);

    // Navigate to the rides screen (with bottom-to-top animation)
    await Navigator.of(context).push(AnimationUtils.createBottomToTopRoute(const RidesScreen()));
  }

  Future<void> onPreferencePressed(BuildContext context) async {
    final provider = context.read<RidesPreferencesProvider>();
    final currentPreference = provider.currentPreference;

    // Open a modal to edit the ride preferences
    RidePreference? newPreference = await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // Update the current preference
      provider.setCurrentPreference(newPreference);
    }
  }

  void onFilterPressed() {
    // Implement filter logic here
  }

  List<Ride> getAvailableRides(RidePreference preference) {
    return RidesService.instance.getRidesFor(preference, RideFilter());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RidesPreferencesProvider>();
    final currentPreference = provider.currentPreference;
    final matchingRides = getAvailableRides(currentPreference!);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () => onPreferencePressed(context),
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) => RideTile(
                  ride: matchingRides[index],
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}