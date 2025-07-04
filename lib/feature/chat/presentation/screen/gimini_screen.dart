import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_with_gimini/core/utils/tts_helper.dart';
import 'package:project_with_gimini/feature/chat/controller/chat_provider.dart';
import 'package:project_with_gimini/feature/chat/data/model/message_model.dart';
import 'package:project_with_gimini/feature/chat/presentation/widget/chat_body.dart';

class GiminiScreen extends ConsumerStatefulWidget {
  const GiminiScreen({super.key});

  @override
  ConsumerState<GiminiScreen> createState() => _GiminiScreenState();
}

class _GiminiScreenState extends ConsumerState<GiminiScreen> {
  final controller = TextEditingController();
  final ttsHelper = TtsHelper();

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);
    final chatNotifier = ref.read(chatProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Gimini App",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: [
          PopupMenuButton(
            iconColor: Colors.white,
            onSelected: (value) => print("Tanlandi: $value"),
            itemBuilder:
                (context) => [
                  const PopupMenuItem(value: 'Dart', child: Text('Dart')),
                  const PopupMenuItem(value: 'Python', child: Text('Python')),
                ],
          ),
        ],
      ),
      body: ChatBody(messages: messages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rasm ko'rsatish bloki - TextField ustida
            if (chatNotifier.img != null)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        chatNotifier.img!,
                        width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        onPressed: () => chatNotifier.removeImg(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Input qismi
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image, size: 30, color: Colors.white),
                  onPressed: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                      maxHeight: 1024,
                      maxWidth: 1024,
                    );
                    if (image != null) {
                      chatNotifier.sendImage(File(image.path));
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: controller,
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      hintStyle: TextStyle(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      hintText: "Matn kiriting",
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(chatNotifier),
                  ),
                ),
                IconButton(
                  onPressed: () => _sendMessage(chatNotifier),
                  icon: const Icon(
                    Icons.keyboard_voice_outlined,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () => _sendMessage(chatNotifier),
                  icon: const Icon(Icons.send, size: 35, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(ChatNotifier notifier) async {
    final text = controller.text;
    controller.clear();
    await notifier.sendMessage(text, (msg) => ttsHelper.speak(msg));
  }
}
