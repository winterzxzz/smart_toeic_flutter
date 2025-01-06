import { storage } from '../firebase'
import { ref, uploadBytesResumable, getDownloadURL, deleteObject } from 'firebase/storage'

export const uploadFile = async (file, folder) => {
  const timestamp = Date.now()
  const storagePath = `blog/${folder}/${timestamp}_${file.name}`
  const storageRef = ref(storage, storagePath)
  
  return new Promise((resolve, reject) => {
    const uploadTask = uploadBytesResumable(storageRef, file)
    
    uploadTask.on('state_changed',
      (snapshot) => {
        const progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100
        console.log('Upload is ' + progress + '% done')
      },
      (error) => reject(error),
      async () => {
        const url = await getDownloadURL(uploadTask.snapshot.ref)
        resolve({ url, path: storagePath })
      }
    )
  })
}

export const deleteFile = async (path) => {
  const fileRef = ref(storage, path)
  await deleteObject(fileRef)
}
