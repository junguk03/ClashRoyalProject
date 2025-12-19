import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final _currentIndex = 0.obs;
  late final PageController pageController;

  int get currentIndex => _currentIndex.value;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changePage(int index) {
    _currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPageChanged(int index) {
    _currentIndex.value = index;
  }
}
