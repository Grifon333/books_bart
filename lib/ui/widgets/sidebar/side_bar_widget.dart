import 'package:books_bart/ui/widgets/sidebar/side_bar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideBarWidget extends StatelessWidget {
  const SideBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
        width: 288,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Color(0xFF7E675E),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _TitleCardWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleCardWidget extends StatelessWidget {
  const _TitleCardWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<SideBarViewModel>();
    return ListTile(
      onTap: model.onShowProfile,
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      ),
      title: const Text(
        'John Wick',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
