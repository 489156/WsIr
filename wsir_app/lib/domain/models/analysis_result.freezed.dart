// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analysis_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalysisResult {

 AnalysisDetails get analysis; List<ChatCandidate> get candidates;
/// Create a copy of AnalysisResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisResultCopyWith<AnalysisResult> get copyWith => _$AnalysisResultCopyWithImpl<AnalysisResult>(this as AnalysisResult, _$identity);

  /// Serializes this AnalysisResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AnalysisResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisResult&&(identical(other.analysis, _this.analysis) || other.analysis == _this.analysis)&&const DeepCollectionEquality().equals(other.candidates, _this.candidates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AnalysisResult;
  return Object.hash(runtimeType,_this.analysis,const DeepCollectionEquality().hash(_this.candidates));
}

@override
String toString() {
  final _this = this as AnalysisResult;
  return 'AnalysisResult(analysis: ${_this.analysis}, candidates: ${_this.candidates})';
}


}

/// @nodoc
abstract mixin class $AnalysisResultCopyWith<$Res>  {
  factory $AnalysisResultCopyWith(AnalysisResult value, $Res Function(AnalysisResult) _then) = _$AnalysisResultCopyWithImpl;
@useResult
$Res call({
 AnalysisDetails analysis, List<ChatCandidate> candidates
});


$AnalysisDetailsCopyWith<$Res> get analysis;

}
/// @nodoc
class _$AnalysisResultCopyWithImpl<$Res>
    implements $AnalysisResultCopyWith<$Res> {
  _$AnalysisResultCopyWithImpl(this._self, this._then);

  final AnalysisResult _self;
  final $Res Function(AnalysisResult) _then;

/// Create a copy of AnalysisResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? analysis = null,Object? candidates = null,}) {
  return _then(AnalysisResult(
analysis: null == analysis ? _self.analysis : analysis // ignore: cast_nullable_to_non_nullable
as AnalysisDetails,candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<ChatCandidate>,
  ));
}
/// Create a copy of AnalysisResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisDetailsCopyWith<$Res> get analysis {
  
  return $AnalysisDetailsCopyWith<$Res>(_self.analysis, (value) {
    return _then(_self.copyWith(analysis: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalysisResult].
extension AnalysisResultPatterns on AnalysisResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalysisResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalysisResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalysisResult value)  $default,){
final _that = this;
switch (_that) {
case _AnalysisResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalysisResult value)?  $default,){
final _that = this;
switch (_that) {
case _AnalysisResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalysisDetails analysis,  List<ChatCandidate> candidates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalysisResult() when $default != null:
return $default(_that.analysis,_that.candidates);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalysisDetails analysis,  List<ChatCandidate> candidates)  $default,) {final _that = this;
switch (_that) {
case _AnalysisResult():
return $default(_that.analysis,_that.candidates);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalysisDetails analysis,  List<ChatCandidate> candidates)?  $default,) {final _that = this;
switch (_that) {
case _AnalysisResult() when $default != null:
return $default(_that.analysis,_that.candidates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalysisResult implements AnalysisResult {
  const _AnalysisResult({required this.analysis, required  List<ChatCandidate> candidates}): _candidates = candidates;
  factory _AnalysisResult.fromJson(Map<String, dynamic> json) => _$AnalysisResultFromJson(json);

@override final  AnalysisDetails analysis;
 final  List<ChatCandidate> _candidates;
@override List<ChatCandidate> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}


/// Create a copy of AnalysisResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisResultCopyWith<_AnalysisResult> get copyWith => __$AnalysisResultCopyWithImpl<_AnalysisResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalysisResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalysisResult&&(identical(other.analysis, analysis) || other.analysis == analysis)&&const DeepCollectionEquality().equals(other.candidates, _candidates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,analysis,const DeepCollectionEquality().hash(_candidates));
}

@override
String toString() {
    return 'AnalysisResult(analysis: $analysis, candidates: $candidates)';
}


}

/// @nodoc
abstract mixin class _$AnalysisResultCopyWith<$Res> implements $AnalysisResultCopyWith<$Res> {
  factory _$AnalysisResultCopyWith(_AnalysisResult value, $Res Function(_AnalysisResult) _then) = __$AnalysisResultCopyWithImpl;
@override @useResult
$Res call({
 AnalysisDetails analysis, List<ChatCandidate> candidates
});


@override $AnalysisDetailsCopyWith<$Res> get analysis;

}
/// @nodoc
class __$AnalysisResultCopyWithImpl<$Res>
    implements _$AnalysisResultCopyWith<$Res> {
  __$AnalysisResultCopyWithImpl(this._self, this._then);

  final _AnalysisResult _self;
  final $Res Function(_AnalysisResult) _then;

/// Create a copy of AnalysisResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? analysis = null,Object? candidates = null,}) {
  return _then(_AnalysisResult(
analysis: null == analysis ? _self.analysis : analysis // ignore: cast_nullable_to_non_nullable
as AnalysisDetails,candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<ChatCandidate>,
  ));
}

/// Create a copy of AnalysisResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisDetailsCopyWith<$Res> get analysis {
  
  return $AnalysisDetailsCopyWith<$Res>(_self.analysis, (value) {
    return _then(_self.copyWith(analysis: value));
  });
}
}


/// @nodoc
mixin _$AnalysisDetails {

 String get intent; String get emotion; String get subtext; String get whatTheyWant; String get strategy; List<String> get redFlags;
/// Create a copy of AnalysisDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisDetailsCopyWith<AnalysisDetails> get copyWith => _$AnalysisDetailsCopyWithImpl<AnalysisDetails>(this as AnalysisDetails, _$identity);

  /// Serializes this AnalysisDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AnalysisDetails;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisDetails&&(identical(other.intent, _this.intent) || other.intent == _this.intent)&&(identical(other.emotion, _this.emotion) || other.emotion == _this.emotion)&&(identical(other.subtext, _this.subtext) || other.subtext == _this.subtext)&&(identical(other.whatTheyWant, _this.whatTheyWant) || other.whatTheyWant == _this.whatTheyWant)&&(identical(other.strategy, _this.strategy) || other.strategy == _this.strategy)&&const DeepCollectionEquality().equals(other.redFlags, _this.redFlags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AnalysisDetails;
  return Object.hash(runtimeType,_this.intent,_this.emotion,_this.subtext,_this.whatTheyWant,_this.strategy,const DeepCollectionEquality().hash(_this.redFlags));
}

@override
String toString() {
  final _this = this as AnalysisDetails;
  return 'AnalysisDetails(intent: ${_this.intent}, emotion: ${_this.emotion}, subtext: ${_this.subtext}, whatTheyWant: ${_this.whatTheyWant}, strategy: ${_this.strategy}, redFlags: ${_this.redFlags})';
}


}

/// @nodoc
abstract mixin class $AnalysisDetailsCopyWith<$Res>  {
  factory $AnalysisDetailsCopyWith(AnalysisDetails value, $Res Function(AnalysisDetails) _then) = _$AnalysisDetailsCopyWithImpl;
@useResult
$Res call({
 String intent, String emotion, String subtext, String whatTheyWant, String strategy, List<String> redFlags
});




}
/// @nodoc
class _$AnalysisDetailsCopyWithImpl<$Res>
    implements $AnalysisDetailsCopyWith<$Res> {
  _$AnalysisDetailsCopyWithImpl(this._self, this._then);

  final AnalysisDetails _self;
  final $Res Function(AnalysisDetails) _then;

/// Create a copy of AnalysisDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? intent = null,Object? emotion = null,Object? subtext = null,Object? whatTheyWant = null,Object? strategy = null,Object? redFlags = null,}) {
  return _then(AnalysisDetails(
intent: null == intent ? _self.intent : intent // ignore: cast_nullable_to_non_nullable
as String,emotion: null == emotion ? _self.emotion : emotion // ignore: cast_nullable_to_non_nullable
as String,subtext: null == subtext ? _self.subtext : subtext // ignore: cast_nullable_to_non_nullable
as String,whatTheyWant: null == whatTheyWant ? _self.whatTheyWant : whatTheyWant // ignore: cast_nullable_to_non_nullable
as String,strategy: null == strategy ? _self.strategy : strategy // ignore: cast_nullable_to_non_nullable
as String,redFlags: null == redFlags ? _self.redFlags : redFlags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalysisDetails].
extension AnalysisDetailsPatterns on AnalysisDetails {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalysisDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalysisDetails() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalysisDetails value)  $default,){
final _that = this;
switch (_that) {
case _AnalysisDetails():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalysisDetails value)?  $default,){
final _that = this;
switch (_that) {
case _AnalysisDetails() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String intent,  String emotion,  String subtext,  String whatTheyWant,  String strategy,  List<String> redFlags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalysisDetails() when $default != null:
return $default(_that.intent,_that.emotion,_that.subtext,_that.whatTheyWant,_that.strategy,_that.redFlags);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String intent,  String emotion,  String subtext,  String whatTheyWant,  String strategy,  List<String> redFlags)  $default,) {final _that = this;
switch (_that) {
case _AnalysisDetails():
return $default(_that.intent,_that.emotion,_that.subtext,_that.whatTheyWant,_that.strategy,_that.redFlags);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String intent,  String emotion,  String subtext,  String whatTheyWant,  String strategy,  List<String> redFlags)?  $default,) {final _that = this;
switch (_that) {
case _AnalysisDetails() when $default != null:
return $default(_that.intent,_that.emotion,_that.subtext,_that.whatTheyWant,_that.strategy,_that.redFlags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalysisDetails implements AnalysisDetails {
  const _AnalysisDetails({required this.intent, required this.emotion, required this.subtext, required this.whatTheyWant, required this.strategy,  List<String> redFlags = const []}): _redFlags = redFlags;
  factory _AnalysisDetails.fromJson(Map<String, dynamic> json) => _$AnalysisDetailsFromJson(json);

@override final  String intent;
@override final  String emotion;
@override final  String subtext;
@override final  String whatTheyWant;
@override final  String strategy;
 final  List<String> _redFlags;
@override@JsonKey() List<String> get redFlags {
  if (_redFlags is EqualUnmodifiableListView) return _redFlags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_redFlags);
}


/// Create a copy of AnalysisDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisDetailsCopyWith<_AnalysisDetails> get copyWith => __$AnalysisDetailsCopyWithImpl<_AnalysisDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalysisDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalysisDetails&&(identical(other.intent, intent) || other.intent == intent)&&(identical(other.emotion, emotion) || other.emotion == emotion)&&(identical(other.subtext, subtext) || other.subtext == subtext)&&(identical(other.whatTheyWant, whatTheyWant) || other.whatTheyWant == whatTheyWant)&&(identical(other.strategy, strategy) || other.strategy == strategy)&&const DeepCollectionEquality().equals(other.redFlags, _redFlags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,intent,emotion,subtext,whatTheyWant,strategy,const DeepCollectionEquality().hash(_redFlags));
}

@override
String toString() {
    return 'AnalysisDetails(intent: $intent, emotion: $emotion, subtext: $subtext, whatTheyWant: $whatTheyWant, strategy: $strategy, redFlags: $redFlags)';
}


}

/// @nodoc
abstract mixin class _$AnalysisDetailsCopyWith<$Res> implements $AnalysisDetailsCopyWith<$Res> {
  factory _$AnalysisDetailsCopyWith(_AnalysisDetails value, $Res Function(_AnalysisDetails) _then) = __$AnalysisDetailsCopyWithImpl;
@override @useResult
$Res call({
 String intent, String emotion, String subtext, String whatTheyWant, String strategy, List<String> redFlags
});




}
/// @nodoc
class __$AnalysisDetailsCopyWithImpl<$Res>
    implements _$AnalysisDetailsCopyWith<$Res> {
  __$AnalysisDetailsCopyWithImpl(this._self, this._then);

  final _AnalysisDetails _self;
  final $Res Function(_AnalysisDetails) _then;

/// Create a copy of AnalysisDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? intent = null,Object? emotion = null,Object? subtext = null,Object? whatTheyWant = null,Object? strategy = null,Object? redFlags = null,}) {
  return _then(_AnalysisDetails(
intent: null == intent ? _self.intent : intent // ignore: cast_nullable_to_non_nullable
as String,emotion: null == emotion ? _self.emotion : emotion // ignore: cast_nullable_to_non_nullable
as String,subtext: null == subtext ? _self.subtext : subtext // ignore: cast_nullable_to_non_nullable
as String,whatTheyWant: null == whatTheyWant ? _self.whatTheyWant : whatTheyWant // ignore: cast_nullable_to_non_nullable
as String,strategy: null == strategy ? _self.strategy : strategy // ignore: cast_nullable_to_non_nullable
as String,redFlags: null == redFlags ? _self._redFlags : redFlags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ChatCandidate {

 String get tier; String get tone; String get text; String get rationale; String? get wowDetail;
/// Create a copy of ChatCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCandidateCopyWith<ChatCandidate> get copyWith => _$ChatCandidateCopyWithImpl<ChatCandidate>(this as ChatCandidate, _$identity);

  /// Serializes this ChatCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatCandidate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatCandidate&&(identical(other.tier, _this.tier) || other.tier == _this.tier)&&(identical(other.tone, _this.tone) || other.tone == _this.tone)&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.rationale, _this.rationale) || other.rationale == _this.rationale)&&(identical(other.wowDetail, _this.wowDetail) || other.wowDetail == _this.wowDetail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatCandidate;
  return Object.hash(runtimeType,_this.tier,_this.tone,_this.text,_this.rationale,_this.wowDetail);
}

@override
String toString() {
  final _this = this as ChatCandidate;
  return 'ChatCandidate(tier: ${_this.tier}, tone: ${_this.tone}, text: ${_this.text}, rationale: ${_this.rationale}, wowDetail: ${_this.wowDetail})';
}


}

/// @nodoc
abstract mixin class $ChatCandidateCopyWith<$Res>  {
  factory $ChatCandidateCopyWith(ChatCandidate value, $Res Function(ChatCandidate) _then) = _$ChatCandidateCopyWithImpl;
@useResult
$Res call({
 String tier, String tone, String text, String rationale, String? wowDetail
});




}
/// @nodoc
class _$ChatCandidateCopyWithImpl<$Res>
    implements $ChatCandidateCopyWith<$Res> {
  _$ChatCandidateCopyWithImpl(this._self, this._then);

  final ChatCandidate _self;
  final $Res Function(ChatCandidate) _then;

/// Create a copy of ChatCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tier = null,Object? tone = null,Object? text = null,Object? rationale = null,Object? wowDetail = freezed,}) {
  return _then(ChatCandidate(
tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,wowDetail: freezed == wowDetail ? _self.wowDetail : wowDetail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatCandidate].
extension ChatCandidatePatterns on ChatCandidate {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatCandidate() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatCandidate value)  $default,){
final _that = this;
switch (_that) {
case _ChatCandidate():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _ChatCandidate() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tier,  String tone,  String text,  String rationale,  String? wowDetail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatCandidate() when $default != null:
return $default(_that.tier,_that.tone,_that.text,_that.rationale,_that.wowDetail);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tier,  String tone,  String text,  String rationale,  String? wowDetail)  $default,) {final _that = this;
switch (_that) {
case _ChatCandidate():
return $default(_that.tier,_that.tone,_that.text,_that.rationale,_that.wowDetail);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tier,  String tone,  String text,  String rationale,  String? wowDetail)?  $default,) {final _that = this;
switch (_that) {
case _ChatCandidate() when $default != null:
return $default(_that.tier,_that.tone,_that.text,_that.rationale,_that.wowDetail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatCandidate implements ChatCandidate {
  const _ChatCandidate({required this.tier, required this.tone, required this.text, required this.rationale, this.wowDetail});
  factory _ChatCandidate.fromJson(Map<String, dynamic> json) => _$ChatCandidateFromJson(json);

@override final  String tier;
@override final  String tone;
@override final  String text;
@override final  String rationale;
@override final  String? wowDetail;

/// Create a copy of ChatCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCandidateCopyWith<_ChatCandidate> get copyWith => __$ChatCandidateCopyWithImpl<_ChatCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatCandidate&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.tone, tone) || other.tone == tone)&&(identical(other.text, text) || other.text == text)&&(identical(other.rationale, rationale) || other.rationale == rationale)&&(identical(other.wowDetail, wowDetail) || other.wowDetail == wowDetail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tier,tone,text,rationale,wowDetail);
}

@override
String toString() {
    return 'ChatCandidate(tier: $tier, tone: $tone, text: $text, rationale: $rationale, wowDetail: $wowDetail)';
}


}

/// @nodoc
abstract mixin class _$ChatCandidateCopyWith<$Res> implements $ChatCandidateCopyWith<$Res> {
  factory _$ChatCandidateCopyWith(_ChatCandidate value, $Res Function(_ChatCandidate) _then) = __$ChatCandidateCopyWithImpl;
@override @useResult
$Res call({
 String tier, String tone, String text, String rationale, String? wowDetail
});




}
/// @nodoc
class __$ChatCandidateCopyWithImpl<$Res>
    implements _$ChatCandidateCopyWith<$Res> {
  __$ChatCandidateCopyWithImpl(this._self, this._then);

  final _ChatCandidate _self;
  final $Res Function(_ChatCandidate) _then;

/// Create a copy of ChatCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tier = null,Object? tone = null,Object? text = null,Object? rationale = null,Object? wowDetail = freezed,}) {
  return _then(_ChatCandidate(
tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as String,tone: null == tone ? _self.tone : tone // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,rationale: null == rationale ? _self.rationale : rationale // ignore: cast_nullable_to_non_nullable
as String,wowDetail: freezed == wowDetail ? _self.wowDetail : wowDetail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
