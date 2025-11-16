import 'package:flutter/foundation.dart';
import '../../data/models/staff.dart';
import '../../data/repositories/staff_repository.dart';

class StaffProvider with ChangeNotifier {
  final StaffRepository _staffRepository = StaffRepository();

  List<Staff> _staffMembers = [];
  Staff? _selectedStaff;
  bool _isLoading = false;
  String? _errorMessage;

  List<Staff> get staffMembers => _staffMembers;
  Staff? get selectedStaff => _selectedStaff;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get all staff members
  Future<void> getAllStaff() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _staffMembers = await _staffRepository.getAllStaff();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new staff member
  Future<bool> createStaff(Map<String, dynamic> staffData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _staffRepository.createStaff(staffData);
      await getAllStaff();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get staff by ID
  Future<void> getStaffById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedStaff = await _staffRepository.getStaffById(id);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update staff member
  Future<bool> updateStaff(int id, Map<String, dynamic> staffData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _staffRepository.updateStaff(id, staffData);
      await getAllStaff();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete staff member
  Future<bool> deleteStaff(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _staffRepository.deleteStaff(id);
      await getAllStaff();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
