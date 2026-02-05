import 'package:flutter/material.dart';
import 'package:history/data/service/data%20services/comment_service.dart/comment_service.dart';
import 'package:history/domain/model/comment_model/comment_model.dart';

class CommentScr extends StatefulWidget {
  const CommentScr({super.key});

  @override
  State<CommentScr> createState() => _CommentScrState();
}

class _CommentScrState extends State<CommentScr> {
  late Future<List<CommentModel>> _futureComments;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureComments = CommentService().getCommentList();
    });
  }

  // Логика смены статуса
  Future<void> _updateStatus(CommentModel comment, int newStatus) async {
    // Создаем копию комментария с новым статусом
    final updatedComment = CommentModel(
      id: comment.id,
      objectId: comment.objectId,
      creatorId: comment.creatorId,
      about: comment.about,
      date: comment.date,
      status: newStatus,
    );

    // В твоем сервисе нет update, поэтому имитируем через delete/add
    await CommentService().delete(comment);
    await CommentService().setComment(updatedComment);

    _loadData(); // Перерисовываем экран
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommentModel>>(
      future: _futureComments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Фильтруем, чтобы видеть только те, что в модерации (status == 101)
          // Или убери .where, если хочешь видеть вообще все
          final list = snapshot.data!.where((e) => e.status == 101).toList();

          if (list.isEmpty)
            return const Center(child: Text("Новых комментариев нет"));

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: list.length,
            itemBuilder: (context, index) => _buildCommentItem(list[index]),
          );
        }

        return const Center(child: Text("Комментарии отсутствуют"));
      },
    );
  }

  Widget _buildCommentItem(CommentModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blueGrey[100],
                  child: const Icon(Icons.person, color: Colors.blueGrey),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID автора: ${item.creatorId}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _statusBadge(item.status),
              ],
            ),
            const Divider(height: 20),
            Text(item.about, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Кнопка БАН (103)
                TextButton.icon(
                  onPressed: () => _updateStatus(item, 103),
                  icon: const Icon(Icons.block, color: Colors.red, size: 18),
                  label: const Text("Бан", style: TextStyle(color: Colors.red)),
                ),
                const SizedBox(width: 8),
                // Кнопка ОДОБРИТЬ (102)
                ElevatedButton.icon(
                  onPressed: () => _updateStatus(item, 102),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text("Одобрить"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Цветной ярлык статуса
  Widget _statusBadge(int status) {
    Color color;
    String text;
    switch (status) {
      case 101:
        color = Colors.orange;
        text = "Модерация";
        break;
      case 102:
        color = Colors.green;
        text = "Одобрен";
        break;
      case 103:
        color = Colors.red;
        text = "Бан";
        break;
      default:
        color = Colors.grey;
        text = "Неизвестно";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
