import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabControllerX extends GetxController {
  var selectedIndex = 0.obs;

  void selectTab(int index) {
    selectedIndex.value = index;
  }
}

class CustomTabWidget extends StatelessWidget {
  final List<String> tabTitles;
  final TabControllerX controller;

  CustomTabWidget({
    Key? key,
    required this.tabTitles,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: List.generate(tabTitles.length, (index) {
            bool isSelected = controller.selectedIndex.value == index;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  controller.selectTab(index);
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.deepOrange : Colors.transparent,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabTitles[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
