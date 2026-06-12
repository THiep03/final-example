import { useEffect, useMemo, useState } from 'react'
import { deleteFile, getFiles, uploadFile } from '../api/fileApi.js'
import Pagination from '../components/Pagination.jsx'

const FILE_TYPE_OPTIONS = [
  { value: 'video',    label: 'Video',    accept: 'video/*' },
  { value: 'image',    label: 'Hình ảnh', accept: 'image/*' },
  { value: 'document', label: 'Tài liệu', accept: '.pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.txt,application/*' },
]

const FILE_TYPE_FILTER = [{ value: '', label: 'Tất cả loại' }, ...FILE_TYPE_OPTIONS]

function getFileTypeLabel(type) {
  return FILE_TYPE_OPTIONS.find(o => o.value === type)?.label || 'Tệp'
}

function getAcceptByFileType(type) {
  return FILE_TYPE_OPTIONS.find(o => o.value === type)?.accept || '*/*'
}

function formatFileSize(size) {
  if (size == null) return '—'
  if (size < 1024)        return `${size} B`
  if (size < 1024 * 1024) return `${Math.round(size / 1024)} KB`
  return `${(size / 1024 / 1024).toFixed(1)} MB`
}

function getTypeClass(type) {
  if (type === 'video')    return 'ftype-video'
  if (type === 'image')    return 'ftype-image'
  if (type === 'document') return 'ftype-doc'
  return ''
}

const TYPE_ICON = { video: '🎬', image: '🖼️', document: '📄' }

function AdminFilesPage() {
  const [files, setFiles]           = useState([])
  const [fileType, setFileType]     = useState('video')
  const [selectedFile, setSelectedFile] = useState(null)
  const [loading, setLoading]       = useState(true)
  const [saving, setSaving]         = useState(false)
  const [error, setError]           = useState('')
  const [success, setSuccess]       = useState('')

  // search + filter + pagination
  const [search, setSearch]         = useState('')
  const [filterType, setFilterType] = useState('')
  const [page, setPage]             = useState(1)
  const [pageSize, setPageSize]     = useState(10)

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
    let alive = true
    getFiles()
      .then(data => { if (alive) { setFiles(data); setError('') } })
      .catch(err => { if (alive) setError(err.response?.data?.message || 'Không thể tải file.') })
      .finally(() => { if (alive) setLoading(false) })
    return () => { alive = false }
  }, [])

  useEffect(() => { setPage(1) }, [search, filterType, pageSize])

  const filtered = useMemo(() => {
    const q = search.toLowerCase().trim()
    return files.filter(f => {
      const matchSearch = !q || f.fileName?.toLowerCase().includes(q)
      const matchType   = !filterType || f.fileType === filterType
      return matchSearch && matchType
    })
  }, [files, search, filterType])

  const totalPages = Math.max(1, Math.ceil(filtered.length / pageSize))
  const safePage   = Math.min(page, totalPages)
  const pageItems  = filtered.slice((safePage - 1) * pageSize, safePage * pageSize)

  const handleUpload = async (e) => {
    e.preventDefault()
    setError(''); setSuccess('')
    if (!selectedFile) { setError('Vui lòng chọn file cần tải lên.'); return }
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
    if (!fileUrl) return
    try {
      await navigator.clipboard.writeText(fileUrl)
      setSuccess('Đã sao chép link file.')
      setError('')
    } catch {
      setError('Không thể sao chép link file.')
      setSuccess('')
    }
  }

  const handleDelete = async (id) => {
    if (!window.confirm('Bạn có chắc muốn xóa file này?')) return
    setError(''); setSuccess('')
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

      <div className="adm-page-header">
        <div>
          <p className="eyebrow">Quản trị nội dung</p>
          <h1>Quản lý file</h1>
          <p className="muted">Tải file từ máy lên hệ thống để dùng cho ảnh khóa học, video bài học hoặc tài liệu.</p>
        </div>
        <div className="adm-header-meta">
          <span className="adm-total-badge">{files.length} file</span>
        </div>
      </div>

      {error   && <p className="alert">{error}</p>}
      {success && <p className="success-alert">{success}</p>}

      {/* upload form */}
      <div className="adm-form-card">
        <div className="adm-form-card-head">
          <div>
            <p className="eyebrow">Tải lên</p>
            <h2>Tải file mới</h2>
          </div>
        </div>
        <form className="adm-form-body admin-form upload-form" onSubmit={handleUpload}>
          <label>
            Loại file
            <select value={fileType} onChange={e => { setFileType(e.target.value); setSelectedFile(null) }}>
              {FILE_TYPE_OPTIONS.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </label>
          <label className="file-picker">
            Chọn file từ máy
            <input accept={getAcceptByFileType(fileType)} type="file" onChange={e => setSelectedFile(e.target.files?.[0] || null)} />
            <span>{selectedFile ? selectedFile.name : 'Chưa chọn file'}</span>
          </label>
          <div className="admin-form-actions">
            <button className="primary-button" type="submit" disabled={saving}>
              {saving ? 'Đang tải...' : 'Tải file lên'}
            </button>
          </div>
        </form>
      </div>

      {/* table panel */}
      <section className="admin-table-panel">
        <div className="adm-table-header">
          <div>
            <h2>Danh sách file</h2>
            <p className="muted">Tổng cộng <strong>{filtered.length}</strong> kết quả.</p>
          </div>
          <div className="adm-table-filters">
            <div className="adm-search-box">
              <span className="adm-search-icon">🔍</span>
              <input
                className="adm-search-input"
                placeholder="Tìm theo tên file..."
                value={search}
                onChange={e => setSearch(e.target.value)}
              />
              {search && (
                <button className="adm-search-clear" type="button" onClick={() => setSearch('')}>✕</button>
              )}
            </div>
            <select className="adm-filter-select" value={filterType} onChange={e => setFilterType(e.target.value)}>
              {FILE_TYPE_FILTER.map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
            </select>
          </div>
        </div>

        {loading ? (
          <p className="state-message">Đang tải file...</p>
        ) : filtered.length === 0 ? (
          <p className="state-message">{search || filterType ? 'Không tìm thấy file phù hợp.' : 'Chưa có file nào.'}</p>
        ) : (
          <>
            <div className="table-scroll">
              <table className="admin-table">
                <thead>
                  <tr>
                    <th className="col-id">STT</th>
                    <th>Tên file</th>
                    <th>Loại</th>
                    <th>Dung lượng</th>
                    <th>MIME</th>
                    <th>Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  {pageItems.map((file, idx) => (
                    <tr key={file.id}>
                      <td className="col-id adm-id-cell">{(safePage - 1) * pageSize + idx + 1}</td>
                      <td>
                        <div className="adm-file-name-cell">
                          <span className="adm-file-icon">{TYPE_ICON[file.fileType] || '📁'}</span>
                          <span className="adm-name-cell">{file.fileName}</span>
                        </div>
                      </td>
                      <td>
                        <span className={`adm-ftype-badge ${getTypeClass(file.fileType)}`}>
                          {getFileTypeLabel(file.fileType)}
                        </span>
                      </td>
                      <td className="adm-muted-cell">{formatFileSize(file.fileSize)}</td>
                      <td className="adm-mime-cell">{file.mimeType || '—'}</td>
                      <td>
                        <div className="table-actions">
                          {file.fileUrl && (
                            <>
                              <a className="secondary-button small-action" href={file.fileUrl} target="_blank" rel="noreferrer">
                                Xem
                              </a>
                              <button className="ghost-button small-action" type="button" onClick={() => handleCopyLink(file.fileUrl)}>
                                Copy link
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
            <Pagination
              page={safePage}
              totalPages={totalPages}
              totalItems={filtered.length}
              pageSize={pageSize}
              onPageChange={setPage}
              onPageSizeChange={setPageSize}
            />
          </>
        )}
      </section>
    </section>
  )
}

export default AdminFilesPage
