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

Setup Certificates
------------------

The web server expects three files `~/depot/synrc/cert/ecc/server.pem`,
`~/depot/synrc/cert/ecc/server.key` and `~/depot/synrc/cert/ecc/caroot.pem`.
In order to obtain them you must issue CSR request to <a href="https://ca.n2o.space">SYNRC CA</a>
by running synrc `mad` tool from `~/depot/synrc` folder. 

```
$ mkdir -p ~/depot/synrc
$ cd ~/depot/synrc
$ mad ecc server $UNIQUE-NAME
$ cd cert/ecc
$ mmv $UNIQUE-NAME\* server\#1
```

Please note that `$UNIQUE-NAME` placeholder should contain
unique common name (CN) to be registered at CA otherwise
CSR request will fail.

Build and Run
-------------

```
$ mix deps.get
$ iex -S mix
```

Then open https://localhost:8048/app/ldap.htm.
Enter `Maxim Sokhatsky` as login.

Credits
-------

* Oleksandr Palchikovsky
* Maxim Sokhatsky
