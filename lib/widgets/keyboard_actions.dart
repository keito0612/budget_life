import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:flutter/material.dart';

class KeyboardActionsConfigWidget {
  static KeyboardActionsConfig buildConfig(
      BuildContext context, FocusNode nodeText) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.green,
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: nodeText,
          toolbarAlignment: MainAxisAlignment.start,
          displayArrows: false,
          toolbarButtons: [
            (node) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 330),
                      child: GestureDetector(
                        onTap: () => node.unfocus(),
                        child: const Text(
                          "完了",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          ],
        ),
      ],
    );
  }
}
