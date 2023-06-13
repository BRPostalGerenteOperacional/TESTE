export default function serializeBigInt(data: object) {
  const serialized = JSON.stringify(data, (_, value) =>
    typeof value === 'bigint' ? value.toString() : value
  )

  return JSON.parse(serialized)
}
