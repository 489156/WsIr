import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'data/services/gemini_proxy_service.dart';
import 'data/repositories/chat_repository.dart';
import 'ui/features/chat/view_models/chat_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<GeminiProxyService>(
          create: (_) => GeminiProxyService(),
        ),
        ProxyProvider<GeminiProxyService, ChatRepository>(
          update: (_, proxyService, _) => 
              ChatRepository(proxyService: proxyService),
        ),
        ChangeNotifierProxyProvider<ChatRepository, ChatViewModel>(
          create: (context) => ChatViewModel(
            repository: Provider.of<ChatRepository>(context, listen: false),
          ),
          update: (_, repository, previous) => 
              previous ?? ChatViewModel(repository: repository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WsIr App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4EE0CB)),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  final TextEditingController _intentController = TextEditingController();
  String _selectedRelation = 'friend';
  File? _selectedImage;
  String? _imageBase64;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _selectedImage = File(image.path);
        _imageBase64 = base64Encode(bytes);
        _msgController.clear();
      });
    }
  }

  final List<String> _relations = [
    'boss', 'client', 'senior', 'colleague', 'junior', 
    'professor', 'inlaws', 'freelance', 'blind_date', 
    'school', 'romantic', 'parent', 'sibling', 'friend'
  ];

  @override
  void dispose() {
    _msgController.dispose();
    _intentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('WsIr (와이서) - AI 메신저 코파일럿'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              viewModel.clearHistory();
              _msgController.clear();
              _intentController.clear();
            },
            tooltip: '히스토리 초기화',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // History Indicator
            if (viewModel.chatHistory.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.teal.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '💬 누적 대화: ${(viewModel.chatHistory.length / 2).floor()}턴',
                  style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ),

            // Relation Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedRelation,
              decoration: const InputDecoration(labelText: '대화 상대 (관계)'),
              items: _relations.map((r) => DropdownMenuItem(
                value: r,
                child: Text(r),
              )).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedRelation = val);
              },
            ),
            const SizedBox(height: 16),

            // Last Message Input
            TextField(
              controller: _msgController,
              decoration: const InputDecoration(
                labelText: '상대방의 마지막 메시지',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Intent Input
            TextField(
              controller: _intentController,
              decoration: const InputDecoration(
                labelText: '나의 희망 의도 (선택)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Image Picker Button & Preview
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('캡처 화면 첨부'),
                ),
                const SizedBox(width: 16),
                if (_selectedImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          _selectedImage = null;
                          _imageBase64 = null;
                        }),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Generate Button
            ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () {
                      viewModel.generateReply(
                        _selectedRelation,
                        _msgController.text,
                        _intentController.text,
                        imageBase64: _imageBase64,
                      );
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: viewModel.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('✨ AI 답장 추천받기', style: TextStyle(fontSize: 16)),
            ),
            
            const SizedBox(height: 32),

            // Results Section
            if (viewModel.errorMessage != null)
              Text(viewModel.errorMessage!, style: const TextStyle(color: Colors.red)),
              
            if (viewModel.currentAnalysis != null) ...[
              const Text('🔍 의도 분석', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('서브텍스트: ${viewModel.currentAnalysis!.analysis.subtext}'),
                      Text('전략: ${viewModel.currentAnalysis!.analysis.strategy}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              const Text('💡 추천 답장', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...viewModel.currentAnalysis!.candidates.asMap().entries.map((entry) {
                final idx = entry.key;
                final cand = entry.value;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cand.tier == 'wow' ? '⚡ ${cand.tone}' : cand.tone,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: cand.tier == 'wow' ? Colors.orange : Colors.blue,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                viewModel.continueConversation(idx, _msgController.text);
                                _msgController.clear();
                              },
                              child: const Text('💬 이어가기'),
                            )
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(cand.text, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('💡 ${cand.rationale}', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
