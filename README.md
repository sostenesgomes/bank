
# Elixir Banking API

Banking API is an api builded in elixir lang, to support some bank functionalities. Features:

- Create User and Bank account.
> This feature creates a user and their bank account (the bank account is linked to a bank branch).
It also checks for active promotion for the user creation event. For example, there is a promotion in which the user receives 1000.00 cash in the account when signing up.
- User Login.
>This feature requires that the user credentials (email and password) be sent and if the credentials are valid, a token will be sent in the response to be used in transfer and cashout requests.
- Fund transfers between accounts.
>This feature transfers money from the applicant's account to another account. The applicant must have the necessary money in their account to cover the transfer amount.
- Cashout
>This feature allows the requester to cashout money from their account. The requester must have enough in your account to cover the amount of the cashout. When the requester requests the cashout, an email is created and this email is logged in as a placeholder to be sent later to the requester.
- Reports
> Transactions report with total transactions by day, month, year and total.

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

Response - 201 Created
{
    "account": {
        "agency": {
            "code": 1234,
            "digit": 0
        },
        "code": "38427",
        "digit": 1
    },
    "email": "email1@mail.com",
    "name": "user1"
}
```

User Login
- **Copy the token provided in the response for use in transfer and cashout requests.**
```
POST /api/users/login HTTP/1.1
Host: localhost:4000
Accept: application/json
Content-Type: application/json
{
	"email": "email1@mail.com",
	"password": "passwd"
}

Response - 200 OK
{
    "email": "email1@mail.com",
    "name": "user1",
    "token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJiYW5rIiwiZXhwIjoxNTgwOTAyMTYzLCJpYXQiOjE1Nzg0ODI5NjMsImlzcyI6ImJhbmsiLCJqdGkiOiJkZWQ1YTZmOC0yMzQwLTRmM2MtOTkwMi0zMzMxMDMxM2FjZDQiLCJuYmYiOjE1Nzg0ODI5NjIsInN1YiI6IjIiLCJ0eXAiOiJhY2Nlc3MifQ.rlx23qS0DtDEvbmzhKkX6D3JGMXw4R3wzim8Mzf6SXLdeLnnHJehvB5wgqvscfgZ0aKVor1ScP_wCK01H3bYQw"
}
```

Fund transfers between accounts
```
POST /api/transactions/transfer HTTP/1.1
Host: localhost:4000
Accept: application/json
Content-Type: application/json
Authorization: Bearer paste_here_the_token_provided_at_login
{
	"transfer": {
		"target_account_code": "5425",
		"target_account_digit": 1,
		"amount": 500.0	
	}
}

Response - 201 Created
{
    "from": {
        "account": "38427-1",
        "amount": -500.0
    },
    "to": {
        "account": "5425-1",
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
Authorization: Bearer paste_here_the_token_provided_at_login
{
	"cashout": {
		"amount": 100.0	
	}
}

Response - 201 Created
{
    "amount": -100.0
}
```

Report Day
```
GET /api/transactions/report?type=day&amp; reference=2020-01-06 HTTP/1.1
Host: localhost:4000
Accept: application/json

Response - 200 OK
{
    "total_cash_inflow": "R$ 4.000,00",
    "total_cash_outflow": "R$ -1.100,00"
}
```

Report Month
```
GET /api/transactions/report?type=month&amp; reference=2020-01 HTTP/1.1
Host: localhost:4000
Accept: application/json

Response - 200 OK
{
    "total_cash_inflow": "R$ 4.000,00",
    "total_cash_outflow": "R$ -1.100,00"
}
```

Report Year
```
GET /api/transactions/report?type=year&amp; reference=2020 HTTP/1.1
Host: localhost:4000
Accept: application/json

Response - 200 OK
{
    "total_cash_inflow": "R$ 5.005,00",
    "total_cash_outflow": "R$ -1.106,00"
}
```

Report total.
```
GET /api/transactions/report?type=total&amp; reference= HTTP/1.1
Host: localhost:4000
Accept: application/json

Response - 200 OK
{
    "total_cash_inflow": "R$ 5.005,00",
    "total_cash_outflow": "R$ -1.106,00"
}
```

 # Application

 ## Modules
 The existing modules in the application are:
 - **Agencies**: Module responsible for storing and providing bank branch data. An agency may have multiple bank accounts.
 - **Accounts**: Module responsible for storing and providing bank account data. A bank account belongs to a user and also to a bank branch. An account can also have multiple transactions.
 - **Users**: Module responsible for storing and providing data about users. A user can have a bank account.
 - **Transactions**: Module responsible for storing and providing data on bank transactions, such as transfer and cashout. A transaction belongs to an account. The transaction belongs to an operation.
 - **Operations**: Module responsible for storing and providing Operations data. Operations are the records to identify the type of transaction. There are currently three operations:
	- 1 => Transfer Sent
	- 2 => Transfer Received
	- 3 => Cashout
- **Promotions**: Module responsible for storing and providing data about promotions. Promotions are applied at events. For example, there is an active promotion to give the user 1000.00 to their account when they sign up.

 ## Details
 The application is delivered by the Phoenix framework.
 
 The application uses:
 - **Guardian**: Guardian is a token based authentication library for use with Elixir applications.
 - **Bcrypt Elixir**: Bcrypt password hashing library for Elixir.
 - **Bamboo**: Flexible and easy to use email for Elixir.
 - **Money**: Elixir library for working with Money safer, easier, and fun... Is an interpretation of the Fowler's Money pattern in fun.prog.

 # Steps to run application

 - Install docker and docker compose.
 - Run `$ docker-compose build` to build application.
 - Run `$ docker-compose up -d dev` to start services.
 - Done! Test http://localhost:4000.

 # Run Tests
 
 - To run tests, execute `$ docker-compose run --rm -e "MIX_ENV=test" dev mix test`