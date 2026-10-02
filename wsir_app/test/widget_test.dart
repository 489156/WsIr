import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:wsir_app/data/services/gemini_proxy_service.dart';
import 'package:wsir_app/data/repositories/chat_repository.dart';
import 'package:wsir_app/ui/features/chat/view_models/chat_view_model.dart';
import 'package:wsir_app/main.dart';

void main() {
  testWidgets('WsIr ChatScreen smoke test - UI components rendering', (WidgetTester tester) async {
    final proxyService = GeminiProxyService();
    final repository = ChatRepository(proxyService: proxyService);
    final viewModel = ChatViewModel(repository: repository);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<GeminiProxyService>.value(value: proxyService),
          ProxyProvider<GeminiProxyService, ChatRepository>(
            update: (_, proxy, _) => repository,
          ),
          ChangeNotifierProvider<ChatViewModel>.value(value: viewModel),
        ],
        child: const MyApp(),
      ),
    );

    // Verify Title
    expect(find.text('WsIr (와이서) - AI 메신저 코파일럿'), findsOneWidget);

    // Verify Dropdown & Input fields
    expect(find.text('대화 상대 (관계)'), findsOneWidget);
    expect(find.text('상대방의 마지막 메시지'), findsOneWidget);
    expect(find.text('나의 희망 의도 (선택)'), findsOneWidget);

    // Verify Image Picker button
    expect(find.text('캡처 화면 첨부'), findsOneWidget);

    // Verify Generate Button
    expect(find.text('✨ AI 답장 추천받기'), findsOneWidget);
  });
}
