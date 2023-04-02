# Guring - A good night API

## Description
A "good night" application that enables users to track their bedtime and wake-up time.

- The application will require several RESTful APIs to accomplish its objectives.
- The Clock In feature allows users to start their sleep time and view all logged sleep times sorted by creation time.
- Users can follow and unfollow other users.
- Users will be able to view their friends' sleep records for the past week, sorted by sleep duration.

## How to run
1. clone this repo and then run commands below
2. run `bundle install`
3. run migration `bundle exec rails db:migrate`
4. run seeds `bundle exec rails db:seed`
5. start the server `bundle exec rails s`

For test you can run `bundle exec rspec`

# API Endpoints documentation

## User Endpoints
### Overview
- [GET /api/v1/users](https://github.com/muslihaqq/guring#get-apiv1users)
- [POST /api/v1/users/login](https://github.com/muslihaqq/guring#post-apiv1userslogin)
- [POST /api/v1/users/:id/follow](https://github.com/muslihaqq/guring#post-apiv1usersidfollow)
- [DELETE /api/v1/users/:id/unfollow](https://github.com/muslihaqq/guring#delete-apiv1usersidunfollow)
- [GET /api/v1/users/:id/sleep_records](https://github.com/muslihaqq/guring#get-apiv1usersidsleep_records)
- [GET /api/v1/users/:id](https://github.com/muslihaqq/guring#get-apiv1usersid)
- [POST /api/v1/sleep_records/clock_in](https://github.com/muslihaqq/guring#post-apiv1sleep_recordsclock_in)
- [PATCH /api/v1/sleep_records/clock_out](https://github.com/muslihaqq/guring#patch-apiv1sleep_recordsclock_out)
- [GET /api/v1/sleep_records](https://github.com/muslihaqq/guring#get-apiv1sleep_records)


### GET /api/v1/users
#### Request
```
curl --request GET \
  --url http://localhost:3000/api/v1/users \
  --header 'Accept: */*' \
  --header 'Content-Type: application/json'
 ```

#### Success response
```
{
	"data": [
		{
			"id": 1,
			"handle": "lilialilia",
			"name": "Efrain Considine",
			"created_at": "2023-04-01T09:55:51.528Z",
			"updated_at": "2023-04-01T09:55:51.528Z"
		},
		...
	],
	"metadata": {
		"prev_page": null,
		"current_page": 1,
		"next_page": null
	}
}
```

### POST /api/v1/users/login
#### request
```
curl --request POST \
  --url http://localhost:3000/api/v1/users/login \
  --header 'Accept: */*' \
  --header 'Content-Type: application/json' \
  --data '{
	"handle": "lilialilia"
}'
  
```
 ##### Header Parameters

#### Body parameters
|operator| type| description|
|---|---|---|
| `handle` | String | User handle |



#### Success response
```
{
	"data": {
		"id": 1,
		"handle": "Efrain Considine",
		"created_at": "2023-04-01T09:55:51.528Z",
		"updated_at": "2023-04-01T09:55:51.528Z",
		"token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.JC6qKuH9SG0SIiYSfhZUFTtirxN9Q47buLk0DPFFFzE"
	}
}
```
Use data[:token] field to use as authorization in header to access other APIs

#### Error response
```
{
	"error": "Login: Invalid user handle"
}
```

### POST /api/v1/users/:id/follow
#### request
```
curl --request POST \
  --url http://localhost:3000/api/v1/users/USER_ID/follow \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer YOUR_TOKEN' \
  --header 'Content-Type: application/json'
 ```
 ##### Header Parameters

| `Authorization` | `Bearer YOUR_TOKEN` |
|---|---|---|

#### Success response
```
{
	"data": {
		"message": "You are now following this user delmer"
	}
}
```
#### Error response
```
{
	"error": "Couldn't find User with 'id'=USER_ID"
}
```

### DELETE /api/v1/users/:id/unfollow
#### Request
```
curl --request DELETE \
  --url http://localhost:3000/api/v1/users/2/unfollow \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.JC6qKuH9SG0SIiYSfhZUFTtirxN9Q47buLk0DPFFFzE' \
  --header 'Content-Type: application/json' \
  --data '{
	"handle": "USER_HANDLER"
}'
```

##### Header Parameters

| `Authorization` | `Bearer YOUR_TOKEN` |
|---|---|---|

#### Success response
```
{
	"data": {
		"message": "Successfully unfollowed USER_HANDLER"
	}
}
```
#### Error response
User not being followed
```
{
	"error": "USER_HANDLER is not being followed"
}
```

User not found
```
{
	"error": "Couldn't find User with 'id'=USER_ID"
}
```

### [GET /api/v1/users/:id/sleep_records]
#### request
```
curl --request GET \
  --url http://localhost:3000/api/v1/users/2/sleep_records \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer YOUR_TOKEN' \
  --header 'Content-Type: application/json' \
  --data '{
	"handle": "USER_HANDLE"
}'
```

##### Header Parameters

| `Authorization` | `Bearer YOUR_TOKEN` |
|---|---|

#### Body parameters
|operator| type| description|
|---|---|---|
| `handle` | String | User handle |

##### Query parameters
|operator| type| description|
|---|---|---|
| `limit` | Number | to limit the records |
| `page` | Number | set the current page |


#### Success response
```
{
	"data": [
		{
			"id": 8,
			"clock_in": "2023-03-27T00:00:00.000Z",
			"clock_out": "2023-03-27T23:59:59.999Z",
			"user_id": 2,
			"created_at": "2023-04-02T07:37:08.540Z",
			"updated_at": "2023-04-02T07:37:08.540Z",
			"sleep_time": 86399.999999999
		},
		...
		"metadata": {
    		"prev_page": null,
    		"current_page": 1,
    		"next_page": null
	    }
	]
}
```

#### Error response 422
User not being followed
```
{
	"error": "You need to follow this user to see their sleep records"
}
```

### [GET /api/v1/users/:id]
#### Request
#### Success response
```
{
	"data": {
		"id": 2,
		"handle": "Keren Volkman",
		"created_at": "2023-04-01T09:55:51.538Z",
		"updated_at": "2023-04-01T09:55:51.538Z",
		"last_week_records": [
			{
				"id": 8,
				"clock_in": "2023-03-27T00:00:00.000Z",
				"clock_out": "2023-03-27T23:59:59.999Z",
				"user_id": 2,
				"created_at": "2023-04-02T07:37:08.540Z",
				"updated_at": "2023-04-02T07:37:08.540Z",
				"sleep_time": 86399.999999999
			},
      ...
		]
	}
}
```
##### Header Parameters

| `Authorization` | `Bearer YOUR_TOKEN` |
|---|---|

##### Query parameters
|operator| type| description|
|---|---|---|
| `limit` | Number | to limit the records |
| `page` | Number | set the current page |

#### Error response
User not found
```
{
	"error": "Couldn't find User with 'id'=USER_ID"
}
```

### [POST /api/v1/sleep_records/clock_in]
#### Request
```
curl --request POST \
  --url http://localhost:3000/api/v1/sleep_records/clock_in \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer YOUR_TOKEN' \
  --header 'Content-Type: application/json'
```
##### Header Parameters

| `Authorization` | `Bearer YOUR_TOKEN` |
|---|---|

#### Success response
```
{
	"data": {
		"message": "Successfully clock in!"
	}
}
```
#### Error response

### [PATCH /api/v1/sleep_records/clock_out]
#### Request
```
curl --request PATCH \
  --url http://localhost:3000/api/v1/sleep_records/clock_out \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer YOUR_TOKEN' \
  --header 'Content-Type: application/json'
```

##### Header Parameters

| `Authorization` | `Bearer YOUR_TOKEN` |
|---|---|


#### Success response
```
{
	"data": {
		"message": "Successfully clock out!"
	}
}
```
#### Error response
```
{
	"error": "Theres no incomplete record"
}
```

### [GET /api/v1/sleep_records]
#### Request
```
curl --request GET \
  --url http://localhost:3000/api/v1/sleep_records \
  --header 'Accept: */*' \
  --header 'Authorization: Bearer YOUR_TOKEN' \
  --header 'Content-Type: application/json'
```
##### Header Parameters

| `Authorization` | `Bearer YOUR_TOKEN` |
|---|---|

##### Query parameters
|operator| type| description|
|---|---|---|
| `limit` | Number | to limit the records |
| `page` | Number | set the current page |

#### Success response
```
{
	"data": [
		{
			"id": 15,
			"clock_in": "2023-04-02T07:45:37.665Z",
			"clock_out": "2023-04-02T07:46:09.623Z",
			"user_id": 1,
			"created_at": "2023-04-02T07:45:37.666Z",
			"updated_at": "2023-04-02T07:46:09.623Z",
			"sleep_time": 31.957229
		},
		...
  ]
	"metadata": {
		"prev_page": null,
		"current_page": 1,
		"next_page": null
	}
}
```