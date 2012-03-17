Py Lotto
===============

Current version
----------------
``
0.5
``

Installation
------------

* Install Node.js: http://nodejs.org/#download
* Install NPM: http://npmjs.org/dist

``
npm install jasmine-node
``

``
npm install coffee-script
``

``
git clone https://github.com/malixsys/pyloto.git
``

Tests
------------
``
node_modules\.bin\jasmine-node --coffee spec
``

Execution
------------
node lotto.js [command]

Ex.

``
node lotto.js achat "Pierre Poutine"
``

Commands
------------
* status
    Displays a JSON of the internal status
* effacer
    Resets the status
* achat
    name or achat "name with spaces" - buys a ticket for name
* tirage
    draws three winners
* gagnants
    displays a table of winners


