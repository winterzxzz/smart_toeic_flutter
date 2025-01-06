// @ts-nocheck
import puppeteer from "puppeteer";
import fs from "fs";
import path from "path";

type ExtractedData = {
  url: string;
  title: string;
  content: string;
  timestamp: string;
};

class WebCrawler {
  private visitedUrls: Set<string>;
  private extractedData: ExtractedData[];
  private maxDepth: number;
  private maxPages: number;

  constructor(maxDepth = 2, maxPages = 10) {
    this.visitedUrls = new Set();
    this.extractedData = [];
    this.maxDepth = maxDepth;
    this.maxPages = maxPages;
  }

  async crawl(startUrl: string): Promise<ExtractedData[]> {
    console.log("Crawling started: ", startUrl);
    await this.crawlRecursive(startUrl);
    this.saveToFile();
    return this.extractedData;
  }

  private async crawlRecursive(url: string, currentDepth = 0): Promise<void> {
    if (
      currentDepth > this.maxDepth ||
      this.visitedUrls.size >= this.maxPages ||
      this.visitedUrls.has(url)
    ) {
      return;
    }

    try {
      this.visitedUrls.add(url);

      // Mở trình duyệt Puppeteer và lấy dữ liệu
      const browser = await puppeteer.launch();
      const page = await browser.newPage();
      await page.goto(url, { waitUntil: "networkidle2" });

      // Trích xuất dữ liệu từ trang
      const data = await page.evaluate(() => {
        const articles: ExtractedData[] = [];
        const elements = document.querySelectorAll("article, .content, .post");

        elements.forEach((elem) => {
          const title = (
            elem.querySelector("h1, h2")?.textContent || ""
          ).trim();
          const content = Array.from(elem.querySelectorAll("p"))
            .map((p) => p.textContent?.trim())
            .filter(Boolean)
            .join("\n");

          if (title || content) {
            articles.push({
              url: window.location.href, // Đặt URL trang hiện tại
              title,
              content,
              timestamp: new Date().toISOString(),
            });
          }
        });

        return articles;
      });

      this.extractedData.push(...data);
      await browser.close();

      // Trích xuất các liên kết để tiếp tục crawl
      const links = await page.$$eval(
        "a",
        (anchorElements: HTMLAnchorElement[]) =>
          anchorElements
            .map((el) => el.getAttribute("href"))
            .filter(
              (link) =>
                link && !link.startsWith("#") && !link.startsWith("javascript:")
            )
      );

      for (const link of links) {
        const absoluteLink = this.normalizeUrl(link, url);
        if (this.isValidLink(absoluteLink, url)) {
          await this.crawlRecursive(absoluteLink!, currentDepth + 1);
        }
      }
    } catch (error) {
      console.error(`Error crawling ${url}:`, error);
    }
  }

  private normalizeUrl(link: string, baseUrl: string): string | null {
    try {
      return new URL(link, baseUrl).toString();
    } catch {
      return null;
    }
  }

  private isValidLink(link: string | null, baseUrl: string): boolean {
    if (!link) return false;
    try {
      const baseUrlObj = new URL(baseUrl);
      const linkUrlObj = new URL(link);
      return (
        linkUrlObj.protocol === baseUrlObj.protocol &&
        linkUrlObj.hostname === baseUrlObj.hostname &&
        !this.visitedUrls.has(link)
      );
    } catch {
      return false;
    }
  }

  private saveToFile(): void {
    const outputPath = path.join(__dirname, "crawled_data.json");
    fs.writeFileSync(outputPath, JSON.stringify(this.extractedData, null, 2));
    console.log(
      `Saved ${this.extractedData.length} documents to ${outputPath}`
    );
  }
}

export default WebCrawler;
