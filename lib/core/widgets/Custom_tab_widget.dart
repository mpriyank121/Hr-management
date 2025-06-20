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
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: List.generate(tabTitles.length, (index) {
            bool isSelected = controller.selectedIndex.value == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectTab(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 250),
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.deepOrange : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    tabTitles[index],
                    style: TextStyle(
                      color: isSelected ? Colors.grey.shade300 : Colors.deepOrange,
                      fontWeight: FontWeight.w600,
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
