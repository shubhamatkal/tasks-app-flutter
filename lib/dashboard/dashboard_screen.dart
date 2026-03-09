import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../app/theme.dart';
import '../auth/auth_service.dart';
import '../services/supabase_service.dart';
import 'task_model.dart';
import 'task_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  late DateTime _selectedDate;
  late List<DateTime> _weekDays;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _weekDays = _buildWeekDays(_selectedDate);
    _loadTasks();
  }

  List<DateTime> _buildWeekDays(DateTime date) {
    final monday = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    final userId = context.read<AuthService>().user?.id;
    if (userId == null) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      final tasks = await SupabaseService.instance.fetchTasks(userId);
      if (mounted) setState(() => _tasks = tasks);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load tasks: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleTask(Task task) async {
    try {
      final updated = await SupabaseService.instance.toggleTask(task);
      setState(() {
        final idx = _tasks.indexWhere((t) => t.id == task.id);
        if (idx != -1) _tasks[idx] = updated;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final removed = _tasks.firstWhere((t) => t.id == taskId);
    setState(() => _tasks.removeWhere((t) => t.id == taskId));
    try {
      await SupabaseService.instance.deleteTask(taskId);
    } catch (e) {
      setState(() => _tasks.insert(0, removed));
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }

  /// Tasks whose date matches the selected day
  List<Task> get _tasksForDay => _tasks.where((t) {
        return t.date.year == _selectedDate.year &&
            t.date.month == _selectedDate.month &&
            t.date.day == _selectedDate.day;
      }).toList();

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat("EEEE, d'${_daySuffix(_selectedDate.day)}' MMMM yy")
            .format(_selectedDate);

    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            _buildDateHeader(dateLabel),
            _buildWeekStrip(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29),
              child: const Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kTextWhite,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(29, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Schedule',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: kTextWhite,
            ),
          ),
          IconButton(
            onPressed: () =>
                context.push('/create-task').then((_) => _loadTasks()),
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: kTextMuted, width: 1.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: kTextWhite, size: 22),
            ),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(String dateLabel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(29, 14, 29, 0),
      child: Text(
        dateLabel,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: kTextWhite),
      ),
    );
  }

  Widget _buildWeekStrip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(29, 16, 29, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _weekDays.map((day) {
          final isSelected = day.day == _selectedDate.day &&
              day.month == _selectedDate.month;
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 69,
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryColor : kSurfaceColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? kTextDark : kTextWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('EEE').format(day).substring(0, 3),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? kTextDark : kTextWhite,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskList() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: kPrimaryColor));
    }
    final dayTasks = _tasksForDay;
    if (dayTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, color: kTextMuted, size: 64),
            const SizedBox(height: 16),
            const Text(
              'No tasks for this day.\nTap + to add one!',
              textAlign: TextAlign.center,
              style: TextStyle(color: kTextMuted, fontSize: 16),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: kPrimaryColor,
      backgroundColor: kSurfaceColor,
      onRefresh: _loadTasks,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(29, 0, 29, 24),
        itemCount: dayTasks.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final task = dayTasks[i];
          return TaskTile(
            key: Key(task.id),
            task: task,
            onToggle: () => _toggleTask(task),
            onDelete: () => _deleteTask(task.id),
          );
        },
      ),
    );
  }

  String _daySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
