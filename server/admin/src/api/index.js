export const originUrlUser = 'http://localhost:4000/api/user'
export const originUrlAdmin = 'http://localhost:4000/api/admin'
export const originUrlPub = 'http://localhost:4000/api/pub'
export const originUrl = 'http://localhost:4000'
export const originUrlUpload = 'http://localhost:4000/uploads'
const userAnalyst = {
  upgrade: `${originUrlAdmin}/user/analyst/upgrade`,
  new: `${originUrlAdmin}/user/analyst/new`,
  progress: `${originUrlAdmin}/user/analyst/progress`,
}
const transactionAnalyst = {
  new: `${originUrlAdmin}/transaction/analyst/new`,
  progress: `${originUrlAdmin}/transaction/analyst/progress`,
}
const result = {
  new: `${originUrlAdmin}/result/analyst/new`,
  progress: `${originUrlAdmin}/result/analyst/progress`,
}
const user = {
  get: `${originUrlAdmin}/user`,
}
const test = {
  create: `${originUrlAdmin}/test`,
  get: `${originUrlPub}/test`,
}
const auth = {
  login: `${originUrlAdmin}/auth/login`,
  logout: `${originUrlAdmin}/auth/logout`,
}
const transaction = {
  get: `${originUrlAdmin}/transaction`,
}
const cloudinary = {
  uploadImage: `${originUrlAdmin}/cloudinary/upload-image`,
}
const blog = {
  create: `${originUrlAdmin}/blog`,
  get: `${originUrlAdmin}/blog`,
  getById: `${originUrlAdmin}/blog`,
  update: `${originUrlAdmin}/blog`,
  delete: `${originUrlAdmin}/blog`,
}
export const endpoint = {
  userAnalyst,
  transactionAnalyst,
  result,
  user,
  test,
  auth,
  transaction,
  cloudinary,
  blog,
}
