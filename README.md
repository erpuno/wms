WMS: Warehouse Management System
================================

The WMS in essense is a multidimentional indexed storage
of goods in different forms of measurement with 2 main
business process: Placement and Allocation.

Placemenet process is a route of delivery of cart
items of input order. Each step of this process in trace
corresponds to placment of one or multiple items from
cart to cell storage.

Allocation is an opposite process of satisfying supply
output order by completion the route of allocations ---
transfers from cell storage to cart.

Prerequisites
-------------

* Windows, Linux or Mac
* Erlang 22.1
* Elixir 1.9.1
* CMake 3.15

Environment
-----------

Here is minimal `./bash_profile` sample for Erlang built with `kerl`,
and Elixir installed with `exenv` into Windows Subsystem for Linux box:

```sh
. /usr/lib/erlang/activate
export PATH="$PATH:$HOME/.exenv/bin"
export PATH="$PATH:$HOME/depot/synrc/deps/mad"
export PATH="$PATH:/usr/lib/cmake/bin"
```

Setup Certificates
------------------

The web server expects three files `~/depot/synrc/cert/ecc/server.pem`,
`~/depot/synrc/cert/ecc/server.key` and `~/depot/synrc/cert/ecc/caroot.pem`.
In order to obtain them you must issue CSR request to <a href="https://ca.n2o.space">SYNRC CA</a>
by running <a href="https://mad.n2o.space">SYNRC MAD</a> tool from `~/depot/synrc` folder.

```sh
$ mkdir -p ~/depot/synrc
$ cd ~/depot/synrc
$ mad ecc server $UNIQUE
$ cd cert/ecc
$ mmv $UNIQUE\* server\#1
```

Please note that `$UNIQUE` placeholder should contain
unique common name (CN) to be registered at CA otherwise
CSR request will fail.

```sh
$ export UNIQUE=<Common Name>
```

Build and Run
-------------

```sh
$ mix deps.get
$ iex -S mix
```

Then open https://localhost:8048/app/ldap.htm.
Enter `Maxim Sokhatsky` as login.

Credits
-------

* Oleksandr Palchikovsky
* Maxim Sokhatsky
