import '../services/api_service.dart';
import '../models/terminal.dart';
import '../../core/constants/api_endpoints.dart';

class TerminalRepository {
  Future<List<Terminal>> getAllTerminals() async {
    try {
      final response = await ApiService.get(ApiEndpoints.adminTerminals);
      return (response as List).map((json) => Terminal.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch terminals: ${e.toString()}');
    }
  }

  Future<Terminal> getTerminalById(int id) async {
    try {
      final response = await ApiService.get(ApiEndpoints.adminTerminalById(id));
      return Terminal.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch terminal: ${e.toString()}');
    }
  }

  Future<Terminal> createTerminal(Map<String, dynamic> terminalData) async {
    try {
      final response = await ApiService.post(
        ApiEndpoints.createTerminal,
        terminalData,
      );
      return Terminal.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create terminal: ${e.toString()}');
    }
  }

  Future<Terminal> updateTerminal(
      int id, Map<String, dynamic> terminalData) async {
    try {
      final response = await ApiService.put(
        ApiEndpoints.updateTerminal(id),
        terminalData,
      );
      return Terminal.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update terminal: ${e.toString()}');
    }
  }

  Future<void> deleteTerminal(int id) async {
    try {
      await ApiService.delete(ApiEndpoints.deleteTerminal(id));
    } catch (e) {
      throw Exception('Failed to delete terminal: ${e.toString()}');
    }
  }
}
