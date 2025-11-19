import 'package:flutter/foundation.dart';
import '../../data/models/terminal.dart';
import '../../data/repositories/terminal_repository.dart';

class TerminalProvider with ChangeNotifier {
  final TerminalRepository _repository = TerminalRepository();

  List<Terminal> _terminals = [];
  Terminal? _selectedTerminal;
  bool _isLoading = false;
  String? _errorMessage;

  List<Terminal> get terminals => _terminals;
  Terminal? get selectedTerminal => _selectedTerminal;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> getAllTerminals() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _terminals = await _repository.getAllTerminals();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      print('Error getting terminals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTerminalById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedTerminal = await _repository.getTerminalById(id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      print('Error getting terminal: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTerminal(Map<String, dynamic> terminalData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final terminal = await _repository.createTerminal(terminalData);
      _terminals.add(terminal);
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('Error creating terminal: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateTerminal(int id, Map<String, dynamic> terminalData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedTerminal =
          await _repository.updateTerminal(id, terminalData);
      final index = _terminals.indexWhere((t) => t.id == id);
      if (index != -1) {
        _terminals[index] = updatedTerminal;
      }
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('Error updating terminal: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteTerminal(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteTerminal(id);
      _terminals.removeWhere((t) => t.id == id);
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      print('Error deleting terminal: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void selectTerminal(Terminal terminal) {
    _selectedTerminal = terminal;
    notifyListeners();
  }

  void clearSelection() {
    _selectedTerminal = null;
    notifyListeners();
  }
}
