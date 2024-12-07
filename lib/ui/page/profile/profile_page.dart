import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text('JD'),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Jane Doe',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text('@janedoe'),
                  ],
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Edit Profile'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'UX Designer and front-end developer. Passionate about creating intuitive and beautiful user experiences.',
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 8),
                Text('San Francisco, CA'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.link),
                SizedBox(width: 8),
                Text('https://janedoe.com'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.email),
                SizedBox(width: 8),
                Text('jane@example.com'),
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 8),
                Text('Joined January 2023'),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Xem lịch sử thi'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Phân tích kết quả thi'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
