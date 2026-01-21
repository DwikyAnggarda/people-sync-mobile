/// Custom App Text Field Widget
/// Reusable text field with consistent styling
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final int maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? suffix;
  final VoidCallback? onTap;
  final bool readOnly;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final String? errorText;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffix,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.inputFormatters,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.errorText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          enabled: widget.enabled,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          maxLength: widget.maxLength,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          onChanged: widget.onChanged,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            hintText: widget.hint,
            errorText: widget.errorText,
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon)
                : null,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffix,
          ),
        ),
      ],
    );
  }
}

/// Date Picker Field
class AppDateField extends StatelessWidget {
  final String? label;
  final String? hint;
  final DateTime? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTime)? onChanged;
  final String? Function(DateTime?)? validator;
  final bool enabled;

  const AppDateField({
    super.key,
    this.label,
    this.hint,
    this.value,
    this.firstDate,
    this.lastDate,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        FormField<DateTime>(
          initialValue: value,
          validator: validator,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: enabled
                      ? () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: value ?? DateTime.now(),
                            firstDate: firstDate ?? DateTime(2020),
                            lastDate: lastDate ?? DateTime(2030),
                          );
                          if (picked != null) {
                            state.didChange(picked);
                            onChanged?.call(picked);
                          }
                        }
                      : null,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: hint ?? 'Pilih tanggal',
                      errorText: state.errorText,
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      value != null
                          ? '${value!.day}/${value!.month}/${value!.year}'
                          : hint ?? 'Pilih tanggal',
                      style: value != null
                          ? null
                          : Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).hintColor,
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Time Picker Field
class AppTimeField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TimeOfDay? value;
  final void Function(TimeOfDay)? onChanged;
  final bool enabled;

  const AppTimeField({
    super.key,
    this.label,
    this.hint,
    this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: enabled
              ? () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: value ?? TimeOfDay.now(),
                  );
                  if (picked != null) {
                    onChanged?.call(picked);
                  }
                }
              : null,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hint ?? 'Pilih waktu',
              suffixIcon: const Icon(Icons.access_time),
            ),
            child: Text(
              value != null
                  ? '${value!.hour.toString().padLeft(2, '0')}:${value!.minute.toString().padLeft(2, '0')}'
                  : hint ?? 'Pilih waktu',
              style: value != null
                  ? null
                  : Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
