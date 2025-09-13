import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';

class LiveStreamFooter extends StatefulWidget {
  const LiveStreamFooter({super.key});

  @override
  State<LiveStreamFooter> createState() => _LiveStreamFooterState();
}

class _LiveStreamFooterState extends State<LiveStreamFooter> {
  @override
  Widget build(BuildContext context) {
    final height = context.sizze.height;
    final width = context.sizze.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height * 0.3,
          width: width * 0.8,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
            itemBuilder: (context, index) {
              return CommentItem(index: index);
            },
            itemCount: 10,
          ),
        ),
        const PrepareLiveInput(),
      ],
    );
  }
}

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.index,
  });
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage:
                Image.network('https://picsum.photos/200/300').image,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User $index',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                  )),
              Text('Message $index',
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  )),
            ],
          )
        ],
      ),
    );
  }
}

class PrepareLiveInput extends StatefulWidget {
  const PrepareLiveInput({
    super.key,
  });

  @override
  State<PrepareLiveInput> createState() => _PrepareLiveInputState();
}

class _PrepareLiveInputState extends State<PrepareLiveInput> {
  late final TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              style: context.textTheme.bodySmall?.copyWith(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: context.textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.emoji_emotions,
                  size: 24, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.send, size: 24, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
