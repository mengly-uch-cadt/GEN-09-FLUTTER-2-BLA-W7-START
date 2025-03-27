import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../../provider/rides_preferences_provider.dart';
import '../../../provider/async_value.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';
 
///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference
    context.read<RidesPreferencesProvider>().setCurrentPreference(newPreference);
    
    // 2 - Navigate to the rides screen (with bottom-to-top animation)
    await Navigator.of(context).push(AnimationUtils.createBottomToTopRoute(const RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RidesPreferencesProvider>();
    final currentRidePreference = provider.currentPreference;
    final pastPreferences = provider.pastPreferences;

    return Stack(
      children: [
        // 1 - Background  Image
        BlaBackground(), 

        // 2 - Foreground content
        Column(
          children: [
            SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 2.1 Display the Form to input the ride preferences
                  RidePrefForm(
                    initialPreference: currentRidePreference,
                    onSubmit: (pref) => onRidePrefSelected(context, pref),
                  ),
                  SizedBox(height: BlaSpacings.m),

                  // 2.2 Display the list of past entered ride preferences
                  if (pastPreferences.isLoading)
                    Center(child: CircularProgressIndicator())
                  else if (pastPreferences.error != null)
                    Center(child: Text('No connection. Try later'))
                  else
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: pastPreferences.data?.length ?? 0,
                        itemBuilder: (ctx, index) => RidePrefHistoryTile(
                          ridePref: pastPreferences.data![index],
                          onPressed: () => onRidePrefSelected(context, pastPreferences.data![index]),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}