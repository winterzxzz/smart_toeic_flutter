import { RedisClientType, createClient } from "@redis/client";

class Redis {
  client: RedisClientType;
  constructor() {
    this.client = createClient(); // Initialize the client
    this.client.on("error", (err) => console.error("Redis Client Error", err));
  }

  async disconnect() {
    try {
      await this.client.quit(); // Disconnect from Redis server
      console.log("Disconnected from Redis");
    } catch (err) {
      console.error("Failed to disconnect from Redis", err);
    }
  }
}
export const redis = new Redis();

export async function connectRedis() {
  try {
    await redis.client.connect(); // Connect to Redis server
    console.log("Connected to Redis");
  } catch (err) {
    console.error("Failed to connect to Redis", err);
  }
}
function verifyEmailKey(email: string) {
  return "otp:vrf:" + email;
}
function resetPwOTPKey(email: string) {
  return "otp:pw:" + email;
}
export const redisKey = {
  resetPwOTPKey,
  verifyEmailKey,
};
