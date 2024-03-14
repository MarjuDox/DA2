import 'package:diabetes/core/const/path_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:flutter/material.dart';

class DiabetesTextField extends StatefulWidget {
  final String title;
  final String placeholder;
  final String errorText;
  final bool obscureText;
  final bool isError;
  final bool autoFocus;
  final TextEditingController controller;
  final VoidCallback onTextChanged;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;

  const DiabetesTextField({
    this.autoFocus = false,
    required this.title,
    required this.placeholder,
    this.obscureText = false,
    this.isError = false,
    required this.controller,
    required this.onTextChanged,
    required this.errorText,
    this.textInputAction = TextInputAction.done,
    this.keyboardType,
    Key? key,
  }) : super(key: key);

  @override
  _DiabetesTextFieldState createState() => _DiabetesTextFieldState();
}

class _DiabetesTextFieldState extends State<DiabetesTextField> {
  final focusNode = FocusNode();
  bool stateObscureText = false;
  bool stateIsError = false;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(
      () {
        setState(() {
          if (focusNode.hasFocus) {
            stateIsError = false;
          }
        });
      },
    );

    stateObscureText = widget.obscureText;
    stateIsError = widget.isError;
  }

  @override
  void didUpdateWidget(covariant DiabetesTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    stateObscureText = widget.obscureText;
    stateIsError = focusNode.hasFocus ? false : widget.isError;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createHeader(),
          const SizedBox(height: 5),
          _createTextFieldStack(),
          if (stateIsError) ...[
            _createError(),
          ],
        ],
      ),
    );
  }

  _createHeader() {
    return Text(
      widget.title,
      style: TextStyle(
        color: _getUserNameColor(),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color _getUserNameColor() {
    if (focusNode.hasFocus) {
      return context.colorScheme.primary;
    } else if (stateIsError) {
      return context.colorScheme.error;
    } else if (widget.controller.text.isNotEmpty) {
      return context.colorScheme.onSurface;
    }
    return context.colorScheme.onSurfaceVariant;
  }

  Widget _createTextFieldStack() {
    return Stack(
      children: [
        _createTextField(),
        if (widget.obscureText) ...[
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: _createShowEye(),
          ),
        ],
      ],
    );
  }

  Widget _createTextField() {
    return TextField(
      autofocus: widget.autoFocus,
      focusNode: focusNode,
      controller: widget.controller,
      obscureText: stateObscureText,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      style: const TextStyle(
        fontSize: 16,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: stateIsError
                ? context.colorScheme.error
                : context.colorScheme.onSurfaceVariant.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: context.colorScheme.primary,
          ),
        ),
        hintText: widget.placeholder,
        hintStyle: TextStyle(
          color: context.colorScheme.outlineVariant,
          fontSize: 16,
        ),
        filled: true,
        fillColor: context.colorScheme.background,
      ),
      onChanged: (text) {
        setState(() {});
        widget.onTextChanged();
      },
    );
  }

  Widget _createShowEye() {
    return GestureDetector(
      onTap: () {
        setState(() {
          stateObscureText = !stateObscureText;
        });
      },
      child: Image(
        image: const AssetImage(
          PathConstants.eye,
        ),
        color: widget.controller.text.isNotEmpty
            ? context.colorScheme.primary
            : context.colorScheme.onSurfaceVariant.withOpacity(0.4),
      ),
    );
  }

  Widget _createError() {
    return Container(
      padding: const EdgeInsets.only(top: 2),
      child: Text(
        widget.errorText,
        style: TextStyle(
          fontSize: 14,
          color: context.colorScheme.error,
        ),
      ),
    );
  }
}
