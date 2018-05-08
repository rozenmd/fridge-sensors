import { calculateSensorData } from '../api/utils'
export const handler = (event, context, callback) => {
  context.callbackWaitsForEmptyEventLoop = false
  console.log('event:', event)

  if (event.httpMethod == 'OPTIONS') {
    callback(null, {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Authorization, Content-Type',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH',
        'Access-Control-Allow-Credentials': 'true',
        'Content-Type': 'application/json',
      },
      body: null,
    })
  } else {
    try {
      let data = calculateSensorData(event.body)
      callback(null, {
        statusCode: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Authorization, Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH',
          'Access-Control-Allow-Credentials': 'true',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      })
    } catch (err) {
      callback(null, {
        statusCode: 503,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Authorization, Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH',
          'Access-Control-Allow-Credentials': 'true',
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(err),
      })
    }
  }
}
