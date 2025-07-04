import 'dart:io';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_with_gimini/feature/chat/data/model/message_model.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<MessageModel>>(
  (ref) => ChatNotifier(),
);

class ChatNotifier extends StateNotifier<List<MessageModel>> {
  ChatNotifier() : super([]);

  File? img;

  void sendImage(File? image) {
    img = image;
    state = [...state];
  }

  void removeImg() {
    img = null;
    state = [...state];
  }

  Future<void> sendMessage(String txt, Function(String) speek) async {
    if (txt.trim().isEmpty && img == null) return;

    state = [...state, MessageModel(text: txt, image: img, isUser: true)];
    state = [...state, MessageModel(text: "...", isUser: false)];

    String aiRespns = "xatolik";

    try {
      if (img != null) {
        final imageBytes = await img!.readAsBytes();
        final res = await Gemini.instance.textAndImage(
          text: txt,
          images: [imageBytes],
        );
        aiRespns = res?.output ?? "javob yoq";
      } else {
        final res = await Gemini.instance.text(txt);
        aiRespns = res?.output ?? "";

        await speek(aiRespns);
      }

      state = [
        ...state.sublist(0, state.length - 1),
        MessageModel(text: aiRespns, isUser: false),
      ];
    } catch (e) {
      state = [
        ...state.sublist(0, state.length - 1),
        MessageModel(text: aiRespns, isUser: false),
      ];
      print("Gemini API xatoligi: $e");
    }
  }
}
