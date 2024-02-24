import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
const Color appcolor = Color.fromRGBO(125, 125, 125, 100);


class TextFieldOne extends StatefulWidget {
  const TextFieldOne({
    Key? key,
    required this.hinttext,
    required this.controller,
    required this.onchange,
    this.obsecuretxt,
    this.preicon,
    this.keytype,
    this.fillcolor,
    this.ontap,
    this.sufix,
    this.validator, required this.readonly,
  }) : super(key: key);

  final String hinttext;
  final bool readonly;
  final TextEditingController controller;
  final ValueChanged onchange;
  final void Function()? ontap;
  final bool? obsecuretxt; // Note: Change type to bool?
  final IconData? preicon;
  final IconButton? sufix;
  final TextInputType? keytype;
  final Color? fillcolor;
  final String? Function(String?)? validator;

  @override
  State<TextFieldOne> createState() => _TextFieldOneState();
}

class _TextFieldOneState extends State<TextFieldOne> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Container(
        child: TextFormField(
          readOnly:widget.readonly,
          keyboardType: widget.keytype,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            suffixIcon: widget.sufix,
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(18)),
              borderSide: BorderSide(width: 1, color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                  width: 2, color: appcolor), // Border color when not in focus
            ),
            labelText: widget.hinttext,
            labelStyle: GoogleFonts.poppins(
              color: Colors.grey.withOpacity(.8),
            ),
            fillColor: widget.fillcolor ?? appcolor.withOpacity(.05),
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                  width: 2, color: appcolor), // Border color when focused
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(color: Colors.white)),
          ),
          style: const TextStyle(
            color: Colors.white,
          ),
          validator: widget.validator,
          onTap: widget.ontap,
          cursorColor: appcolor,
          obscureText: widget.obsecuretxt ?? false, // Use null-aware operator
          obscuringCharacter: '*',
          controller: widget.controller,
          onChanged: widget.onchange,
        ),
      ),
    );
  }
}

