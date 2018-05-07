import cors from 'cors'
import express from 'express'
import webpack from 'webpack'

import schema from './api/schema'
import { json } from 'body-parser'
import { graphql } from 'graphql'
import { calculateSensorData } from './api/utils'
const PORT = process.env.PORT || 3001

const app = express()

app.use(cors())

app.post('/graphql', json(), (req, res) => {
  const { query, variables } = req.body
  const rootValue = {}
  const context = {}
  let operationName

  graphql(schema, query, rootValue, context, variables, operationName)
    .then(d => {
      res
        .status(200)
        .set('Content-Type', 'application/json')
        .send(JSON.stringify(d))
    })
    .catch(e => {
      res
        .status(500)
        .set('Content-Type', 'application/json')
        .send(JSON.stringify(e))
    })
})

app.post('/api', json(), (req, res) => {
  const { body } = req
  try {
    let data = calculateSensorData(body)
    res
      .status(200)
      .set('Content-Type', 'application/json')
      .send(JSON.stringify(data))
  } catch (err) {
    res
      .status(500)
      .set('Content-Type', 'application/json')
      .send(JSON.stringify(err))
  }
})

app.listen(PORT, err => {
  if (err) {
    throw err
  }
  console.log(`Listening on http://localhost:${PORT}/`)
})
