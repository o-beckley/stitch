import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stitch/config/route_paths.dart';
import 'package:stitch/widgets/app_bar.dart';
import 'package:stitch/widgets/buttons.dart';
import 'package:stitch/widgets/drop_down_menu.dart';
import 'package:stitch/widgets/picker.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch/utils/router_utils.dart';

class SetPreferencesScreen extends StatefulWidget {
  const SetPreferencesScreen({super.key});

  @override
  State<SetPreferencesScreen> createState() => _SetPreferencesScreenState();
}

class _SetPreferencesScreenState extends State<SetPreferencesScreen> {
  int selectedGender = 0;
  final genders = ['Male', 'Female'];
  int selectedAgeRange = 0;
  final  ageRanges = [
    '3 - 5',
    '5 - 12',
    '12 - 18',
    '18 - 40',
    '40 - 65',
    'Above 65'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Picker(
                    items: genders,
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
                  CustomDropDownMenu(
                    isExpanded: true,
                    label: 'Age range',
                    items: ageRanges,
                    onItemSelected: (index){
                      selectedAgeRange = index;
                    },
                  )
                  // TODO: age picker
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0.05.sw),
              child: CustomWideButton(
                label: 'Finish',
                onTap: (){
                  // TODO: upload preference then:
                  GoRouter.of(context).clearStackAndNavigate(RoutePaths.home);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
