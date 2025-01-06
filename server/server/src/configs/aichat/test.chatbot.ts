//@ts-nocheck
import { GoogleGenerativeAI } from "@google/generative-ai";
import { genAI } from "./instance";

class SmartResponseSystem {
  constructor(apiKey) {
    this.genAI = genAI;
    this.model = "gemini-1.5-flash";
    this.knowledgeBase = [];
  }

  // Thêm nội dung vào cơ sở tri thức
  async addContent(content) {
    try {
      // Tạo embedding cho nội dung
      const model = this.genAI.getGenerativeModel({
        model: this.model,
      });
      const result = await model.embedContent(content);

      this.knowledgeBase.push({
        originalText: content,
        embedding: result.embedding.values,
      });
    } catch (error) {
      console.error("Lỗi thêm nội dung:", error);
    }
  }

  // Tính độ tương đồng giữa các vector
  cosineSimilarity(vector1, vector2) {
    const dotProduct = vector1.reduce((sum, a, i) => sum + a * vector2[i], 0);
    const magnitude1 = Math.sqrt(vector1.reduce((sum, a) => sum + a * a, 0));
    const magnitude2 = Math.sqrt(vector2.reduce((sum, a) => sum + a * a, 0));

    return dotProduct / (magnitude1 * magnitude2);
  }

  // Tìm các nội dung liên quan
  findRelevantContent(queryEmbedding, threshold = 0.7) {
    return this.knowledgeBase
      .map((item) => ({
        ...item,
        similarity: this.cosineSimilarity(queryEmbedding, item.embedding),
      }))
      .filter((item) => item.similarity > threshold)
      .sort((a, b) => b.similarity - a.similarity)
      .slice(0, 3); // Lấy 3 kết quả liên quan nhất
  }

  // Xử lý và trả lời câu hỏi
  async processQuery(query) {
    try {
      // Tạo embedding cho câu hỏi
      const model = this.genAI.getGenerativeModel({
        model: this.model,
      });
      const queryEmbedding = await model.embedContent(query);

      // Tìm nội dung liên quan
      const relevantContents = this.findRelevantContent(
        queryEmbedding.embedding.values
      );

      // Nếu không tìm thấy nội dung liên quan
      if (relevantContents.length === 0) {
        return "Xin lỗi, tôi không tìm thấy thông tin phù hợp với câu hỏi của bạn.";
      }

      // Tổng hợp và trả lời
      const aiModel = this.genAI.getGenerativeModel({
        model: this.model,
      });
      const contextText = relevantContents
        .map((item) => item.originalText)
        .join("\n\n");

      const aiResponse = await aiModel.generateContent(
        `Sử dụng các thông tin sau đây để trả lời câu hỏi: 
        Câu hỏi: ${query}
        
        Thông tin liên quan:
        ${contextText}
        
        Hãy trả lời ngắn gọn, chính xác và thân thiện.`
      );

      return aiResponse.response.text();
    } catch (error) {
      console.error("Lỗi xử lý câu hỏi:", error);
      return "Đã có lỗi xảy ra. Xin vui lòng thử lại.";
    }
  }
}

// Ví dụ sử dụng
export async function demo() {
  const responseSystem = new SmartResponseSystem(process.env.GEMINI_API_KEY);

  // Thêm nội dung vào hệ thống
  await responseSystem.addContent(
    "Chúng tôi cung cấp dịch vụ sửa xe máy chuyên nghiệp"
  );
  await responseSystem.addContent(
    "Bảng giá dịch vụ sửa chữa xe máy năm 2024 từ 100.000 đến 500.000 VND"
  );

  // Thử nghiệm trả lời
  const response = await responseSystem.processQuery(
    "Các dịch vụ sửa xe của bạn như thế nào?"
  );
  console.log(response);
}
