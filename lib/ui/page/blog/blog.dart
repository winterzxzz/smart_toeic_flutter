import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.1),
        child: Row(
          children: [
            const SizedBox(width: 32),
            _buildSidebar(),
            Expanded(
              child: _buildMainContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Chuyên mục',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Tìm hiểu về STUDY4'),
          Text('Tính năng trên STUDY4'),
          Text('Khóa học trên STUDY4'),
          SizedBox(height: 16),
          Text('Review của học viên STUDY4'),
          Text('Học viên IELTS'),
          Text('Học viên TOEIC'),
          SizedBox(height: 16),
          Text('Luyện thi IELTS'),
          Text('IELTS Listening'),
          Text('IELTS Reading'),
          Text('IELTS Speaking'),
          Text('IELTS Writing'),
          Text('IELTS Materials'),
          Text('Thông tin kỳ thi IELTS'),
          Text('Kinh nghiệm thi IELTS'),
          SizedBox(height: 16),
          Text('Luyện thi TOEIC'),
          Text('TOEIC Listening'),
          Text('TOEIC Reading'),
          Text('TOEIC Materials'),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildBlogPost(
          imageUrl:
              'https://kenh14cdn.com/203336854389633024/2023/4/30/photo1682772628140-16827726282301463572662-16828396997672050284284.jpeg',
          category: 'IELTS SPEAKING',
          title:
              'Bộ đề dự đoán IELTS Speaking Forecast Quý 3/2024 & Bài mẫu (Đang cập nhật)',
          description:
              'Trong bài viết này, STUDY4 đã tổng hợp các topic IELTS Speaking có khả năng xuất hiện trong Bộ đề IELTS Speaking Forecast Quý 3/2024 (tháng 9 đến tháng 12).',
          date: '30/08/2024',
          author: 'Bùi Hằng',
          commentCount: 4,
        ),
        const SizedBox(height: 16),
        _buildBlogPost(
          imageUrl:
              'https://kenh14cdn.com/203336854389633024/2023/4/30/photo1682772628140-16827726282301463572662-16828396997672050284284.jpeg',
          category: 'KINH NGHIỆM THI TOEIC',
          title:
              'Lộ trình học TOEIC 2 kỹ năng tại nhà đạt 450-650+ cho người mới bắt đầu của STUDY4',
          description:
              'Bạn đang loay hoay muốn tìm lộ trình luyện TOEIC online đạt 450 - 650+? Đọc bài viết của STUDY4 dưới đây để tìm ra câu trả lời!',
          date: '21/05/2024',
          author: 'Bùi Hằng',
          commentCount: 2,
        ),
        const SizedBox(height: 16),
        _buildBlogPost(
          imageUrl:
              'https://kenh14cdn.com/203336854389633024/2023/4/30/photo1682772628140-16827726282301463572662-16828396997672050284284.jpeg',
          category: 'KINH NGHIỆM THI IELTS',
          title:
              'Lộ trình tự học IELTS online tại nhà từ số 0 đến 7+ của STUDY4',
          description:
              'Hãy cùng STUDY4 tham khảo ngay lộ trình tự học IELTS từ sơ cấp đến 7.0 chi tiết nhất ở bài viết dưới đây!',
          date: '21/05/2024',
          author: 'Bùi Hằng',
          commentCount: 3,
        ),
      ],
    );
  }

  Widget _buildBlogPost({
    required String imageUrl,
    required String category,
    required String title,
    required String description,
    required String date,
    required String author,
    required int commentCount,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(description),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(date),
                  const SizedBox(width: 8),
                  Text('bởi $author'),
                  const SizedBox(width: 8),
                  const Icon(Icons.comment, size: 16),
                  const SizedBox(width: 4),
                  Text('$commentCount bình luận'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
