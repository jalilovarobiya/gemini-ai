import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_with_gimini/model/message_model.dart';
import 'package:project_with_gimini/view/widget/chat_body.dart';

class GiminiScreen extends StatefulWidget {
  const GiminiScreen({super.key});

  @override
  State<GiminiScreen> createState() => _GiminiScreenState();
}

class _GiminiScreenState extends State<GiminiScreen> {
  final controller = TextEditingController();
  List<MessageModel> messages = [];
  File? img;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gimini app",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: ChatBody(messages: messages),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            IconButton(
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                  maxHeight: 1024,
                  maxWidth: 1024,
                );
                if (image != null) {
                  setState(() {
                    img = File(image.path);
                  });
                }
              },
              icon: Icon(Icons.image, size: 30, color: Colors.blue),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Matn kiriting",
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: Icon(Icons.send, size: 40, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    print(controller.text);
    final txt = controller.text.trim();
    if (txt.isEmpty && img == null) return;

    final msg = MessageModel(text: txt, image: img, isUser: true);
    setState(() {
      messages.add(msg);
      messages.add(MessageModel(text: "...", isUser: false));
    });

    controller.clear();
    final File? localImg = img;
    String aiRespns = "xatolik";

    try {
      if (localImg != null) {
        final imageBytes = await localImg.readAsBytes();

        await Gemini.instance
            .textAndImage(text: txt, images: [imageBytes])
            .then((res) {
              aiRespns = res?.output ?? "javob yoq";
            });
      } else {
        final response = await Gemini.instance.text(txt);
        aiRespns = response?.output ?? "";
      }
    } catch (e) {
      aiRespns = "xatolik: $e";
      print("Gemini API xatoligi: $e");
    }

    setState(() {
      messages.removeLast();
      messages.add(MessageModel(text: aiRespns, isUser: false));
      img = null;
    });
  }
}
