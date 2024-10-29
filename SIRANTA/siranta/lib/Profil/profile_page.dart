import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        leading: Icon(Icons.arrow_back, color: Colors.white),
        title: Text('Profil', style: TextStyle(color: Colors.white)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: constraints.maxWidth > 600 ? 300 : 200,
                      color: Colors.blue[600],
                    ),
                    Column(
                      children: [
                        SizedBox(height: 16),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: constraints.maxWidth > 600 ? 72 : 48,
                              backgroundImage: NetworkImage(
                                  'https://storage.googleapis.com/a1aa/image/L4iBcfg3zZT8DiKGjiwqVAgHPbKfObreIjtbCPo91uASOeQOB.jpg'),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 16,
                                child: Icon(Icons.edit,
                                    color: Colors.blue[600], size: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Libryan Adetya',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: constraints.maxWidth > 600 ? 24 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '21093712047102',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildOption(
                                icon: Icons.edit,
                                text: 'Edit Profil',
                                onTap: () {},
                              ),
                              _buildOption(
                                icon: Icons.lock,
                                text: 'Ganti Kata Sandi',
                                onTap: () {},
                              ),
                              _buildOption(
                                icon: Icons.delete,
                                text: 'Hapus Akun',
                                onTap: () {},
                              ),
                              _buildOption(
                                icon: Icons.exit_to_app,
                                text: 'Keluar',
                                textColor: Colors.red,
                                iconColor: Colors.red,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.red),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.blue),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String text,
    Color textColor = Colors.black,
    Color iconColor = Colors.grey,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                SizedBox(width: 8),
                Text(text, style: TextStyle(color: textColor)),
              ],
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}


//backend dibawah (belum ada api)

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         backgroundColor: Colors.blue[600],
//         leading: Icon(Icons.arrow_back, color: Colors.white),
//         title: Text('Profil', style: TextStyle(color: Colors.white)),
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             child: Column(
//               children: [
//                 Stack(
//                   children: [
//                     Container(
//                       height: constraints.maxWidth > 600 ? 300 : 200,
//                       color: Colors.blue[600],
//                     ),
//                     Column(
//                       children: [
//                         SizedBox(height: 16),
//                         Stack(
//                           children: [
//                             CircleAvatar(
//                               radius: constraints.maxWidth > 600 ? 72 : 48,
//                               backgroundImage: NetworkImage(
//                                   'https://storage.googleapis.com/a1aa/image/L4iBcfg3zZT8DiKGjiwqVAgHPbKfObreIjtbCPo91uASOeQOB.jpg'),
//                             ),
//                             Positioned(
//                               bottom: 0,
//                               right: 0,
//                               child: CircleAvatar(
//                                 backgroundColor: Colors.white,
//                                 radius: 16,
//                                 child: Icon(Icons.edit,
//                                     color: Colors.blue[600], size: 16),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8),
//                         Text(
//                           'Libryan Adetya',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: constraints.maxWidth > 600 ? 24 : 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           '21093712047102',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         SizedBox(height: 16),
//                         Container(
//                           color: Colors.white,
//                           padding: EdgeInsets.all(16.0),
//                           child: Column(
//                             children: [
//                               _buildOption(
//                                 icon: Icons.edit,
//                                 text: 'Edit Profil',
//                                 onTap: () async {
//                                   await EditProfileApi.editProfile('New Name', 'newemail@example.com');
//                                 },
//                               ),
//                               _buildOption(
//                                 icon: Icons.lock,
//                                 text: 'Ganti Kata Sandi',
//                                 onTap: () async {
//                                   await ChangePasswordApi.changePassword('oldpassword', 'newpassword');
//                                 },
//                               ),
//                               _buildOption(
//                                 icon: Icons.delete,
//                                 text: 'Hapus Akun',
//                                 onTap: () async {
//                                   await DeleteAccountApi.deleteAccount();
//                                 },
//                               ),
//                               _buildOption(
//                                 icon: Icons.exit_to_app,
//                                 text: 'Keluar',
//                                 textColor: Colors.red,
//                                 iconColor: Colors.red,
//                                 onTap: () async {
//                                   await LogoutApi.logout();
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home, color: Colors.red),
//             label: '',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person, color: Colors.blue),
//             label: '',
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOption({
//     required IconData icon,
//     required String text,
//     Color textColor = Colors.black,
//     Color iconColor = Colors.grey,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 12.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(icon, color: iconColor),
//                 SizedBox(width: 8),
//                 Text(text, style: TextStyle(color: textColor)),
//               ],
//             ),
//             Icon(Icons.chevron_right, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EditProfileApi {
//   static Future<void> editProfile(String name, String email) async {
//     final url = 'https://your-backend-url.com/api/edit-profile';
//     final headers = {
//       'Content-Type': 'application/json',
//     };
//     final body = {
//       'name': name,
//       'email': email,
//     };

//     final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

//     if (response.statusCode == 200) {
//       print('Profile updated successfully');
//     } else {
//       print('Error updating profile: ${response.statusCode}');
//     }
//   }
// }

// class ChangePasswordApi {
//   static Future<void> changePassword(String oldPassword, String newPassword) async {
//     final url = 'https://your-backend-url.com/api