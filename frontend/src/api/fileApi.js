import axiosClient from './axiosClient'

export const getFiles = async () => {
  const response = await axiosClient.get('/files')
  return response.data
}

export const createFile = async (file) => {
  const response = await axiosClient.post('/files', file)
  return response.data
}

export const uploadFile = async (file, fileType) => {
  const formData = new FormData()
  formData.append('file', file)
  formData.append('fileType', fileType)

  const response = await axiosClient.post('/files/upload', formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  })
  return response.data
}

export const deleteFile = async (id) => {
  await axiosClient.delete(`/files/${id}`)
}
