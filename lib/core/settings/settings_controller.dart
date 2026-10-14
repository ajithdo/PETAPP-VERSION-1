import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers.dart';

/// Device-level preferences: language, theme, Easy mode, text size,
/// high contrast, notification channels and quiet hours.
class AppSettings {
  const AppSettings({
    this.locale = 'en',
    this.themeMode = ThemeMode.system,
    this.easyMode = false,
    this.textScale = 1.0,
    this.highContrast = false,
    this.onboardingSeen = false,
    this.languageChosen = false,
    this.selectedPetId,
    this.channels = const {},
    this.quietStart = 22,
    this.quietEnd = 7,
    this.quietHoursOn = true,
    this.vaultPinSet = false,
  });

  final String locale;
  final ThemeMode themeMode;
  final bool easyMode;
  final double textScale;
  final bool highContrast;
  final bool onboardingSeen;
  final bool languageChosen;
  final String? selectedPetId;

  /// reminder type -> list of channels (push, email, sms, whatsapp)
  final Map<String, List<String>> channels;
  final int quietStart;
  final int quietEnd;
  final bool quietHoursOn;
  final bool vaultPinSet;

  /// Easy mode makes text 25% larger on top of the user's own text size.
  double get effectiveTextScale => textScale * (easyMode ? 1.25 : 1.0);

  List<String> channelsFor(String type) => channels[type] ?? const ['push'];

  AppSettings copyWith({
    String? locale,
    ThemeMode? themeMode,
    bool? easyMode,
    double? textScale,
    bool? highContrast,
    bool? onboardingSeen,
    bool? languageChosen,
    String? selectedPetId,
    bool clearPet = false,
    Map<String, List<String>>? channels,
    int? quietStart,
    int? quietEnd,
    bool? quietHoursOn,
    bool? vaultPinSet,
  }) =>
      AppSettings(
        locale: locale ?? this.locale,
        themeMode: themeMode ?? this.themeMode,
        easyMode: easyMode ?? this.easyMode,
        textScale: textScale ?? this.textScale,
        highContrast: highContrast ?? this.highContrast,
        onboardingSeen: onboardingSeen ?? this.onboardingSeen,
        languageChosen: languageChosen ?? this.languageChosen,
        selectedPetId: clearPet ? null : (selectedPetId ?? this.selectedPetId),
        channels: channels ?? this.channels,
        quietStart: quietStart ?? this.quietStart,
        quietEnd: quietEnd ?? this.quietEnd,
        quietHoursOn: quietHoursOn ?? this.quietHoursOn,
        vaultPinSet: vaultPinSet ?? this.vaultPinSet,
      );
}

class SettingsController extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final p = ref.watch(prefsProvider);
    final channels = <String, List<String>>{};
    for (final k in p.getKeys().where((k) => k.startsWith('ch_'))) {
      channels[k.substring(3)] = p.getStringList(k) ?? const ['push'];
    }
    return AppSettings(
      locale: p.getString('locale') ?? 'en',
      themeMode: ThemeMode.values[p.getInt('themeMode') ?? 0],
      easyMode: p.getBool('easyMode') ?? false,
      textScale: p.getDouble('textScale') ?? 1.0,
      highContrast: p.getBool('highContrast') ?? false,
      onboardingSeen: p.getBool('onboardingSeen') ?? false,
      languageChosen: p.getBool('languageChosen') ?? false,
      selectedPetId: p.getString('selectedPetId'),
      channels: channels,
      quietStart: p.getInt('quietStart') ?? 22,
      quietEnd: p.getInt('quietEnd') ?? 7,
      quietHoursOn: p.getBool('quietHoursOn') ?? true,
      vaultPinSet: p.getString('vaultPin') != null,
    );
  }

  SharedPreferences get _p => ref.read(prefsProvider);

  void setLocale(String code) {
    _p.setString('locale', code);
    _p.setBool('languageChosen', true);
    state = state.copyWith(locale: code, languageChosen: true);
  }

  void setThemeMode(ThemeMode m) {
    _p.setInt('themeMode', m.index);
    state = state.copyWith(themeMode: m);
  }

  void setEasyMode(bool v) {
    _p.setBool('easyMode', v);
    state = state.copyWith(easyMode: v);
  }

  void setTextScale(double v) {
    _p.setDouble('textScale', v);
    state = state.copyWith(textScale: v);
  }

  void setHighContrast(bool v) {
    _p.setBool('highContrast', v);
    state = state.copyWith(highContrast: v);
  }

  void setOnboardingSeen() {
    _p.setBool('onboardingSeen', true);
    state = state.copyWith(onboardingSeen: true);
  }

  void selectPet(String? id) {
    if (id == null) {
      _p.remove('selectedPetId');
      state = state.copyWith(clearPet: true);
    } else {
      _p.setString('selectedPetId', id);
      state = state.copyWith(selectedPetId: id);
    }
  }

  void setChannels(String type, List<String> channels) {
    _p.setStringList('ch_$type', channels);
    state = state.copyWith(channels: {...state.channels, type: channels});
  }

  void setQuietHours({bool? on, int? start, int? end}) {
    if (on != null) _p.setBool('quietHoursOn', on);
    if (start != null) _p.setInt('quietStart', start);
    if (end != null) _p.setInt('quietEnd', end);
    state = state.copyWith(quietHoursOn: on, quietStart: start, quietEnd: end);
  }

  /// Applies the language/Easy mode saved on the user's profile after sign-in.
  void applyProfile({String? language, bool? easyMode}) {
    if (language != null && language != state.locale && !state.languageChosen) {
      _p.setString('locale', language);
      state = state.copyWith(locale: language);
    }
    if (easyMode == true && !state.easyMode) setEasyMode(true);
  }

  void setVaultPin(String? pin) {
    if (pin == null) {
      _p.remove('vaultPin');
    } else {
      _p.setString('vaultPin', pin);
    }
    state = state.copyWith(vaultPinSet: pin != null);
  }

  bool checkVaultPin(String pin) => _p.getString('vaultPin') == pin;
}

final settingsProvider = NotifierProvider<SettingsController, AppSettings>(SettingsController.new);
