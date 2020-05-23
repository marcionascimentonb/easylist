/// Author: Marcio deFreitasNascimento
/// Title: Easylist - App Mock Up
/// Date: 05/17/2020

abstract class BlocBase{

  /// This method should be implemented by the child class
  /// to close the StreamControllers in order to avoid memory leaks
  void dispose();
}