# Fridge Sensors

## An API for evaluating Fridge Sensor data.

* The bulk of my logic is in `api/utils.js`, with GraphQL resolvers calling it in `api/resolvers.js`.
* For fans of express/REST, the same code is called in the root directory's `index.js`

## Setup

1.  Run `npm install` or `yarn`
2.  Run `npm run dev` or `yarn run dev`
3.  Boot up [Insomnia](https://insomnia.rest/) or your preferred REST Client

## Usage

You get two ways of feeding this micro-service data:

1.  `POST` to http://localhost:3001/api the dataset (I provided this to match the requirements as much as possible):

```
[
  {
    "id": "a",
    "timestamp": 1509493641,
    "temperature": 3.53
  },
  {
    "id": "b",
    "timestamp": 1509493642,
    "temperature": 4.13
  },
  {
    "id": "c",
    "timestamp": 1509493643,
    "temperature": 3.96
  },
  {
    "id": "a",
    "timestamp": 1509493644,
    "temperature": 3.63
  },
  {
    "id": "c",
    "timestamp": 1509493645,
    "temperature": 3.96
  },
  {
    "id": "a",
    "timestamp": 1509493645,
    "temperature": 4.63
  },
  {
    "id": "a",
    "timestamp": 1509493646,
    "temperature": 3.53
  },
  {
    "id": "b",
    "timestamp": 1509493647,
    "temperature": 4.15
  },
  {
    "id": "c",
    "timestamp": 1509493655,
    "temperature": 3.95
  },
  {
    "id": "a",
    "timestamp": 1509493677,
    "temperature": 3.66
  },
  {
    "id": "b",
    "timestamp": 1510113646,
    "temperature": 4.15
  },
  {
    "id": "c",
    "timestamp": 1510127886,
    "temperature": 3.36
  },
  {
    "id": "c",
    "timestamp": 1510127892,
    "temperature": 3.36
  },
  {
    "id": "a",
    "timestamp": 1510128112,
    "temperature": 3.67
  },
  {
    "id": "b",
    "timestamp": 1510128115,
    "temperature": 3.88
  }
]
```

2.  `POST` to http://localhost:3001/graphql the following query:

```
query CalcInputs($data: [SensorInput]!){
	input(data: $data){
		id
		average
		median
		mode
	}
}
```

the same data as previously, but wrapped in a `data` object:

```
{
	"data": [
		{
			"id": "a",
			"timestamp": 1509493641,
			"temperature": 3.53
		},
		{
			"id": "b",
			"timestamp": 1509493642,
			"temperature": 4.13
		},
		{
			"id": "c",
			"timestamp": 1509493643,
			"temperature": 3.96
		},
		{
			"id": "a",
			"timestamp": 1509493644,
			"temperature": 3.63
		},
		{
			"id": "c",
			"timestamp": 1509493645,
			"temperature": 3.96
		},
		{
			"id": "a",
			"timestamp": 1509493645,
			"temperature": 4.63
		},
		{
			"id": "a",
			"timestamp": 1509493646,
			"temperature": 3.53
		},
		{
			"id": "b",
			"timestamp": 1509493647,
			"temperature": 4.15
		},
		{
			"id": "c",
			"timestamp": 1509493655,
			"temperature": 3.95
		},
		{
			"id": "a",
			"timestamp": 1509493677,
			"temperature": 3.66
		},
		{
			"id": "b",
			"timestamp": 1510113646,
			"temperature": 4.15
		},
		{
			"id": "c",
			"timestamp": 1510127886,
			"temperature": 3.36
		},
		{
			"id": "c",
			"timestamp": 1510127892,
			"temperature": 3.36
		},
		{
			"id": "a",
			"timestamp": 1510128112,
			"temperature": 3.67
		},
		{
			"id": "b",
			"timestamp": 1510128115,
			"temperature": 3.88
		}
	]
}
```

It should look like this:
![GraphQL Insomnia screenshot](/static/img/graphql-insomnia.png?raw=true 'GraphQL Insomnia')

## Infrastructure notes

`webpack.config.babel.js` is provided for building and deploying - I would normally run this on AWS Lambda, with a terraform script building my environment.

Depending on the load from the incoming sensors, one might want to run this code on a dedicated instance for cost savings (relative to running a Lambda function 24/7)
