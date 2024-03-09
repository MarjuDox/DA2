
import 'dart:io';

import 'package:diabetes/core/const/color_constants.dart';
import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/core/service/validation_service.dart';
import 'package:diabetes/screens/change_password_settings/page/change_password_settings_page.dart';
import 'package:diabetes/screens/common_widget/diabetes_button.dart';
import 'package:diabetes/screens/common_widget/diabetes_loading.dart';
import 'package:diabetes/screens/common_widget/diabetes_settings_container.dart';
import 'package:diabetes/screens/common_widget/diabetes_settings_text_field.dart';
import 'package:diabetes/screens/edit_account/bloc/edit_account_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class EditAccountScreen extends StatefulWidget {
  const EditAccountScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;
  String? photoUrl;
  bool isNameInvalid = false;
  bool isEmailInvalid = false;
  late String userName;
  late String userEmail;

  @override
  void initState() {
    userName = user?.displayName ?? "No Username";
    userEmail = user?.email ?? 'No email';
    photoUrl = user?.photoURL ?? null;
    _nameController.text = userName;
    _emailController.text = userEmail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContext(context),
      appBar: AppBar(
        title: const Text(TextConstants.editAccount,
            style: TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.of(context).pop()),
        iconTheme: const IconThemeData(
          color: ColorConstants.primaryColor,
        ),
      ),
    );
  }

  BlocProvider<EditAccountBloc> _buildContext(BuildContext context) {
    return BlocProvider<EditAccountBloc>(
      create: (context) => EditAccountBloc(),
      child: BlocConsumer<EditAccountBloc, EditAccountState>(
        buildWhen: (_, currState) =>
            currState is EditAccountInitial ||
            currState is EditAccountProgress ||
            currState is EditAccountError ||
            currState is EditPhotoSuccess,
        builder: (context, state) {
          if (state is EditAccountProgress) {
            return Stack(
              children: [_editAccountContent(context), DiabetesLoading()],
            );
          }
          if (state is EditAccountError) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              _showOpenSettingsPopUp();
            });
          }
          if (state is EditPhotoSuccess) photoUrl = state.image.path;
          return _editAccountContent(context);
        },
        listenWhen: (_, currState) => true,
        listener: (context, state) {},
      ),
    );
  }

  void _showOpenSettingsPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(TextConstants.cameraPermission),
        content: Text(TextConstants.cameAccess),
        actions: [
          CupertinoDialogAction(
            child: Text(TextConstants.deny),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: Text(TextConstants.settings),
            onPressed: () => openAppSettings(),
          ),
        ],
      ),
    );
  }

  Widget _editAccountContent(BuildContext context) {
    EditAccountBloc bloc = BlocProvider.of<EditAccountBloc>(context,listen: false);
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
          child: SizedBox(
            height: height - 140 - MediaQuery.of(context).padding.bottom,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _getImageWidget()),
                SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: () {
                      bloc.add(UploadImage());
                    },
                    child: Text(
                      TextConstants.editPhoto,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  TextConstants.fullName,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SettingsContainer(
                    child: SettingsTextField(
                  controller: _nameController,
                  placeHolder: TextConstants.fullNamePlaceholder,
                )),
                if (isNameInvalid)
                  Text(TextConstants.nameShouldContain2Char,
                      style: TextStyle(color: ColorConstants.errorColor)),
                Text(TextConstants.email,
                    style: TextStyle(fontWeight: FontWeight.w600)),
                SettingsContainer(
                    child: SettingsTextField(
                  controller: _emailController,
                  placeHolder: TextConstants.emailPlaceholder,
                )),
                if (isEmailInvalid)
                  Text(TextConstants.emailErrorText,
                      style: TextStyle(color: ColorConstants.errorColor)),
                SizedBox(height: 15),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen()));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        TextConstants.changePassword,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.primaryColor,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: ColorConstants.primaryColor,
                      )
                    ],
                  ),
                ),
                Spacer(),
                DiabetesButton(
                  title: TextConstants.save,
                  isEnabled: true,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      isNameInvalid = !(_nameController.text.length > 1);
                      isEmailInvalid =
                          !ValidationService.email(_emailController.text);
                    });

                    if (!(isNameInvalid || isEmailInvalid)) {
                      if (userName != _nameController.text ||
                          userEmail != _emailController.text) {
                        bloc.add(ChangeUserData(
                            displayName: _nameController.text,
                            email: _emailController.text));
                        userName = _nameController.text;
                        userEmail = _emailController.text;
                      }
                    }
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getImageWidget() {
    if (photoUrl != null) {
      if (photoUrl!.startsWith('https://')) {
        return CircleAvatar(
          radius: 60,
          child: ClipOval(
            child: FadeInImage.assetNetwork(
              placeholder: PathConstants.profile,
              image: photoUrl!,
              fit: BoxFit.cover,
              width: 200,
              height: 120,
            ),
          ),
        );
      } else {
        return CircleAvatar(
            backgroundImage: FileImage(File(photoUrl!)), radius: 60);
      }
    } else {
      return const CircleAvatar(
          backgroundImage: AssetImage(PathConstants.profile), radius: 60);
    }
  }

}

