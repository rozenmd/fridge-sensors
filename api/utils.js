const PRECISION = 2

export function calculateSensorData(data) {
  let memo = cleanData(data)
  //now iterate on each key's values
  let finalOutput = Object.keys(memo).map(key => {
    let output = { id: key }
    const readingsCount = memo[key].values.length
    memo[key].values.sort()

    output['average'] = getAverage(readingsCount, memo[key].sum)
    output['median'] = getMedian(readingsCount, memo[key].values)
    output['mode'] = getMode(memo[key].values)
    return output
  })
  return finalOutput
}

function precisionRound(number, precision) {
  var factor = Math.pow(10, precision)
  return Math.round(number * factor) / factor
}

export function cleanData(arr) {
  let memo = {}
  //iterate once, pull out necessary data
  arr.forEach(row => {
    //quickly check for nulls - don't want to pollute our data
    if (!row.temperature) {
      return
    }
    if (memo[row.id]) {
      memo[row.id].values.push(row.temperature)
      memo[row.id].sum += row.temperature
    } else {
      memo[row.id] = { sum: row.temperature, values: [row.temperature] }
    }
  })
  return memo
}

export function getMedian(length, arr) {
  let median = 0
  if (length > 0) {
    let firstMedian = Math.floor(length / 2)
    if (length % 2 === 0) {
      median = (arr[firstMedian] + arr[firstMedian - 1]) / 2
    } else {
      median = arr[firstMedian]
    }
  }
  median = precisionRound(median, PRECISION)
  return median
}

export function getAverage(length, sum) {
  //Note that I could have used this solution: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/round#A_better_solution
  //or something out of a library rather than rolling my own round() for JS
  let average = 0
  if (length > 0) {
    average = precisionRound(sum / length, PRECISION)
  }
  return average
}

export function getMode(arr) {
  let mode = []
  let topFreq = 0
  let memo = {}
  arr.forEach(value => {
    memo[value] = (memo[value] || 0) + 1
    if (topFreq < memo[value]) {
      topFreq = memo[value]
    }
  })
  Object.keys(memo).forEach(key => {
    if (memo[key] === topFreq) {
      mode.push(key)
    }
  })
  return mode
}
