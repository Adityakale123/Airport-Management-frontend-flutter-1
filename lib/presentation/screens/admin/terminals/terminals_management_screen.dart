import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../providers/terminal_provider.dart';
import '../../../widgets/common/loading_indicator.dart';
import '../../../widgets/common/search_bar.dart';
import '../../../widgets/common/empty_state.dart';

class TerminalsManagementScreen extends StatefulWidget {
  @override
  State<TerminalsManagementScreen> createState() =>
      _TerminalsManagementScreenState();
}

class _TerminalsManagementScreenState extends State<TerminalsManagementScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTerminals();
  }

  Future<void> _loadTerminals() async {
    await Provider.of<TerminalProvider>(context, listen: false)
        .getAllTerminals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terminals Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTerminals,
          ),
        ],
      ),
      body: Consumer<TerminalProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return LoadingIndicator(message: 'Loading terminals...');
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  SizedBox(height: 16),
                  Text(provider.errorMessage!),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadTerminals,
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final filteredTerminals = provider.terminals.where((terminal) {
            return terminal.name
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                terminal.code
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
          }).toList();

          return Column(
            children: [
              CustomSearchBar(
                hintText: 'Search terminals...',
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
              Expanded(
                child: filteredTerminals.isEmpty
                    ? EmptyState(
                        icon: Icons.business,
                        title: 'No Terminals Found',
                        subtitle: _searchQuery.isEmpty
                            ? 'Add your first terminal to get started'
                            : 'No terminals match your search',
                        actionText: 'Add Terminal',
                        onActionPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.adminAddTerminal);
                        },
                      )
                    : RefreshIndicator(
                        onRefresh: _loadTerminals,
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: filteredTerminals.length,
                          itemBuilder: (context, index) {
                            final terminal = filteredTerminals[index];
                            return _buildTerminalCard(terminal);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.adminAddTerminal);
        },
        icon: Icon(Icons.add),
        label: Text('Add Terminal'),
      ),
    );
  }

  Widget _buildTerminalCard(terminal) {
    final isOperational = terminal.status == 'OPERATIONAL';
    final Color statusColor =
        isOperational ? AppColors.success : AppColors.warning;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showTerminalDetails(terminal),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.business, color: AppColors.primary),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            terminal.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            terminal.code,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      terminal.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoTile(
                      'Capacity',
                      '${terminal.capacity} flights',
                      Icons.event_seat,
                    ),
                  ),
                  if (terminal.facilities != null &&
                      terminal.facilities!.isNotEmpty)
                    Expanded(
                      child: _buildInfoTile(
                        'Facilities',
                        'Available',
                        Icons.check_circle,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showTerminalDetails(terminal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    terminal.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 24),
              _buildDetailRow('Terminal Code', terminal.code),
              _buildDetailRow('Status', terminal.status),
              _buildDetailRow('Capacity', '${terminal.capacity} flights'),
              if (terminal.facilities != null &&
                  terminal.facilities!.isNotEmpty)
                _buildDetailRow('Facilities', terminal.facilities!),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Navigate to edit screen
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Edit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Terminal'),
                            content: Text(
                                'Are you sure you want to delete this terminal?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                ),
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          final success = await Provider.of<TerminalProvider>(
                            context,
                            listen: false,
                          ).deleteTerminal(terminal.id!);

                          if (mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Terminal deleted successfully'
                                      : 'Failed to delete terminal',
                                ),
                                backgroundColor: success
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            );
                          }
                        }
                      },
                      icon: Icon(Icons.delete),
                      label: Text('Delete'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
