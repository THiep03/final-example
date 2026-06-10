export function getStoredUser() {
  try {
    return JSON.parse(localStorage.getItem('user') || 'null')
  } catch {
    return null
  }
}

export function normalizeList(value) {
  return Array.isArray(value) ? value : []
}

export function toNumericId(value) {
  const numericValue = Number(value)
  return Number.isFinite(numericValue) ? numericValue : null
}

export function sameId(first, second) {
  const firstId = toNumericId(first)
  const secondId = toNumericId(second)

  return firstId !== null && secondId !== null && firstId === secondId
}
