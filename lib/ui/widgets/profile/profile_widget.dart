import 'package:books_bart/ui/widgets/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ProfileViewModel>();
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
            onPressed: model.state.isEdit ? model.onSave : model.onEdit,
            child: Text(model.state.isEdit ? 'Save' : 'Edit'),
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
    final isChangePassword =
        context.watch<ProfileViewModel>().state.isChangePassword;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const _ImageWidget(),
          const SizedBox(height: 16),
          const _TextInfoWidget(),
          const SizedBox(height: 16),
          isChangePassword
              ? const _NewPasswordFormWidget()
              : const _ChangePasswordWidget(),
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
              onChanged: model.onChangedNickname,
              errorText: model.state.nicknameError,
              isEdit: model.state.isEdit,
            ),
            _FieldWidget(
              title: 'Email',
              body: state.email,
              isEdit: model.state.isEdit,
            ),
            _FieldWidget(
              title: 'Phone number',
              body: state.phoneNumber,
              onChanged: model.onChangedPhoneNumber,
              errorText: model.state.phoneNumberError,
              isEdit: model.state.isEdit,
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
      child: Image(
        image: NetworkImage(imageURL),
        height: 150,
        width: 150,
      ),
    );
  }
}

class _FieldWidget extends StatelessWidget {
  final String title;
  final String body;
  final void Function(String)? onChanged;
  final String? errorText;
  final bool isEdit;

  const _FieldWidget({
    required this.title,
    required this.body,
    this.onChanged,
    this.errorText,
    required this.isEdit,
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
            isEdit && title != 'Email'
                ? TextField(
                    decoration: InputDecoration(
                      hintText: title,
                      filled: true,
                      fillColor: const Color(0xFFF5EEE5),
                      errorText: errorText,
                    ),
                    controller: TextEditingController(text: body)
                      ..selection = TextSelection.collapsed(
                        offset: body.length,
                      ),
                    onChanged: onChanged,
                  )
                : Text(
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

class _ChangePasswordWidget extends StatelessWidget {
  const _ChangePasswordWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<ProfileViewModel>();
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: model.onPressedChangePassword,
        child: const Text('Change password'),
      ),
    );
  }
}

class _NewPasswordFormWidget extends StatelessWidget {
  const _NewPasswordFormWidget();

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
              title: 'Password',
              body: state.newPassword,
              onChanged: model.onChangedPassword,
              errorText: model.state.newPasswordError,
              isEdit: true,
            ),
            FilledButton(
              onPressed: model.onPressedSubmitChangePassword,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
