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

1.  `POST` to http://localhost:3001/api or https://fridge-rest.rozenmd.com/api the dataset (I provided this to match the requirements as much as possible):

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

2.  `POST` to http://localhost:3001/graphql or https://fridge.rozenmd.com/api the following query:

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

See /infrastructure for terraform config - most of it is boilerplate from previous generic lambda functions - rolled out for speed, rather than security in mind.

Depending on the load from the incoming sensors, one might want to run this code on a dedicated instance for cost savings (relative to running a Lambda function 24/7)

## Assumptions/Opinionated decisions

* Incoming data can be null for a given sensor (in case a reading failed, etc). In this case, the reading will be ignored, rather than taking as a value of 0
* If all incoming data for a given sensor is null, average, median and mode will not be calculated - the service will only return data for sensors with incoming data

## Design Considerations:

* No thought has been given into checking the timestamps - it is assumed that all readings submitted to the service need to be used in the calculation. As such, to use this system in production, it might be worth sending API calls at regular intervals to have meaningful results.
* Scalability - when this service runs on serverless architecture, it is effectively infinitely scalable (bound by account limits). As no external resources such as databases are invoked, on a non-serverless system the bound will be CPU/RAM
* The service allows both GraphQL and standard POST calls. GraphQL was used as the consumer may not always wish to receive all fields, for example they may wish to only fetch the average for a given sensor - GraphQL allows for this.
