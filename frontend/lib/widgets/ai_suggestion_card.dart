import 'package:flutter/material.dart';
import '../models/ai_suggestion_model.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

class AISuggestionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const AISuggestionCard({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            child,
          ],
        ),
      ),
    );
  }
}

class PrioritizationSuggestionCard extends StatelessWidget {
  final PrioritizationResponse prioritization;
  final Map<String, Task> taskMap;

  const PrioritizationSuggestionCard({
    Key? key,
    required this.prioritization,
    required this.taskMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AISuggestionCard(
      title: 'Task Prioritization',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            prioritization.message,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          if (prioritization.prioritizedTasks.isEmpty)
            const Text('No tasks to prioritize.'),
          ...prioritization.prioritizedTasks.map((prioritizedTask) {
            final task = taskMap[prioritizedTask.id];
            if (task == null) return const SizedBox.shrink();

            final priorityColor =
                AppTheme.getPriorityColor(prioritizedTask.priority);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: priorityColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        (prioritization.prioritizedTasks
                                    .indexOf(prioritizedTask) +
                                1)
                            .toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          prioritizedTask.reason,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class TimeEstimateSuggestionCard extends StatelessWidget {
  final TimeEstimateResponse timeEstimate;
  final VoidCallback? onAccept;

  const TimeEstimateSuggestionCard({
    Key? key,
    required this.timeEstimate,
    this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AISuggestionCard(
      title: 'Time Estimate',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeEstimate.message,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.access_time),
              const SizedBox(width: 8),
              Text(
                timeEstimate.estimatedTime,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (onAccept != null)
            ElevatedButton(
              onPressed: onAccept,
              child: const Text('Use This Estimate'),
            ),
        ],
      ),
    );
  }
}

class TaskRewriteSuggestionCard extends StatelessWidget {
  final TaskRewriteResponse taskRewrite;
  final VoidCallback? onAccept;

  const TaskRewriteSuggestionCard({
    Key? key,
    required this.taskRewrite,
    this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AISuggestionCard(
      title: 'Task Rewrite Suggestion',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            taskRewrite.message,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Card(
            color: theme.colorScheme.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title:',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    taskRewrite.rewrittenTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Description:',
                    style: theme.textTheme.labelLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    taskRewrite.rewrittenDescription,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (onAccept != null)
            ElevatedButton(
              onPressed: onAccept,
              child: const Text('Use This Rewrite'),
            ),
        ],
      ),
    );
  }
}
