import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/models/constants.dart';
import 'package:stitch/network_services/user_management_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/bottom_sheet_selector.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/horizontal_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/utils/router_utils.dart';
import 'package:provider/provider.dart';

class SetPreferencesScreen extends StatefulWidget {
  const SetPreferencesScreen({super.key});

  @override
  State<SetPreferencesScreen> createState() => _SetPreferencesScreenState();
}

class _SetPreferencesScreenState extends State<SetPreferencesScreen> {
  int selectedGender = 0;
  int? selectedAgeRange;
  bool isUploadingPreferences = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.watch<UIColors>().surface,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0.05.sw),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const CustomAppBar(hasBackButton: false),
                  Text(
                    'Tell us about yourself',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  0.1.sw.verticalSpace,
                  Text(
                    'Who do you shop for?',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  0.05.sw.verticalSpace,
                  HorizontalPicker(
                    items: Gender.values.map((g) => g.name).toList(),
                    startingIndex: selectedGender,
                    onItemPicked: (index){
                      selectedGender = index;
                    },
                  ),
                  0.1.sw.verticalSpace,
                  Text(
                    'How old are you?',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  0.05.sw.verticalSpace,
                  BottomSheetSelector(
                    label: 'Age range',
                    items: AgeGroup.values.map((v) => v.name).toList(),
                    onItemSelected: (index){
                        selectedAgeRange = index;
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.05.sw),
              child: CustomWideButton(
                label: 'Finish',
                disabled: isUploadingPreferences,
                onTap: _uploadPreference
              ),
            )
          ],
        ),
      ),
    );
  }

  void _uploadPreference() async {
    setState(() {isUploadingPreferences = true;});
    final isSuccessful = await context.read<UserManagementService>()
      .updateProfile(
      gender: Gender.values[selectedGender],
      ageGroup: selectedAgeRange != null ? AgeGroup.values[selectedAgeRange!] : AgeGroup.youth,
    );
    if(isSuccessful && mounted){
      GoRouter.of(context).clearStackAndNavigate(RoutePaths.home);
    }
    setState(() {isUploadingPreferences = false;});
  }
}
