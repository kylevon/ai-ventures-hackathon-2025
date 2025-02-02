import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/restriction.dart';

class RestrictionRepository {
  static const String _key = 'restrictions';
  final SharedPreferences _prefs;

  RestrictionRepository(this._prefs);

  Future<List<Restriction>> getRestrictions() async {
    final String? jsonString = _prefs.getString(_key);
    if (jsonString == null) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((json) => Restriction.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRestrictions(List<Restriction> restrictions) async {
    final String jsonString = json.encode(
      restrictions.map((r) => r.toJson()).toList(),
    );
    await _prefs.setString(_key, jsonString);
  }

  Future<void> addRestriction(Restriction restriction) async {
    final restrictions = await getRestrictions();
    restrictions.add(restriction);
    await saveRestrictions(restrictions);
  }

  Future<void> updateRestriction(Restriction restriction) async {
    final restrictions = await getRestrictions();
    final index = restrictions.indexWhere((r) => r.id == restriction.id);
    if (index != -1) {
      restrictions[index] = restriction;
      await saveRestrictions(restrictions);
    }
  }

  Future<void> deleteRestriction(String id) async {
    final restrictions = await getRestrictions();
    restrictions.removeWhere((r) => r.id == id);
    await saveRestrictions(restrictions);
  }
}
