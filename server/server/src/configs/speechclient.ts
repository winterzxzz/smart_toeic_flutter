const credentialsPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
console.log("Service Account File:", credentialsPath);

// Tiến hành cấu hình Google Cloud API với tệp service account
const { SpeechClient } = require("@google-cloud/speech");
export const client = new SpeechClient();
