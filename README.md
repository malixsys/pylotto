Py Lotto
===============

Installation
------------

* Install Node.js: http://nodejs.org/#download
* Install NPM, if needed: http://npmjs.org/dist
* Install _jasmine-node_ `npm install jasmine-node`
* Install _coffee-script_ `npm install coffee-script`
* Clone this repo `git clone https://github.com/malixsys/pyloto.git`

Run Specifications
------------
``
node_modules\.bin\jasmine-node --coffee specs/
``

Execution
------------
`node lotto.js *command*`

Ex.

``
node lotto.js achat "Pierre Poutine"
``

Commands
------------
* **status** - Displays a JSON of the internal status
* **effacer** `amount` - Resets the status, with _amount_ cash (200$, if ommited)
* **achat _name_** or **achat "_name with spaces_"** - buys a ticket for _name_ 
* **tirage** - draws three winners
* **gagnants** - displays a table of winners


## Copyright and license

Copyright 2012 Twitter, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this work except in compliance with the License.
You may obtain a copy of the License in the LICENSE file, or at:

  [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
