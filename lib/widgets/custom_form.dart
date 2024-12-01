import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/bloc/form/form_bloc.dart';

class CustomForm extends StatefulWidget {
  final TextEditingController? controller;
  final bool? isPasswordVisible;
  final String? labelText;
  final VoidCallback? onTap;
  final String? hintText;

  const CustomForm({
    super.key,
    this.onTap,
    this.labelText,
    this.controller,
    this.isPasswordVisible,
    this.hintText,
  });

  @override
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, CustomFormState>(
      builder: (context, state) {
        return Stack(
          children: [
            TextFormField(
              onTap: widget.onTap,
              style: GoogleFonts.lexend(
                fontSize: 14,
                color: const Color.fromRGBO(16, 19, 23, 1),
                fontWeight: FontWeight.w300,
              ),
              focusNode: _focusNode,
              controller: widget.controller,
              obscureText: widget.isPasswordVisible ?? false
                  ? state.isPasswordVisible
                  : false,
              decoration: InputDecoration(
                hintText: widget.hintText,
                contentPadding: const EdgeInsets.fromLTRB(15, 50, 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color.fromRGBO(218, 218, 218, 1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                suffixIcon: widget.isPasswordVisible ?? false
                    ? IconButton(
                        onPressed: () {
                          context
                              .read<FormBloc>()
                              .add(TogglePasswordVisibilityEvent());
                        },
                        icon: Icon(
                          state.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                      )
                    : null,
                border: InputBorder.none,
              ),
            ),
            Positioned(
              left: 16,
              top: 8,
              child: AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  widget.labelText ?? '',
                  style: GoogleFonts.lexend(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                      color: _isFocused
                          ? Colors.blue
                          : const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
