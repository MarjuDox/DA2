import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/core/service/validation_service.dart';
import 'package:diabetes/screens/change_password_settings/bloc/change_password_settings_bloc.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/common_widget/diabetes_loading.dart';
import 'package:diabetes/screens/common_widget/diabetes_settings_container.dart';
import 'package:diabetes/screens/common_widget/diabetes_settings_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordSettingsState createState() => _ChangePasswordSettingsState();
}

class _ChangePasswordSettingsState extends State {
  final TextEditingController _newPassController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  bool isNewPassInvalid = false;
  bool isConfirmPassInvalid = false;
  late String userName;

  @override
  void initState() {
    userName = user?.displayName ?? "No Username";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContext(context),
      appBar: AppBar(
        title: const Text(TextConstants.changePassword),
      ),
    );
  }

  BlocProvider<ChangePasswordSettingsBloc> _buildContext(BuildContext context) {
    return BlocProvider<ChangePasswordSettingsBloc>(
      create: (context) => ChangePasswordSettingsBloc(),
      child:
          BlocConsumer<ChangePasswordSettingsBloc, ChangePasswordSettingsState>(
        buildWhen: (_, currState) =>
            currState is ChangePasswordSettingsInitial ||
            currState is ChangePasswordError ||
            currState is ChangePasswordProgress ||
            currState is ChangePasswordSuccess,
        builder: (context, state) {
          if (state is ChangePasswordProgress) {
            return Stack(children: [
              _editAccountContent(context),
              const DiabetesLoading()
            ]);
          }
          if (state is ChangePasswordError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.error)));
            });
          }
          if (state is ChangePasswordSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            });
          }
          return _editAccountContent(context);
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }

  Widget _editAccountContent(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    ChangePasswordSettingsBloc _bloc = BlocProvider.of(context);
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: SizedBox(
            height: height - 140 - MediaQuery.of(context).padding.bottom,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 15),
              const Text(TextConstants.newPassword,
                  style: TextStyle(fontWeight: FontWeight.w600)),
              SettingsContainer(
                child: SettingsTextField(
                  controller: _newPassController,
                  obscureText: true,
                  placeHolder: TextConstants.passwordPlaceholder,
                ),
              ),
              if (isNewPassInvalid)
                const Text(TextConstants.passwordErrorText,
                    style: TextStyle(color: ColorConstants.errorColor)),
              const SizedBox(height: 10),
              const Text(TextConstants.confirmPassword,
                  style: TextStyle(fontWeight: FontWeight.w600)),
              SettingsContainer(
                child: SettingsTextField(
                  controller: _confirmPassController,
                  obscureText: true,
                  placeHolder: TextConstants.confirmPasswordPlaceholder,
                ),
              ),
              if (isConfirmPassInvalid)
                const Text(TextConstants.confirmPasswordErrorText,
                    style: TextStyle(color: ColorConstants.errorColor)),
              const Spacer(),
              DiabetesButton(
                title: TextConstants.save,
                isEnabled: true,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    isNewPassInvalid =
                        !ValidationService.password(_newPassController.text);
                    isConfirmPassInvalid =
                        _newPassController.text != _confirmPassController.text;
                  });
                  if (!(isNewPassInvalid || isConfirmPassInvalid)) {
                    _bloc.add(ChangePasswordSettings(
                        newPass: _newPassController.text));
                  }
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
