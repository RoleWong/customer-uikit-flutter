import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tencent_desk_i18n_tool/tencent_desk_i18n_tool.dart';
import 'package:tencent_im_base/tencent_im_base.dart';
import 'package:tencent_keyboard_visibility/tencent_keyboard_visibility.dart';

class TencentCloudCustomerMobileForm extends StatefulWidget {
  final dynamic payload;
  final Function({V2TimMessage? messageInfo}) onSubmitForm;

  const TencentCloudCustomerMobileForm({
    super.key,
    required this.payload,
    required this.onSubmitForm,
  });

  @override
  State<TencentCloudCustomerMobileForm> createState() => _TencentCloudCustomerMobileFormState();
}

class _TencentCloudCustomerMobileFormState extends State<TencentCloudCustomerMobileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late final Map<String, dynamic> _inputData;
  bool _didSubmit = false;
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _initializeInputData();
  }

  void _initializeInputData() {
    final inputVariables = widget.payload['content']['inputVariables'] ?? [];
    _inputData = {
      for (var item in inputVariables)
        item['name']: item['variableValue'] ?? (item['formType'] == 1 ? (item['chooseItemList'] as List).first : null)
    };
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final data = Map<String, dynamic>.from(widget.payload);
    final inputVariables = data['content']['inputVariables'] ?? [];
    for (var item in inputVariables) {
      item['variableValue'] = _inputData[item['name']];
    }
    data.remove('nodeStatus');
    final jsonString = jsonEncode(data);

    final res = await TencentImSDKPlugin.v2TIMManager.getMessageManager().createCustomMessage(data: jsonString);
    if (res.code == 0) {
      final messageResult = res.data;
      widget.onSubmitForm(messageInfo: messageResult?.messageInfo);
      setState(() => _didSubmit = true);
    }
  }

  Widget _buildInputField(Map<String, dynamic> item, int nodeStatus) {
    if (item['formType'] == 0) {
      return CustomerFormInputField(
        value: item['variableValue'] as String?,
        name: item['name'],
        isRequired: item['isRequired'] == 1,
        nodeStatus: nodeStatus,
        onValueChanged: (name, value) => _onValueChanged(name, value),
        didSubmitted: _didSubmit,
        placeholder: item['placeholder'] ?? "",
      );
    }
    return CustomerFormSelectionField(
      value: item['variableValue'] as String?,
      name: item['name'],
      isRequired: item['isRequired'] == 1,
      itemList: item['chooseItemList'] as List<dynamic>,
      nodeStatus: nodeStatus,
      onValueChanged: (name, value) => _onValueChanged(name, value),
      didSubmitted: _didSubmit,
    );
  }

  void _onValueChanged(String name, String value) {
    _inputData[name] = value;
  }

  Widget _buildFormContent() {
    final inputVariables = widget.payload['content']['inputVariables'] ?? [];
    final nodeStatus = widget.payload['nodeStatus'] ?? 2;

    return ListView.builder(
      itemCount: inputVariables.length,
      itemBuilder: (context, index) {
        final item = inputVariables[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel(item['name'], item['isRequired'] == 1, item["formType"]),
              const SizedBox(width: 16),
              Expanded(child: _buildInputField(item, nodeStatus)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String name, bool isRequired, int formType) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(top: formType == 0 ? 10 : 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              name,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          if (isRequired) const SizedBox(width: 4),
          if (isRequired)
            const Text(
              '*',
              style: TextStyle(color: Colors.red, fontSize: 14),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tip = widget.payload['content']['tip'] ?? '';
    final nodeStatus = widget.payload['nodeStatus'] ?? 2;

    return KeyboardVisibility(
      onChanged: (value) {
        if (value != _keyboardVisible) {
          setState(() {
            _keyboardVisible = value;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          constraints: BoxConstraints(
            minHeight: 200,
            maxHeight: MediaQuery.of(context).size.height / 1.5,
          ),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color.fromARGB(1, 241, 245, 253), Colors.white],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildHeader(tip),
                Expanded(child: _buildFormContent()),
                const SizedBox(height: 30),
                if (nodeStatus == 0 && !_didSubmit) _buildSubmitButton(),
                AnimatedContainer(
                  duration: Duration(milliseconds: (_keyboardVisible && Platform.isAndroid) ? 200 : 340),
                  curve: Curves.fastOutSlowIn,
                  height: _keyboardVisible ? 280 : 0,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String tip) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            tip,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, color: Colors.grey, size: 16),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return InkWell(
      onTap: _submitForm,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
        decoration: const BoxDecoration(
          color: Color(0xFF1C66E5),
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(24),
            right: Radius.circular(24),
          ),
        ),
        child: Text(
          TDesk_t('提交'),
          style: const TextStyle(color: Colors.white, fontSize: 16,),
        ),
      ),
    );
  }
}

class FormStyles {
  static const double fieldHeight = 56.0;

  static const BoxDecoration fieldDecoration = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        width: 1,
        color: Colors.black12,
      ),
    ),
  );

  static InputDecoration inputDecoration(String placeholder) => InputDecoration(
        hintText: placeholder,
        hintStyle: const TextStyle(color: Color.fromARGB(102, 0, 0, 0), fontSize: 14),
        filled: true,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        isCollapsed: true,
        errorStyle: const TextStyle(color: Color(0xFFE54545), fontSize: 12,),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      );
}

class CustomerFormSelectionField extends StatelessWidget {
  final String name;
  final bool isRequired;
  final String? value;
  final List<dynamic> itemList;
  final int nodeStatus;
  final Function(String, String) onValueChanged;
  final bool didSubmitted;

  const CustomerFormSelectionField({
    required this.name,
    required this.isRequired,
    this.value,
    required this.itemList,
    required this.nodeStatus,
    required this.onValueChanged,
    Key? key,
    required this.didSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: value,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return TDesk_t("请选择一项");
        }
        return null;
      },
      builder: (FormFieldState<String> fieldState) {
        final _selectedValue = fieldState.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: itemList.map<Widget>((item) {
                final bool isSelected = _selectedValue == item;
                return GestureDetector(
                  onTap: () {
                    if (!didSubmitted && (value == null || value!.isEmpty) && nodeStatus != 2) {
                      FocusScope.of(context).unfocus();
                      fieldState.didChange(item);
                      onValueChanged(name, item);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFE7E7E7), width: 1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF0052D9) : Colors.transparent,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF0052D9) : const Color(0xFFDCDCDC),
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                        Expanded(
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            if (fieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  fieldState.errorText!,
                  style: const TextStyle(color: Color(0xFFE54545), fontSize: 12,),
                ),
              ),
          ],
        );
      },
    );
  }
}

class CustomerFormInputField extends StatelessWidget {
  final String name;
  final bool isRequired;
  final String? value;
  final String placeholder;
  final Function(String, String) onValueChanged;
  final bool didSubmitted;
  final int nodeStatus;

  const CustomerFormInputField({
    required this.name,
    required this.isRequired,
    this.value,
    required this.placeholder,
    required this.onValueChanged,
    required this.didSubmitted,
    required this.nodeStatus,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FormStyles.fieldHeight,
      decoration: FormStyles.fieldDecoration,
      child: TextFormField(
        initialValue: value,
        enabled: (!didSubmitted && (value == null || value!.isEmpty) && nodeStatus != 2),
        decoration: FormStyles.inputDecoration(placeholder),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
        ),
        onChanged: (newValue) => onValueChanged(name, newValue),
        validator: (String? newValue) {
          if (isRequired && (newValue == null || newValue.isEmpty)) {
            return TDesk_t('请填写必填项');
          }
          onValueChanged(name, newValue ?? '');
          return null;
        },
      ),
    );
  }
}
