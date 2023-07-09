function convertToUtc (dateStr: string): Date {
  const date = new Date(Date.parse(dateStr))
  const nowUtc = Date.UTC(date.getUTCFullYear(), date.getUTCMonth(),
    date.getUTCDate(), date.getUTCHours(),
    date.getUTCMinutes(), date.getUTCSeconds())
  return new Date(nowUtc)
}

export { convertToUtc }
