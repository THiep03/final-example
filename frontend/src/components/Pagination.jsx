const PAGE_SIZE_OPTIONS = [10, 20, 50, 100]

function Pagination({ page, totalPages, totalItems, pageSize, onPageChange, onPageSizeChange }) {
  const from = totalItems === 0 ? 0 : (page - 1) * pageSize + 1
  const to   = Math.min(page * pageSize, totalItems)

  // build page number list with ellipsis
  const pages = []
  if (totalPages <= 7) {
    for (let i = 1; i <= totalPages; i++) pages.push(i)
  } else {
    pages.push(1)
    if (page > 3) pages.push('...')
    for (let i = Math.max(2, page - 1); i <= Math.min(totalPages - 1, page + 1); i++) pages.push(i)
    if (page < totalPages - 2) pages.push('...')
    pages.push(totalPages)
  }

  return (
    <div className="pagination-bar">
      <div className="pagination-left">
        <span className="pagination-info">
          {totalItems === 0
            ? 'Không có kết quả'
            : <>Hiển thị <strong>{from}–{to}</strong> trong <strong>{totalItems}</strong> kết quả</>
          }
        </span>
        {onPageSizeChange && (
          <div className="page-size-selector">
            <span>Hiển thị</span>
            <select
              className="page-size-select"
              value={pageSize}
              onChange={e => { onPageSizeChange(Number(e.target.value)); onPageChange(1) }}
            >
              {PAGE_SIZE_OPTIONS.map(n => (
                <option key={n} value={n}>{n} bản ghi</option>
              ))}
            </select>
          </div>
        )}
      </div>

      {totalPages > 1 && (
        <div className="pagination-controls">
          <button
            className="pg-btn"
            disabled={page === 1}
            onClick={() => onPageChange(1)}
            aria-label="Trang đầu"
          >
            «
          </button>
          <button
            className="pg-btn"
            disabled={page === 1}
            onClick={() => onPageChange(page - 1)}
            aria-label="Trang trước"
          >
            ‹
          </button>
          {pages.map((p, i) =>
            p === '...' ? (
              <span className="pg-ellipsis" key={`e${i}`}>…</span>
            ) : (
              <button
                className={`pg-btn${p === page ? ' pg-active' : ''}`}
                key={p}
                onClick={() => onPageChange(p)}
                aria-current={p === page ? 'page' : undefined}
              >
                {p}
              </button>
            )
          )}
          <button
            className="pg-btn"
            disabled={page === totalPages}
            onClick={() => onPageChange(page + 1)}
            aria-label="Trang sau"
          >
            ›
          </button>
          <button
            className="pg-btn"
            disabled={page === totalPages}
            onClick={() => onPageChange(totalPages)}
            aria-label="Trang cuối"
          >
            »
          </button>
        </div>
      )}
    </div>
  )
}

export default Pagination
