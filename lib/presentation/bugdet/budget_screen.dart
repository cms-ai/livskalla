import 'package:app/gen/export.dart';
import 'package:app/presentation/bugdet/providers/budget_screen_extension.dart';
import 'package:app/presentation/common_views/common_date_picker.dart';
import 'package:app/presentation/exports.dart';
import 'package:app/utils/enums/enums.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class BudgetScreen extends HookConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Varibles listener
    ValueNotifier<TransactionCategoryEnum?> selectedCategory = useState(null);
    ValueNotifier<DateTime?> startDate = useState(null);
    ValueNotifier<bool> enableAddBtn = useState(false);
    late TextEditingController controller = useTextEditingController(text: "0");

    final size = MediaQuery.of(context).size;

    void checkEnableAddBtn() {
      int? moneyLimit = int.tryParse(controller.text.trim());
      if (![selectedCategory.value, startDate.value, moneyLimit]
              .contains(null) &&
          moneyLimit! > 0) {
        enableAddBtn.value = true;
      } else {
        enableAddBtn.value = false;
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: AppColors.bgColor1,
            ),
          ),
          Positioned(
            top: size.height * 0.9,
            left: size.width * 0.3,
            child: Container(
              width: 359.w,
              height: 849.h,
              decoration: BoxDecoration(
                color: AppColors.subColor1.withOpacity(.5),
                borderRadius: const BorderRadius.all(
                  Radius.elliptical(200, 500),
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 150.0, sigmaY: 150.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildAppBar(context),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "How much do yo want to spend?",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: AppColors.textColor1,
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      r"$",
                      style: TextStyle(
                        fontSize: 50.sp,
                        color: AppColors.textColor1,
                        fontFamily: FontFamily.poppins,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        style: TextStyle(
                          fontFamily: FontFamily.dMSans,
                          fontSize: 50.sp,
                          color: AppColors.textColor1,
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          hintText: "",
                          hintStyle: TextStyle(
                            fontFamily: FontFamily.dMSans,
                            fontSize: 50.sp,
                            color: AppColors.textColor1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (value) {
                          checkEnableAddBtn();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  // height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                  ),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonDropdownButton(
                        customMargin: const EdgeInsets.only(bottom: 14),
                        hintText: "Category",
                        items: TransactionCategoryEnum.toStringList(),
                        onChange: (p0, selectIndex) {
                          selectedCategory.value =
                              TransactionCategoryEnum.values[selectIndex];
                          checkEnableAddBtn();
                        },
                      ),
                      SizedBox(height: 10.h),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: CommonTextField(
                      //         customMargin: const EdgeInsets.only(bottom: 14),
                      //         readOnly: true,
                      //         controller: TextEditingController(
                      //             text: startDate.value != null
                      //                 ? AppDateTime.convertToDateTimeString(
                      //                     startDate
                      //                         .value!.millisecondsSinceEpoch)
                      //                 : ""),
                      //         hintText: "Date from",
                      //         textFieldStyle: TextFieldStyleEnum.border,
                      //         onTap: () {
                      //           CommonButtonSheet(
                      //             customChild: CommonDatePicker(
                      //               initialDateTime: startDate.value,
                      //               mode: CupertinoDatePickerMode.date,
                      //               onDateTimeChanged: (time) {
                      //                 startDate.value = time;
                      //                 checkEnableAddBtn();
                      //               },
                      //             ),
                      //           ).show(context);
                      //         },
                      //       ),
                      //     ),
                      //     SizedBox(width: 20.w),
                      //     Expanded(
                      //       child: GestureDetector(
                      //         onTap: () {},
                      //         child: CommonTextField(
                      //           customMargin: const EdgeInsets.only(bottom: 14),
                      //           readOnly: true,
                      //           hintText: "Date to",
                      //           controller: TextEditingController(
                      //               text: dateTo.value != null
                      //                   ? AppDateTime.convertToDateTimeString(
                      //                       dateTo
                      //                           .value!.millisecondsSinceEpoch)
                      //                   : ""),
                      //           textFieldStyle: TextFieldStyleEnum.border,
                      //           onTap: () {
                      //             CommonButtonSheet(
                      //               customChild: CommonDatePicker(
                      //                 initialDateTime: dateTo.value,
                      //                 mode: CupertinoDatePickerMode.date,
                      //                 onDateTimeChanged: (time) {
                      //                   dateTo.value = time;
                      //                   checkEnableAddBtn();
                      //                 },
                      //               ),
                      //             ).show(context);
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      CommonTextField(
                        customMargin: const EdgeInsets.only(bottom: 14),
                        readOnly: true,
                        controller: TextEditingController(
                            text: startDate.value != null
                                ? AppDateTime.convertToDateTimeString(
                                    startDate.value!.millisecondsSinceEpoch,
                                    dateFormat: DateFormat("MM/yyyy"),
                                  )
                                : ""),
                        hintText: "Date from",
                        textFieldStyle: TextFieldStyleEnum.border,
                        onTap: () {
                          CommonButtonSheet(
                            customChild: CommonDatePicker(
                              initialDateTime: startDate.value,
                              mode: CupertinoDatePickerMode.monthYear,
                              onDateTimeChanged: (time) {
                                startDate.value = time;
                                checkEnableAddBtn();
                              },
                            ),
                          ).show(context);
                        },
                      ),
                      SizedBox(height: 20.h),
                      CommonGradientButton(
                        customWidth: double.infinity,
                        contentButton: "Add",
                        customColor: enableAddBtn.value ? null : Colors.grey,
                        onTap: enableAddBtn.value
                            ? () {
                                handleAddBudget(
                                  ref,
                                  context,
                                  budgetName: selectedCategory.value!.name,
                                  startDate:
                                      startDate.value!.millisecondsSinceEpoch,
                                  maxMoney:
                                      int.tryParse(controller.text.trim()) ?? 0,
                                );
                              }
                            : null,
                      ),
                      SizedBox(height: 20.h)
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: AppColors.textColor1,
              ),
            ),
            Expanded(
              child: Text(
                "Create Budget",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textColor1,
                  fontSize: 18.sp,
                  fontFamily: FontFamily.syne,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
