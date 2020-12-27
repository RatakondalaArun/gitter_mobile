import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController textController;
  final FocusNode focusNode;
  final void Function(String value) onSend;

  const MessageInput({
    Key key,
    @required this.textController,
    @required this.focusNode,
    this.onSend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width - 80,
                child: TextField(
                  focusNode: focusNode,
                  controller: textController,
                  scrollPhysics: BouncingScrollPhysics(),
                  enableInteractiveSelection: true,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 20,
                  inputFormatters: [],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    border: InputBorder.none,
                    hintText: 'Send a message, We support markdown',
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: IconButton(
                  tooltip: 'Send',
                  splashRadius: 30,
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: _onSend,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _onSend() {
    if (textController.text.isEmpty) return;
    onSend?.call(textController.text.trim());
    textController.text = '';
  }
}
