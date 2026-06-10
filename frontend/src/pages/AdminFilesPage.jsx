import { useEffect, useState } from 'react'
import { deleteFile, getFiles, uploadFile } from '../api/fileApi.js'

const fileTypeOptions = [
  { value: 'video', label: 'Video', accept: 'video/*' },
  { value: 'image', label: 'Hình ảnh', accept: 'image/*' },
  { value: 'document', label: 'Tài liệu', accept: '.pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.txt,application/*' },
]

function getFileTypeLabel(type) {
  return fileTypeOptions.find((option) => option.value === type)?.label || 'Tệp'
}

function getAcceptByFileType(type) {
  return fileTypeOptions.find((option) => option.value === type)?.accept || '*/*'
}

function formatFileSize(size) {
  if (!size && size !== 0) {
    return '-'
  }

  if (size < 1024) {
    return `${size} B`
  }

  if (size < 1024 * 1024) {
    return `${Math.round(size / 1024)} KB`
  }

  return `${(size / 1024 / 1024).toFixed(1)} MB`
}

function AdminFilesPage() {
  const [files, setFiles] = useState([])
  const [fileType, setFileType] = useState('video')
  const [selectedFile, setSelectedFile] = useState(null)
  const [loading, setLoading] = useState(true)
  const [saving, setSaving] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')

  const loadFiles = async () => {
    setLoading(true)
    try {
      const data = await getFiles()
      setFiles(data)
      setError('')
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải danh sách file.')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    let isMounted = true

    const loadInitialFiles = async () => {
      try {
        const data = await getFiles()
        if (isMounted) {
          setFiles(data)
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải danh sách file.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadInitialFiles()

    return () => {
      isMounted = false
    }
  }, [])

  const handleFileTypeChange = (event) => {
    setFileType(event.target.value)
    setSelectedFile(null)
  }

  const handleUpload = async (event) => {
    event.preventDefault()
    setError('')
    setSuccess('')

    if (!selectedFile) {
      setError('Vui lòng chọn file cần tải lên.')
      return
    }

    setSaving(true)
    try {
      await uploadFile(selectedFile, fileType)
      setSelectedFile(null)
      setSuccess('Đã tải file lên hệ thống.')
      await loadFiles()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể tải file lên.')
    } finally {
      setSaving(false)
    }
  }

  const handleCopyLink = async (fileUrl) => {
    if (!fileUrl) {
      return
    }

    try {
      await navigator.clipboard.writeText(fileUrl)
      setError('')
      setSuccess('Đã sao chép link file.')
    } catch {
      setSuccess('')
      setError('Không thể sao chép link file.')
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Bạn có chắc muốn xóa file này?')) {
      return
    }

    setError('')
    setSuccess('')
    try {
      await deleteFile(id)
      setSuccess('Đã xóa file thành công.')
      await loadFiles()
    } catch (err) {
      setError(err.response?.data?.message || 'Không thể xóa file.')
    }
  }

  return (
    <section className="page-shell wide-shell admin-page">
      <div className="section-heading">
        <div>
          <p className="eyebrow">Quản trị nội dung</p>
          <h1>Quản lý file local</h1>
        </div>
        <p className="muted">Tải file từ máy lên hệ thống để dùng cho ảnh khóa học, video bài học hoặc tài liệu.</p>
      </div>

      {error && <p className="alert">{error}</p>}
      {success && <p className="success-alert">{success}</p>}

      <form className="admin-form upload-form" onSubmit={handleUpload}>
        <div className="full-field">
          <h2>Tải file mới</h2>
          <p className="muted">Chọn loại file, chọn file từ máy, sau đó bấm tải lên.</p>
        </div>

        <label>
          Loại file
          <select value={fileType} onChange={handleFileTypeChange}>
            {fileTypeOptions.map((option) => (
              <option key={option.value} value={option.value}>
                {option.label}
              </option>
            ))}
          </select>
        </label>

        <label className="file-picker">
          Chọn file từ máy
          <input
            accept={getAcceptByFileType(fileType)}
            type="file"
            onChange={(event) => setSelectedFile(event.target.files?.[0] || null)}
          />
          <span>{selectedFile ? selectedFile.name : 'Chưa chọn file'}</span>
        </label>

        <button className="primary-button" type="submit" disabled={saving}>
          {saving ? 'Đang tải file...' : 'Tải file'}
        </button>
      </form>

      <section className="admin-table-panel">
        <h2>Danh sách file</h2>
        {loading ? (
          <p className="state-message">Đang tải file...</p>
        ) : files.length === 0 ? (
          <p className="state-message">Chưa có file nào.</p>
        ) : (
          <div className="table-scroll">
            <table className="admin-table">
              <thead>
                <tr>
                  <th>Tên file</th>
                  <th>Loại file</th>
                  <th>Dung lượng</th>
                  <th>MIME</th>
                  <th>Nơi lưu trữ</th>
                  <th>Thao tác</th>
                </tr>
              </thead>
              <tbody>
                {files.map((file) => (
                  <tr key={file.id}>
                    <td>{file.fileName}</td>
                    <td>{getFileTypeLabel(file.fileType)}</td>
                    <td>{formatFileSize(file.fileSize)}</td>
                    <td>{file.mimeType || '-'}</td>
                    <td>Local</td>
                    <td>
                      <div className="table-actions">
                        {file.fileUrl && (
                          <>
                            <a className="secondary-button small-action" href={file.fileUrl} target="_blank" rel="noreferrer">
                              Xem file
                            </a>
                            <button className="ghost-button small-action" type="button" onClick={() => handleCopyLink(file.fileUrl)}>
                              Sao chép link
                            </button>
                          </>
                        )}
                        <button className="danger-button small-action" type="button" onClick={() => handleDelete(file.id)}>
                          Xóa
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </section>
    </section>
  )
}

export default AdminFilesPage
