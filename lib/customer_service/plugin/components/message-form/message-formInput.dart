import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_message.dart';
import 'package:tencent_cloud_chat_sdk/models/v2_tim_msg_create_info_result.dart';
import 'package:tencent_cloud_chat_sdk/tencent_im_sdk_plugin.dart';
import 'package:tencentcloud_ai_desk_customer/base_widgets/tim_state.dart';


class MessageFormInput extends StatefulWidget {
  final dynamic payload;
  final Function onSubmitForm;
  const MessageFormInput(
      {super.key, required this.payload, required this.onSubmitForm});
  @override
  State<StatefulWidget> createState() => _MessageFormInputState();
}

class _MessageFormInputState extends TIMState<MessageFormInput> {
  Map<String, dynamic> inputValue = {};
  bool isSubmited = false;

  @override
  void initState() {
    super.initState();
    handleMapValue();
  }

  void handleMapValue() {
    final inputVariables = widget.payload['content']['inputVariables'] ?? [];
    for (int i = 0; i < inputVariables.length; i++) {
      inputValue[inputVariables[i]['name'] as String] =
          inputVariables[i]['variableValue'];
      if (inputVariables[i]['formType'] == 1 &&
          (inputVariables[i]['variableValue'] == null ||
              inputVariables[i]['variableValue'] == '')) {
        inputValue[inputVariables[i]['name'] as String] =
            (inputVariables[i]['chooseItemList']! as List)[0];
      }
    }
  }

  Widget getLabel(String name, bool isRequired) {
    return Row(
      children: [
        isRequired
            ? const Text(
                '*',
                style: TextStyle(color: Colors.red),
              )
            : Container(),
        Text(name)
      ],
    );
  }

  Widget returnInput(String name, String? placeholder, bool isRequired,
      String? value, int nodeStatus) {
    if (isSubmited == false &&
        ((value == null || value.isEmpty) && nodeStatus != 2)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          getLabel(name, isRequired),
          const SizedBox(height: 8),
          Container(
              // height: 30,
              alignment: Alignment.topLeft,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: TextFormField(
                initialValue: inputValue[name],
                maxLines: 1,
                decoration: InputDecoration(
                    hintText: placeholder,
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(102, 0, 0, 0),
                      fontSize: 14,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    // border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 1.0)),
                    isCollapsed: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10)),
                onChanged: (value) {
                  inputValue[name] = value;
                },
                validator: (String? value) {
                  if (isRequired && (value == null || value.isEmpty)) {
                    return '必填项';
                  }
                  inputValue[name] = value;
                  return null;
                },
              )),
          const SizedBox(
            height: 10,
          )
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getLabel(name, isRequired),
        const SizedBox(height: 8),
        Text((inputValue[name] == null || inputValue[name].isEmpty)
            ? (value == null || value.isEmpty ? "" : value)
            : inputValue[name]),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget returnRadio(String name, bool isRequired, String? value,
      List<dynamic> itemList, int nodeStatus) {
    if (isSubmited == false &&
        ((value == null || value.isEmpty) && nodeStatus == 0)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          getLabel(name, isRequired),
          const SizedBox(height: 8),
          ...itemList.map((item) {
            return Row(children: [
                          Container(
              margin: const EdgeInsets.only(left: 0),
              child: Radio(
                groupValue: inputValue[name],
                value: item,
                onChanged: (dynamic value) {
                  setState(() {
                    inputValue[name] = value;
                  });
                  print("value ${inputValue[name]} ${value.runtimeType}");
                },
                activeColor: Colors.blue,
              )),
                          Text(item)
                        ]);
          }),
          const SizedBox(
            height: 10,
          )
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getLabel(name, isRequired),
        const SizedBox(height: 8),
        Text((inputValue[name] == null || inputValue[name].isEmpty)
            ? (value == null || value.isEmpty ? "" : value)
            : inputValue[name]),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget getInputForm() {
    final inputVariables = widget.payload['content']['inputVariables'] ?? [];
    final nodeStatus = widget.payload['nodeStatus'] ?? 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...inputVariables.map((item) {
          if (item['formType'] == 0) {
            return returnInput(
                item['name'] as String,
                item['placeholder'] as String?,
                item['isRequired'] == 1 ? true : false,
                item['variableValue'] as String?,
                nodeStatus);
          } else if (item['formType'] == 1) {
            return returnRadio(
                item['name'] as String,
                item['isRequired'] == 1 ? true : false,
                item['variableValue'] as String?,
                item['chooseItemList'] as List<dynamic>,
                nodeStatus);
          }
          return Container();
        })
      ],
    );
  }

  Future<V2TimMsgCreateInfoResult?> handleSubmit() async {
    Map<String, dynamic> data = widget.payload;
    List<dynamic> inputVariables = data['content']['inputVariables'];
    for (var item in inputVariables) {
      final value = inputValue[item['name'] as String];
      if (value != null) {
        item['variableValue'] = value;
      }
    }
    data.remove('nodeStatus');
    String jsonString = jsonEncode(data);
    print("====jsonString $jsonString");
    final res = await TencentImSDKPlugin.v2TIMManager
        .getMessageManager()
        .createCustomMessage(data: jsonString);
    if (res.code == 0) {
      final messageResult = res.data;
      V2TimMessage? messageInfo = messageResult!.messageInfo;
      if (!kIsWeb && (Platform.isMacOS || Platform.isWindows)) {
        messageInfo?.id = messageResult.id;
      }
      widget.onSubmitForm(messageInfo: messageInfo);
      return messageResult;
    }
    return null;
  }

  @override
  Widget timBuild(BuildContext context) {
    final tip = widget.payload['content']['tip'] ?? '';
    final nodeStatus = widget.payload['nodeStatus'] ?? 2;
    GlobalKey<FormState> _formKey = GlobalKey();
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      margin: const EdgeInsets.only(left: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
          Expanded(child: Text(tip)),
          (nodeStatus == 2 || isSubmited == true)
              ? const Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: Colors.green, size: 16),
                    SizedBox(
                      width: 5,
                    ),
                    Text("已提交")
                  ],
                )
              : Container()
                      ],
                    ),
          const SizedBox(
            height: 15,
          ),
          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getInputForm(),
                  (nodeStatus != 2 && isSubmited == false)
                      ? Center(
                          child: GestureDetector(
                              onTap: () {
                                if (nodeStatus == 0 &&
                                    _formKey.currentState!.validate()) {
                                  handleSubmit();
                                  setState(() {
                                    isSubmited = true;
                                  });
                                }
                              },
                              child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 25),
                                  decoration: BoxDecoration(
                                    color:
                                        (nodeStatus == 0 && isSubmited == false)
                                            ? Colors.blue
                                            : Colors.grey,
                                    borderRadius: const BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    "提交",
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        )
                      : Container()
                ],
              ))
        ],
      ),
    );
  }
}
