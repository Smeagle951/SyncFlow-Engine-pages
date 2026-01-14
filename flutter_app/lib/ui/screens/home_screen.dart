import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:offline_sync_pro/domain/repositories/record_repository.dart';
import 'package:offline_sync_pro/domain/models/record.dart';
import 'package:offline_sync_pro/ui/widgets/record_card.dart';
import 'package:offline_sync_pro/ui/widgets/add_record_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Record> _records = [];
  bool _isLoading = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    final repository = Provider.of<RecordRepository>(context, listen: false);
    final records = await repository.getAllRecords();
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  Future<void> _handleSync() async {
    setState(() => _isSyncing = true);
    
    final repository = Provider.of<RecordRepository>(context, listen: false);
    final result = await repository.sync();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.success
                ? 'Sincronizado! ${result.pushed} enviados, ${result.pulled} recebidos'
                : 'Erro: ${result.message}',
          ),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );
    }

    setState(() => _isSyncing = false);
    _loadRecords();
  }

  Future<void> _handleAddRecord() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const AddRecordDialog(),
    );

    if (result != null && result.isNotEmpty) {
      final repository = Provider.of<RecordRepository>(context, listen: false);
      await repository.createRecord(result);
      _loadRecords();
    }
  }

  Future<void> _handleEditRecord(Record record) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AddRecordDialog(initialValue: record.data),
    );

    if (result != null && result.isNotEmpty) {
      final repository = Provider.of<RecordRepository>(context, listen: false);
      await repository.updateRecord(record.copyWith(data: result));
      _loadRecords();
    }
  }

  Future<void> _handleDeleteRecord(Record record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente excluir este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repository = Provider.of<RecordRepository>(context, listen: false);
      await repository.deleteRecord(record.uuid);
      _loadRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OfflineSync Pro'),
        actions: [
          IconButton(
            icon: _isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
            onPressed: _isSyncing ? null : _handleSync,
            tooltip: 'Sincronizar',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.inbox, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhum registro ainda',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Toque no + para adicionar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadRecords,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: _records.length,
                    itemBuilder: (context, index) {
                      final record = _records[index];
                      return RecordCard(
                        record: record,
                        onEdit: () => _handleEditRecord(record),
                        onDelete: () => _handleDeleteRecord(record),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleAddRecord,
        child: const Icon(Icons.add),
      ),
    );
  }
}
