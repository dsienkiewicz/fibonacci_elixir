# FibonacciElixir

## Local development

For the best experience for local development please use [`asdf`](https://asdf-vm.com/guide/introduction.html) tool for local package management.

Before starting your work execute this script:
```
asdf install
```

This will install all packages from `.tool-versions` file.

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## API endpoints

Applications exposes its services through REST API.

List of available endpoints:

* `GET /api/calculations/{number}`, where `{number}` is a positive integer value - calculates Fibonacci sequence value for given index number
  
cURL example

```bash
curl http://localhost:4000/api/calculations/42

# {"data":267914296,"input":42}
```

* `GET /api/calculations/list/{number}?page={page}&size={size}`, where `{number}` is a positive integer value, `{page}` is a positive integer value representing pagination page number, `{size}` is a positive integer number representing pagination page size - calculates Fibonacci sequence values from 1 up to given index number
  
cURL example

```bash
curl "http://localhost:4000/api/calculations/list/42?page=2&size=5"

# {"data":[{"data":8,"input":6},{"data":13,"input":7},{"data":21,"input":8},{"data":34,"input":9},{"data":55,"input":10}],"page_info":{"size":5,"page":2}}
```

* `GET /api/blacklist/` - returns a blacklist numbers

  After blacklisting a number, it should be removed from all calculations - both input value and result.

cURL example

```bash
curl http://localhost:4000/api/blacklist

# {"data":[]}
```

* `POST /api/blacklist/` with JSON body `{"number": {number}}` where `{number}` is a positive integer value - adds number to blacklist.
  
cURL example

```bash
curl -d '{"number": 42}' -H "Content-Type: application/json" -X POST http://localhost:4000/api/blacklist

# 
```

* `DELETE /api/blacklist/{number}` where `{number}` is a positive integer value - deletes number from blacklist

cURL example

```bash
curl -X DELETE http://localhost:4000/api/blacklist/42

# 
```

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
