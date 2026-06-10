import { useEffect, useMemo, useState } from 'react'
import CourseCard from '../components/CourseCard.jsx'
import { getCourses, getTrendingCourses } from '../api/courseApi.js'
import { getLessons } from '../api/lessonApi.js'
import { normalizeList, toNumericId } from '../utils/flowHelpers.js'

const filterOptions = [
  { value: 'trending', label: 'Xu hướng' },
  { value: 'views', label: 'Nhiều lượt xem' },
  { value: 'likes', label: 'Nhiều lượt thích' },
  { value: 'newest', label: 'Mới nhất' },
]

function enrichCourses(courses, trendingCourses, lessons) {
  const trendById = new Map(normalizeList(trendingCourses).map((course) => [toNumericId(course.id), course]))

  return normalizeList(courses).map((course) => {
    const trend = trendById.get(toNumericId(course.id))

    return {
      ...course,
      lessonCount: normalizeList(lessons).filter((lesson) => Number(lesson.courseId) === Number(course.id)).length,
      totalViews: trend?.totalViews || 0,
      totalLikes: trend?.totalLikes || 0,
      totalDislikes: trend?.totalDislikes || 0,
      trendScore: trend?.trendScore || 0,
    }
  })
}

function sortCourses(courses, filter) {
  return [...courses].sort((first, second) => {
    if (filter === 'views') {
      return (second.totalViews || 0) - (first.totalViews || 0)
    }
    if (filter === 'likes') {
      return (second.totalLikes || 0) - (first.totalLikes || 0)
    }
    if (filter === 'newest') {
      return new Date(second.createdAt || 0) - new Date(first.createdAt || 0)
    }

    return (second.trendScore || 0) - (first.trendScore || 0)
  })
}

function CoursesPage() {
  const [courses, setCourses] = useState([])
  const [trendingCourses, setTrendingCourses] = useState([])
  const [lessons, setLessons] = useState([])
  const [searchTerm, setSearchTerm] = useState('')
  const [activeFilter, setActiveFilter] = useState('trending')
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState('')

  useEffect(() => {
    let isMounted = true

    const loadCourses = async () => {
      try {
        const [coursesData, trendingData, lessonsData] = await Promise.all([
          getCourses(),
          getTrendingCourses().catch(() => []),
          getLessons().catch(() => []),
        ])
        if (isMounted) {
          setCourses(normalizeList(coursesData))
          setTrendingCourses(normalizeList(trendingData))
          setLessons(normalizeList(lessonsData))
          setError('')
        }
      } catch (err) {
        if (isMounted) {
          setError(err.response?.data?.message || 'Không thể tải danh sách khóa học.')
        }
      } finally {
        if (isMounted) {
          setLoading(false)
        }
      }
    }

    loadCourses()

    return () => {
      isMounted = false
    }
  }, [])

  const visibleCourses = useMemo(() => {
    const enrichedCourses = enrichCourses(courses, trendingCourses, lessons)
    const normalizedSearch = searchTerm.trim().toLowerCase()
    const searchedCourses = normalizedSearch
      ? enrichedCourses.filter((course) =>
          `${course.title || ''} ${course.description || ''}`.toLowerCase().includes(normalizedSearch),
        )
      : enrichedCourses

    return sortCourses(searchedCourses, activeFilter)
  }, [activeFilter, courses, lessons, searchTerm, trendingCourses])

  return (
    <section className="page-shell wide-shell courses-page">
      <div className="course-list-hero">
        <div>
          <p className="eyebrow">Khóa học</p>
          <h1>Khám phá khóa học phù hợp với bạn</h1>
          <p>
            Tìm khóa học theo mức độ quan tâm, lượt xem và lượt thích từ cộng đồng học tập.
          </p>
        </div>
      </div>

      <div className="course-toolbar">
        <label className="course-search">
          <span>Tìm kiếm khóa học</span>
          <input
            type="search"
            value={searchTerm}
            onChange={(event) => setSearchTerm(event.target.value)}
            placeholder="Nhập tên khóa học hoặc mô tả"
          />
        </label>

        <div className="course-filter-group" aria-label="Bộ lọc khóa học">
          {filterOptions.map((option) => (
            <button
              className={activeFilter === option.value ? 'active' : ''}
              key={option.value}
              type="button"
              onClick={() => setActiveFilter(option.value)}
            >
              {option.label}
            </button>
          ))}
        </div>
      </div>

      {loading && <p className="state-message">Đang tải khóa học...</p>}
      {error && <p className="alert">{error}</p>}

      {!loading && !error && visibleCourses.length === 0 && (
        <p className="state-message">Không tìm thấy khóa học phù hợp.</p>
      )}

      {!loading && !error && visibleCourses.length > 0 && (
        <div className="course-grid">
          {visibleCourses.map((course) => (
            <CourseCard key={course.id} course={course} />
          ))}
        </div>
      )}
    </section>
  )
}

export default CoursesPage
