import 'package:books_bart/ui/widgets/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProfileViewModel>();
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEE5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5EEE5),
        title: const Text('Profile'),
        leading: IconButton(
          onPressed: model.onPopUp,
          icon: const Icon(Icons.chevron_left),
        ),
        actions: [
          TextButton(
            onPressed: model.onEdit,
            child: const Text('Edit'),
          ),
        ],
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _ImageWidget(),
          SizedBox(height: 16),
          _TextInfoWidget(),
        ],
      ),
    );
  }
}

class _TextInfoWidget extends StatelessWidget {
  const _TextInfoWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ProfileViewModel>();
    final state = model.state;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFF7E675E),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _FieldWidget(
              title: 'Nickname',
              body: state.nickname,
            ),
            _FieldWidget(
              title: 'Email',
              body: state.email,
            ),
            _FieldWidget(
              title: 'Phone number',
              body: state.phoneNumber,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageWidget extends StatelessWidget {
  const _ImageWidget();

  @override
  Widget build(BuildContext context) {
    final imageURL = context.select((ProfileViewModel vm) => vm.state.imageURL);
    return ClipOval(
      child: Image(image: NetworkImage(imageURL)),
    );
  }
}

class _FieldWidget extends StatelessWidget {
  final String title;
  final String body;

  const _FieldWidget({
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              body,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
