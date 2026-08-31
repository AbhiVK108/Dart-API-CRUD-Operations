import 'package:crud_operations/app/data/models/user_details_model.dart';
import 'package:crud_operations/app/data/services/api_services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ApiServices api = ApiServices(); //access

  final users = <UserDetails>[].obs;
  
  final isLoading = false.obs;
  final errorText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUsers();
  }

  // GET
  Future<void> getUsers() async {
    try {
      isLoading.value = true;

      users.value = await api.getUsers();
    } catch (e) {
      errorText.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // POST
  Future<void> addUser(
    String name,
    String email,
    String phone,
  ) async {
    try {
      isLoading.value = true; //ui purpose

      final user = UserDetails(
        name: name,
        email: email,
        phone: phone,
      );

      final newUser = await api.createUser(user);
      

      users.add(newUser);

      Get.back();
      Get.snackbar('Success', 'User added');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // UPDATE
  Future<void> updateUser(
    UserDetails user,
    String name,
    String email,
    String phone,
  ) async {
    try {
      isLoading.value = true;

      final updatedUser = UserDetails(
        id: user.id,
        name: name,
        email: email,
        phone: phone,
      );

      await api.updateUser(updatedUser);

      final index = users.indexWhere(
        (item) => item.id == user.id,
      );

      users[index] = updatedUser;

      Get.back();
      Get.snackbar('Success', 'User updated');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // DELETE
  Future<void> deleteUser(UserDetails user) async {
    try {
      isLoading.value = true;

      await api.deleteUser(user.id!);

      users.remove(user);

      Get.snackbar('Success', 'User deleted');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }




}