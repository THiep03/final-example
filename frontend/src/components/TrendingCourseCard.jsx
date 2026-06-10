import { useState } from 'react'
import { Link } from 'react-router-dom'

function TrendingCourseCard({ course }) {
  const [failedImageUrl, setFailedImageUrl] = useState('')
  const title = course.title || 'Khóa học chưa đặt tên'
  const initial = title.trim().charAt(0).toUpperCase() || 'K'
  const showImage = course.thumbnailUrl && failedImageUrl !== course.thumbnailUrl

  return (
    <Link className="course-card trending-course-card" to={`/courses/${course.id}`}>
      <div className="course-thumbnail">
        {showImage ? (
          <img src={course.thumbnailUrl} alt={title} onError={() => setFailedImageUrl(course.thumbnailUrl)} />
        ) : (
          <div className="thumbnail-placeholder">
            <span>{initial}</span>
            <small>Khóa học</small>
          </div>
        )}
      </div>

      <div className="course-card-content">
        <div className="course-card-header">
          <h2>{title}</h2>
          <span className="trend-badge">Xu hướng</span>
        </div>

        <p>{course.description || 'Chưa có mô tả cho khóa học này.'}</p>

        <div className="trend-stats" aria-label="Thống kê xu hướng">
          <span>
            <strong>{course.totalViews ?? 0}</strong>
            Lượt xem
          </span>
          <span>
            <strong>{course.totalLikes ?? 0}</strong>
            Lượt thích
          </span>
          <span>
            <strong>{course.totalDislikes ?? 0}</strong>
            Không thích
          </span>
        </div>

        <span className="course-card-action">Xem chi tiết</span>
      </div>
    </Link>
  )
}

export default TrendingCourseCard
