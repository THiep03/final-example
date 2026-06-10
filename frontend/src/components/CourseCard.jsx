import { useState } from 'react'
import { Link } from 'react-router-dom'

function CourseCard({ course }) {
  const [failedImageUrl, setFailedImageUrl] = useState('')
  const title = course.title || 'Khóa học chưa đặt tên'
  const initial = title.trim().charAt(0).toUpperCase() || 'K'
  const showImage = course.thumbnailUrl && failedImageUrl !== course.thumbnailUrl

  return (
    <Link className="course-card product-course-card" to={`/courses/${course.id}`}>
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
        </div>
        <p>{course.description || 'Chưa có mô tả cho khóa học này.'}</p>

        <div className="course-metric-row">
          <span>{course.lessonCount ?? 0} bài học</span>
          <span>{course.totalViews ?? 0} lượt xem</span>
          <span>{course.totalLikes ?? 0} lượt thích</span>
        </div>

        <span className="course-card-action">Xem chi tiết</span>
      </div>
    </Link>
  )
}

export default CourseCard
