import 'package:flutter/foundation.dart';
import '../../../../data/repositories/chat_repository.dart';
import '../../../../domain/models/analysis_result.dart';

class ChatViewModel extends ChangeNotifier {
  ChatViewModel({required this.repository});

  final ChatRepository repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AnalysisResult? _currentAnalysis;
  AnalysisResult? get currentAnalysis => _currentAnalysis;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // History state
  final List<Map<String, String>> _chatHistory = [];
  List<Map<String, String>> get chatHistory => List.unmodifiable(_chatHistory);

  Future<void> generateReply(String relation, String lastMessage, String intentContext, {String? imageBase64}) async {
    if (lastMessage.trim().isEmpty && imageBase64 == null) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentAnalysis = await repository.analyzeChat(
        relation: relation,
        lastMessage: lastMessage,
        context: intentContext,
        chatHistory: _chatHistory,
        imageBase64: imageBase64,
      );
    } catch (e) {
      _errorMessage = '답장을 생성하는 중 오류가 발생했습니다: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void continueConversation(int candidateIndex, String lastMessageReceived) {
    if (_currentAnalysis == null) return;
    
    final selectedCandidate = _currentAnalysis!.candidates[candidateIndex];
    
    if (lastMessageReceived.isNotEmpty) {
      _chatHistory.add({'side': 'other', 'text': lastMessageReceived});
    }
    _chatHistory.add({'side': 'me', 'text': selectedCandidate.text});
    
    _currentAnalysis = null;
    notifyListeners();
  }

  void clearHistory() {
    _chatHistory.clear();
    _currentAnalysis = null;
    notifyListeners();
  }
}
