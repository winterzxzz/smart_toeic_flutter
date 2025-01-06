import fs from "fs";
import path from "path";
import natural from "natural";

type Document = {
  url: string;
  title: string;
  content: string;
  timestamp: string;
};

class TFIDFEmbedding {
  private tfidf: natural.TfIdf;
  private documents: Document[];

  constructor() {
    this.tfidf = new natural.TfIdf();
    this.documents = [];
  }

  // Nạp dữ liệu từ file crawl
  loadDocuments(filePath: string): Document[] {
    try {
      const rawData = fs.readFileSync(filePath, "utf8");
      this.documents = JSON.parse(rawData);

      // Thêm từng tài liệu vào TF-IDF
      this.documents.forEach((doc) => {
        this.tfidf.addDocument(this.preprocessText(doc.content).join(" "));
      });

      return this.documents;
    } catch (error) {
      console.error("Error reading file:", error);
      return [];
    }
  }

  // Tiền xử lý văn bản
  private preprocessText(text: string): string[] {
    return text
      .toLowerCase()
      .replace(/[^\w\s]/g, "")
      .split(/\s+/)
      .filter((word) => word.length > 1);
  }

  // Tìm kiếm các tài liệu liên quan
  searchRelevant(query: string, topK = 3): Document[] {
    const processedQuery = this.preprocessText(query).join(" ");

    // Tính điểm tương đồng
    const similarities = this.documents.map((doc, index) => {
      const similarity = this.calculateSimilarity(processedQuery, doc.content);
      return { doc, similarity };
    });

    // Sắp xếp và trả về top K
    return similarities
      .sort((a, b) => b.similarity - a.similarity)
      .slice(0, topK)
      .map((item) => item.doc);
  }

  // Tính toán độ tương đồng
  private calculateSimilarity(query: string, docContent: string): number {
    const queryTerms = this.preprocessText(query);
    const docTerms = this.preprocessText(docContent);

    // Tính TF-IDF cho từng từ trong truy vấn
    const queryVector: Record<string, number> = {};
    queryTerms.forEach((term) => {
      queryVector[term] = this.tfidf.tfidf(term, 0) || 0;
    });

    // Tính TF-IDF cho từng từ trong tài liệu
    const docVector: Record<string, number> = {};
    docTerms.forEach((term) => {
      docVector[term] = this.tfidf.tfidf(term, 0) || 0;
    });

    // Tính cosine similarity
    return this.cosineSimilarity(queryVector, docVector);
  }

  // Tính cosine similarity
  private cosineSimilarity(
    vec1: Record<string, number>,
    vec2: Record<string, number>
  ): number {
    const terms = new Set([...Object.keys(vec1), ...Object.keys(vec2)]);

    let dotProduct = 0;
    let mag1 = 0;
    let mag2 = 0;

    terms.forEach((term) => {
      const v1 = vec1[term] || 0;
      const v2 = vec2[term] || 0;

      dotProduct += v1 * v2;
      mag1 += v1 * v1;
      mag2 += v2 * v2;
    });

    return dotProduct / (Math.sqrt(mag1) * Math.sqrt(mag2) || 1);
  }
}

export default TFIDFEmbedding;
