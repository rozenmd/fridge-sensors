import { calculateSensorData } from './utils'
export default {
  Query: {
    input(root, { data }, ctx) {
      return calculateSensorData(data)
    },
  },
}
