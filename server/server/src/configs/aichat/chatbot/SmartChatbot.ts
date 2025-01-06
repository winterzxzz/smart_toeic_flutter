import { GoogleGenerativeAI } from "@google/generative-ai";
import TFIDFEmbedding from "./TFIDFEmbedding";
import { genAI } from "../instance";
interface Document {
  url: string;
  content: string;
}

export default class SmartChatbot {
  private genAI: GoogleGenerativeAI;
  private model: any;
  private embedding: TFIDFEmbedding;

  constructor(embedding: TFIDFEmbedding) {
    this.genAI = genAI;
    this.model = this.genAI.getGenerativeModel({ model: "gemini-1.5-flash" });
    this.embedding = embedding;
  }

  // Tạo prompt thông minh
  async generateResponse(query: string): Promise<string> {
    try {
      // Tìm các tài liệu liên quan
      const relevantDocuments: Document[] =
        this.embedding.searchRelevant(query);

      // Xây dựng context
      const contextPrompt = relevantDocuments
        .map((doc) => `Nguồn [${doc.url}]: ${doc.content}`)
        .join("\n\n");

      // Prompt hoàn chỉnh
      const fullPrompt = `
                Bối cảnh: ${contextPrompt}

                Câu hỏi: ${query}

                Yêu cầu:
                - Trả lời dựa trên bối cảnh cung cấp
                - Nếu không có thông tin liên quan, trả lời bằng kiến thức chung
                - Giải thích nguồn thông tin nếu có thể
            `;

      // Gọi API Gemini
      const result = await this.model.generateContent(fullPrompt);
      return result.response.text();
    } catch (error) {
      console.error("Lỗi tạo phản hồi:", error);
      return "Xin lỗi, tôi không thể trả lời câu hỏi này.";
    }
  }

  // Log và theo dõi cuộc trò chuyện
  async logConversation(query: string, response: string): Promise<void> {
    const conversationLog = {
      timestamp: new Date().toISOString(),
      query,
      response,
    };

    // Có thể mở rộng để lưu vào database
    console.log(JSON.stringify(conversationLog, null, 2));
  }
}
