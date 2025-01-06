export interface ConstType {
  mongoUrl?: string;
  passwordSalt?: string;
  jwtSecret?: string;
  redisUrl?: string;
  googleClientId?: string;
  googleClientSecret?: string;
  facebookClientSecret?: string;
  facebookClientId?: string;
  clientOrigin?: string;
  nodemailerUser?: string;
  nodemailerPass?: string;
}
export type ConstKey = keyof ConstType;
export const envMappingLocal: Record<ConstKey, string> = {
  mongoUrl: "MONGO_LOCAL_URL",
  passwordSalt: "PASSWORD_SALTROUND",
  jwtSecret: "JWT_SECRET_LOCAL",
  redisUrl: "NAT_LOCAL_REDIS",
  googleClientId: "GOOGLE_CLIENT_ID",
  googleClientSecret: "GOOGLE_CLIENT_SECRET",
  clientOrigin: "CLIENT_ORIGIN",
  facebookClientSecret: "FACEBOOK_CLIENT_SECRET",
  facebookClientId: "FACEBOOK_CLIENT_ID",
  nodemailerUser: "NODEMAILER_USER",
  nodemailerPass: "NODEMAILER_PASS",
};

export class ConstEnv {
  private _const: ConstType;
  mapping: Record<ConstKey, string>;
  constructor() {
    this._const = {};
    this.mapping = envMappingLocal;
  }
  setKey(key: ConstKey, custom?: string) {
    try {
      const ref = custom || this.mapping[key];
      if (!process.env[ref]) {
        throw new Error(`Not found "${ref}" key in env`);
      }
      const value: string = process.env[ref];
      //@ts-ignore
      this._const[key] = value;
    } catch (error) {
      console.log(error);
    }
  }
  get const() {
    return this._const;
  }
}
const constIns = new ConstEnv();
constIns.setKey("jwtSecret");
constIns.setKey("mongoUrl");
constIns.setKey("passwordSalt");
constIns.setKey("googleClientId");
constIns.setKey("googleClientSecret");
constIns.setKey("clientOrigin");
constIns.setKey("facebookClientId");
constIns.setKey("facebookClientSecret");
constIns.setKey("nodemailerUser");
constIns.setKey("nodemailerPass");
export const constEnv = constIns.const;
