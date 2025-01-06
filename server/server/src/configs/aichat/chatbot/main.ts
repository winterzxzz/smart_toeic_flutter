import path from "path";
import TFIDFEmbedding from "./TFIDFEmbedding";
import SmartChatbot from "./SmartChatbot";
import WebCrawler from "./WebCrawler";

export async function main() {
  // Khởi tạo crawler
  const crawler = new WebCrawler();
  await crawler.crawl("http://localhost:3000");

  // Khởi tạo embedding
  const embedding = new TFIDFEmbedding();
  embedding.loadDocuments(path.join(__dirname, "crawled_data.json"));

  // Khởi tạo chatbot
  const chatbot = new SmartChatbot(embedding);

  // Ví dụ sử dụng
  const query =
    "Bạn có thể cho tôi biết thêm thông tin về chủ đề tương lai máy tính?";
  const response = await chatbot.generateResponse(query);

  console.log("Truy vấn:", query);
  console.log("Phản hồi:", response);

  await chatbot.logConversation(query, response);
}

main().catch(console.error);
