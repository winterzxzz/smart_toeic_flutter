import { Storage } from "@google-cloud/storage";
import path from "path";
const storage = new Storage({
    keyFilename: path.join(__dirname, 'path/to/your-service-account-file.json'),
  });
  const bucket = storage.bucket('your-bucket-name');