import '../../domain/models/analysis_result.dart';
import '../services/gemini_proxy_service.dart';

class ChatRepository {
  ChatRepository({required this.proxyService});

  final GeminiProxyService proxyService;

  Future<AnalysisResult> analyzeChat({
    required String relation,
    required String lastMessage,
    required String context,
    required List<Map<String, String>> chatHistory,
    String? imageBase64,
  }) async {
    try {
      final rawData = await proxyService.generateReply(
        relation: relation,
        lastMessage: lastMessage,
        context: context,
        chatHistory: chatHistory,
        imageBase64: imageBase64,
      );

      return AnalysisResult.fromJson(rawData);
    } catch (e) {
      rethrow;
    }
  }
}
