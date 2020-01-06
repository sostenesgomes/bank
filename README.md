
# Elixir Banking API

Banking API is an api builded in elixir lang, to support some bank functionalities. Features:

- Create User and Bank account.
- User Login.
- Fund transfers between accounts.
- Cashout
- Transactions report with total transactions by day, month, year and total.

# Requests

Create User and Bank account
```
POST /api/users/create HTTP/1.1
Host: localhost:4000
Accept: application/json
Content-Type: application/json
{
    "user": {
        "name": "user1",
        "password": "passwd",
        "email": "email1@mail.com"
    }
}
```

User Login
```
POST /api/users/login HTTP/1.1
Host: localhost:4000
Accept: application/json
Content-Type: application/json
{
	"email": "email1@mail.com",
	"password": "passwd"
}
```

Fund transfers between accounts
```
POST /api/transactions/transfer HTTP/1.1
Host: localhost:4000
Accept: application/json
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJiYW5rIiwiZXhwIjoxNTgwNzMyMDU2LCJpYXQiOjE1NzgzMTI4NTYsImlzcyI6ImJhbmsiLCJqdGkiOiIyMjQxYmYwNS0zN2I4LTQ2ODgtYWEzOC0zYTU4NjJjNDAyOGEiLCJuYmYiOjE1NzgzMTI4NTUsInN1YiI6IjEiLCJ0eXAiOiJhY2Nlc3MifQ.Dnl5Vk7bPUTbI0FVHhBkL0U6tnOVPFzUbNti0DEEn-ayZPVg5Od_DYjekYuDXRN20rom_wPCVp5-RGX4qHJ44g
{
	"transfer": {
		"target_account_code": "5425",
		"target_account_digit": 1,
		"amount": 500.0	
	}
}

```
Cashout
```
POST /api/transactions/cashout HTTP/1.1
Host: localhost:4000
Accept: application/json
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJiYW5rIiwiZXhwIjoxNTgwNzMyMDU2LCJpYXQiOjE1NzgzMTI4NTYsImlzcyI6ImJhbmsiLCJqdGkiOiIyMjQxYmYwNS0zN2I4LTQ2ODgtYWEzOC0zYTU4NjJjNDAyOGEiLCJuYmYiOjE1NzgzMTI4NTUsInN1YiI6IjEiLCJ0eXAiOiJhY2Nlc3MifQ.Dnl5Vk7bPUTbI0FVHhBkL0U6tnOVPFzUbNti0DEEn-ayZPVg5Od_DYjekYuDXRN20rom_wPCVp5-RGX4qHJ44g
{
	"cashout": {
		"amount": 100.0	
	}
}
```

Report Day
```
GET /api/transactions/report?type=day&amp; reference=2020-01-06 HTTP/1.1
Host: localhost:4000
Accept: application/json
```

Report Month
```
GET /api/transactions/report?type=month&amp; reference=2020-01 HTTP/1.1
Host: localhost:4000
Accept: application/json
```

Report Year
```
GET /api/transactions/report?type=year&amp; reference=2020 HTTP/1.1
Host: localhost:4000
Accept: application/json
```

Report total.
```
GET /api/transactions/report?type=total&amp; reference= HTTP/1.1
Host: localhost:4000
Accept: application/json

```

 # Steps to run application

 - Install docker and docker compose.
 - Run `$ docker-compose build` to build application.
 - Run `$ docker-compose up -d dev` to start services.
 - Done! Test http://localhost:4000.

 # Run Tests
 
 - To run tests, execute `$ docker-compose run --rm -e "MIX_ENV=test" dev mix test`