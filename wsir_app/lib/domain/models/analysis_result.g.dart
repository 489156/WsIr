// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) =>
    _AnalysisResult(
      analysis: AnalysisDetails.fromJson(
        json['analysis'] as Map<String, dynamic>,
      ),
      candidates: (json['candidates'] as List<dynamic>)
          .map((e) => ChatCandidate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AnalysisResultToJson(_AnalysisResult instance) =>
    <String, dynamic>{
      'analysis': instance.analysis,
      'candidates': instance.candidates,
    };

_AnalysisDetails _$AnalysisDetailsFromJson(Map<String, dynamic> json) =>
    _AnalysisDetails(
      intent: json['intent'] as String,
      emotion: json['emotion'] as String,
      subtext: json['subtext'] as String,
      whatTheyWant: json['whatTheyWant'] as String,
      strategy: json['strategy'] as String,
      redFlags:
          (json['redFlags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AnalysisDetailsToJson(_AnalysisDetails instance) =>
    <String, dynamic>{
      'intent': instance.intent,
      'emotion': instance.emotion,
      'subtext': instance.subtext,
      'whatTheyWant': instance.whatTheyWant,
      'strategy': instance.strategy,
      'redFlags': instance.redFlags,
    };

_ChatCandidate _$ChatCandidateFromJson(Map<String, dynamic> json) =>
    _ChatCandidate(
      tier: json['tier'] as String,
      tone: json['tone'] as String,
      text: json['text'] as String,
      rationale: json['rationale'] as String,
      wowDetail: json['wowDetail'] as String?,
    );

Map<String, dynamic> _$ChatCandidateToJson(_ChatCandidate instance) =>
    <String, dynamic>{
      'tier': instance.tier,
      'tone': instance.tone,
      'text': instance.text,
      'rationale': instance.rationale,
      'wowDetail': instance.wowDetail,
    };
