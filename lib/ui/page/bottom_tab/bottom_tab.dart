import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iscanner_app/app.dart';
import 'package:iscanner_app/ui/page/bottom_tab/bottom_tab_cubit.dart';
import 'package:iscanner_app/ui/page/bottom_tab/bottom_tab_state.dart';
import 'package:iscanner_app/ui/page/login/login_page.dart';
import 'package:iscanner_app/ui/page/reigster/register_page.dart';

class BottomTabPage extends StatelessWidget {
  const BottomTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left - Logo
            const Text(
              'Toeic',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            // Center - Navigation
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {
                    injector<BottomTabCubit>().updateIndex(0);
                  },
                  child: const Text(
                    'About',
                  ),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () {
                    injector<BottomTabCubit>().updateIndex(1);
                  },
                  child: const Text('Resources'),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () {
                    injector<BottomTabCubit>().updateIndex(2);
                  },
                  child: const Text('Practice Test'),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () {
                    injector<BottomTabCubit>().updateIndex(3);
                  },
                  child: const Text('TOEIC Full Exam'),
                ),
                const SizedBox(width: 24),
                TextButton(
                  onPressed: () {
                    injector<BottomTabCubit>().updateIndex(4);
                  },
                  child: const Text('Contact'),
                ),
              ],
            ),

            // Right - Login Button
            ElevatedButton(
              onPressed: () {
                injector<BottomTabCubit>().updateIndex(5);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
      body: BlocBuilder<BottomTabCubit, BottomTabState>(
        builder: (context, state) {
          return IndexedStack(
            index: state.selectedIndex,
            children: const [
              Center(
                child: Text('About'),
              ),
              Center(
                child: Text('Resources'),
              ),
              Center(
                child: Text('Practice tests'),
              ),
              Center(
                child: Text('Contact'),
              ),
              Center(
                child: Text('Toeic full exam'),
              ),
              LoginPage(),
              RegisterPage(),
            ],
          );
        },
      ),
    );
  }
}
