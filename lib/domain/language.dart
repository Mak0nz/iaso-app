import 'package:flutter_riverpod/flutter_riverpod.dart';

// flag from: https://emojipedia.org/flags
enum Language {
  english(flag: '🇬🇧', name: 'English', code: 'en'),
  hungarian(flag: '🇭🇺', name: 'Magyar', code: 'hu');

  const Language({required this.flag, required this.name, required this.code});

  final String flag;
  final String name;
  final String code;
}

final languageProvider = StateProvider<Language>((ref) => Language.english);
