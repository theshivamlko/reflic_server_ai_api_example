import 'dart:convert';
import 'dart:typed_data';

import 'package:googleai_dart/googleai_dart.dart';
import 'package:relic/relic.dart';

/// Handles requests to the image generation endpoint.
Future<Response> imageGeneration(final Request req) async {
  final method = req.method;

  final prompt = req.queryParameters.raw['prompt'];

  if (prompt == null || prompt.isEmpty) {
    return Response.badRequest(body: Body.fromString('Prompt required'));
  }

  try {
    final resultBase64 = await callGeminiApi(prompt);
    return Response.ok(
      body: Body.fromString(resultBase64 ?? 'No image generated.'),
    );
  } catch (e) {
    print('Error calling Gemini API: $e');
    return Response.internalServerError(
      body: Body.fromString('Error generating image.'),
    );
  }
}
 
Future<String?> callGeminiApi(String prompt, {String? imageBase64}) async {
  final ai_client = GoogleAIClient.fromEnvironment();

  List<Content> contents = [Content.text(prompt)];

  if (imageBase64 != null) {
    contents.add(
      Content.fromParts([
        InlineDataPart(Blob(mimeType: 'image/jpeg', data: imageBase64)),
      ]),
    );
  }

  GenerateContentResponse response = await ai_client.models.generateContent(
    model: "gemini-2.5-flash-image",
    request: GenerateContentRequest(
      contents: [Content.text(prompt)],
      generationConfig: GenerationConfig(
        imageConfig: ImageConfig(aspectRatio: "9:16", imageSize: "1K"),
      ),
    ),
  );

  final parts = response.candidates?.first.content?.parts ?? const [];

  String defaultResponse = "No image generated.";

  for (final part in parts) {
    final partMap = part.toJson();

    if (partMap["inlineData"]?["mimeType"]?.startsWith('image/') == true) {
      print("Response:");
      final base64Data = partMap["inlineData"]["data"] as String?;
      return base64Data;
    }
  }

  return defaultResponse;
}
