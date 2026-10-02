import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_result.freezed.dart';
part 'analysis_result.g.dart';

@freezed
abstract class AnalysisResult with _$AnalysisResult {
  const factory AnalysisResult({
    required AnalysisDetails analysis,
    required List<ChatCandidate> candidates,
  }) = _AnalysisResult;

  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);
}

@freezed
abstract class AnalysisDetails with _$AnalysisDetails {
  const factory AnalysisDetails({
    required String intent,
    required String emotion,
    required String subtext,
    required String whatTheyWant,
    required String strategy,
    @Default([]) List<String> redFlags,
  }) = _AnalysisDetails;

  factory AnalysisDetails.fromJson(Map<String, dynamic> json) =>
      _$AnalysisDetailsFromJson(json);
}

@freezed
abstract class ChatCandidate with _$ChatCandidate {
  const factory ChatCandidate({
    required String tier,
    required String tone,
    required String text,
    required String rationale,
    String? wowDetail,
  }) = _ChatCandidate;

  factory ChatCandidate.fromJson(Map<String, dynamic> json) =>
      _$ChatCandidateFromJson(json);
}
