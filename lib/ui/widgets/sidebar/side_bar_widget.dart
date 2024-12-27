import 'package:books_bart/ui/widgets/app/app.dart';
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
          decoration: BoxDecoration(color: Color(0xFF7E675E)),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TitleCardWidget(),
                  _HistoryButton(),
                  Divider(height: 20),
                  _LogoutButtonWidget(),
                ],
              ),
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
    return ListTile(
      onTap: context.read<SideBarViewModel>().onShowProfile,
      leading: const CircleAvatar(
        backgroundColor: Colors.white24,
        child: Icon(Icons.person, color: Colors.white),
      ),
      title: Text(
        context.select((AppBloc bloc) => bloc.state.user.name) ?? '',
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class _HistoryButton extends StatelessWidget {
  const _HistoryButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: context.read<SideBarViewModel>().onPressedHistory,
        child: const Row(
          children: [
            Icon(Icons.history, color: Colors.white),
            SizedBox(width: 20),
            Text('History', style: TextStyle(color: Colors.white, fontSize: 16))
          ],
        ),
      ),
    );
  }
}

class _LogoutButtonWidget extends StatelessWidget {
  const _LogoutButtonWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => context.read<AppBloc>().add(const AppLogoutPressed()),
        child: const Text('Log out', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
