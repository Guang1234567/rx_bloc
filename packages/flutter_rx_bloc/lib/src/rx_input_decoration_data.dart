import 'package:flutter/material.dart';

/// [RxInputDecorationData] is a class which defines some additional
///input decoration not present in the [InputDecoration] class
///intended to be used with RxTextFormFieldBuilder which internally
///manages the usage of the fields
///
/// See Also:
///   * RxTextFormFieldBuilder - a widget for building TextFormFields with
///                                reactive streams
///
///   * [InputDecoration] - The border, labels, icons, and styles used
///                         to decorate a Material Design text field.
class RxInputDecorationData {
  /// Default constructor
  const RxInputDecorationData({
    this.labelStyle = const TextStyle(
      color: Color(0xff333333),
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontSize: 14,
    ),
    this.labelStyleError = const TextStyle(
      color: Color(0xffff6b2a),
      fontWeight: FontWeight.w400,
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontSize: 14,
    ),
    this.iconVisibility = const Icon(Icons.visibility),
    this.iconVisibilityOff = const Icon(Icons.visibility_off),
  });

  /// The label style used when it is above the field
  ///and RxTextFormFieldBuilder doesn't detect an error
  final TextStyle labelStyle;

  /// The label style used when it is above the field
  ///and RxTextFormFieldBuilder detects an error
  final TextStyle labelStyleError;

  /// The Widget which is used as a trailing icon
  ///in the decoration generated by RxTextFormFieldBuilder
  ///if obscureText is set and and the text is currently obscured.
  final Widget iconVisibility;

  /// The Widget which is used as a trailing icon
  ///in the decoration generated by RxTextFormFieldBuilder
  ///if obscureText is set and and the text is currently not obscured.
  final Widget iconVisibilityOff;
}

///An extension to make adding additional decoration other than
///the one provided by RxTextFormFieldBuilder easier
extension CopyWithDecoration on InputDecoration {
  /// Creates a copy of this input decoration with the given fields replaced
  /// by the new values from an InputDecoration passed to the function
  InputDecoration copyWithDecoration(InputDecoration decoration) => copyWith(
        icon: decoration.icon ?? icon,
        labelText: decoration.labelText ?? labelText,
        labelStyle: decoration.labelStyle ?? labelStyle,
        helperText: decoration.helperText ?? helperText,
        helperStyle: decoration.helperStyle ?? helperStyle,
        helperMaxLines: decoration.helperMaxLines ?? helperMaxLines,
        hintText: decoration.hintText ?? hintText,
        hintStyle: decoration.hintStyle ?? hintStyle,
        hintMaxLines: decoration.hintMaxLines ?? hintMaxLines,
        errorText: decoration.errorText ?? errorText,
        errorStyle: decoration.errorStyle ?? errorStyle,
        errorMaxLines: decoration.errorMaxLines ?? errorMaxLines,
        floatingLabelBehavior:
            decoration.floatingLabelBehavior ?? floatingLabelBehavior,
        isCollapsed: decoration.isCollapsed ?? isCollapsed,
        isDense: decoration.isDense ?? isDense,
        contentPadding: decoration.contentPadding ?? contentPadding,
        prefixIcon: decoration.prefixIcon ?? prefixIcon,
        prefix: decoration.prefix ?? prefix,
        prefixText: decoration.prefixText ?? prefixText,
        prefixStyle: decoration.prefixStyle ?? prefixStyle,
        prefixIconConstraints:
            decoration.prefixIconConstraints ?? prefixIconConstraints,
        suffixIcon: decoration.suffixIcon ?? suffixIcon,
        suffix: decoration.suffix ?? suffix,
        suffixText: decoration.suffixText ?? suffixText,
        suffixStyle: decoration.suffixStyle ?? suffixStyle,
        suffixIconConstraints:
            decoration.suffixIconConstraints ?? suffixIconConstraints,
        counter: decoration.counter ?? counter,
        counterText: decoration.counterText ?? counterText,
        counterStyle: decoration.counterStyle ?? counterStyle,
        filled: decoration.filled ?? filled,
        fillColor: decoration.fillColor ?? fillColor,
        focusColor: decoration.focusColor ?? focusColor,
        hoverColor: decoration.hoverColor ?? hoverColor,
        errorBorder: decoration.errorBorder ?? errorBorder,
        focusedBorder: decoration.focusedBorder ?? focusedBorder,
        focusedErrorBorder: decoration.focusedErrorBorder ?? focusedErrorBorder,
        disabledBorder: decoration.disabledBorder ?? disabledBorder,
        enabledBorder: decoration.enabledBorder ?? enabledBorder,
        border: decoration.border ?? border,
        enabled: decoration.enabled ?? enabled,
        semanticCounterText:
            decoration.semanticCounterText ?? semanticCounterText,
        alignLabelWithHint: decoration.alignLabelWithHint ?? alignLabelWithHint,
      );
}
