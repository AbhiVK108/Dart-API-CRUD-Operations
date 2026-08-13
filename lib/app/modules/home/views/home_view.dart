import 'package:crud_operations/app/data/models/user_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Operations'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: controller.getUsers,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      // =========================================================
      // ADD
      // =========================================================
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: Obx(() {
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorText.isNotEmpty && controller.users.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.errorText.value, textAlign: TextAlign.center),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: controller.getUsers,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.users.isEmpty) {
          return const Center(
            child: Text(
              'No users found.\nClick + to create a user.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.getUsers,

          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),

            itemCount: controller.users.length,

            itemBuilder: (context, index) {
              final UserDetails user = controller.users[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                child: ListTile(
                  // ===============================
                  // AVATAR
                  // ===============================
                  leading: CircleAvatar(
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    ),
                  ),

                  // ===============================
                  // NAME
                  // ===============================
                  title: Text(user.name.isEmpty ? 'No Name' : user.name),

                  // ===============================
                  // USER DETAILS
                  // ===============================
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.email.isEmpty ? 'No Email' : user.email),

                      Text(user.phone.isEmpty ? 'No Phone' : user.phone),
                    ],
                  ),

                  // ===============================
                  // ACTIONS
                  // ===============================
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showEditDialog(user);
                        },
                        icon: const Icon(Icons.edit),
                      ),

                      IconButton(
                        onPressed: () {
                          _showDeleteDialog(user);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  // ============================================================
  // ADD DIALOG
  // ============================================================

  void _showAddDialog() {
    final nameController = TextEditingController();

    final emailController = TextEditingController();

    final phoneController = TextEditingController();

    Get.defaultDialog(
      title: 'Add User',

      content: Column(
        children: [
          TextField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Name'),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Email'),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () {
                final String name = nameController.text.trim();

                final String email = emailController.text.trim();

                final String phone = phoneController.text.trim();

                if (name.isEmpty || email.isEmpty || phone.isEmpty) {
                  Get.snackbar('Validation', 'Please fill all fields');

                  return;
                }

                controller.addUser(name, email, phone);
              },
              child: const Text('Add User'),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UPDATE DIALOG
  // ============================================================

  void _showEditDialog(UserDetails user) {
    final nameController = TextEditingController(text: user.name);

    final emailController = TextEditingController(text: user.email);

    final phoneController = TextEditingController(text: user.phone);

    Get.defaultDialog(
      title: 'Update User',

      content: Column(
        children: [
          TextField(
            controller: nameController,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Name'),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Email'),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,

            child: ElevatedButton(
              onPressed: () {
                final String name = nameController.text.trim();

                final String email = emailController.text.trim();

                final String phone = phoneController.text.trim();

                if (name.isEmpty || email.isEmpty || phone.isEmpty) {
                  Get.snackbar('Validation', 'Please fill all fields');

                  return;
                }

                controller.updateUser(user, name, email, phone);
              },
              child: const Text('Update User'),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELETE DIALOG
  // ============================================================

  void _showDeleteDialog(UserDetails user) {
    Get.defaultDialog(
      title: 'Delete User',

      middleText: 'Are you sure you want to delete ${user.name}?',

      textCancel: 'Cancel',

      textConfirm: 'Delete',

      confirmTextColor: Colors.white,

      onConfirm: () {
        Get.back();

        controller.deleteUser(user);
      },
    );
  }
}
