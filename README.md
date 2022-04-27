# REST Webservice with CoffeeScript

## Heroku Instance

An example instance be running on https://fierce-peak-42999.herokuapp.com/

## Description of the Project

+ The goal of the project was to implement the task in a simple and elegant implementation.
+ Therefore the productive code should get along without external dependencies.
+ The server is very restrictive with the acceptance of Requests, in order to ensure a stable execution.
+ In addition to the server, the calculation functions `addUp` and `digitSum` were implemented as individual modules, since these are generalized features.

## Test Coverage

+ `addUp` and `digitSum` are checked with unit tests.
+ The server is checked via e2e-tests.

## Automation

+ The GitHub-CI is used to build and test the project after a push.
+ Actually I wanted to use the deployment of Heroku to automatically pull the new versions from github like in previous projects. But this seems to be temporarily not possible due to security issues: https://salesforce.stackexchange.com/questions/374037/when-i-am-trying-to-add-github-repo-to-a-heroku-app-it-throws-internal-server-e

## Possible Improvements

+ Next, I would definitely look at the limits of the number data type.

## Installation

    $ git clone https://github.com/p1tt1/rest_webservice_coffee.git
    $ cd rest_webservice_coffee
    $ npm ci
    $ npi run build

## Usage

    $ npm start

## License

This program and the accompanying materials are made available under the
terms of the Eclipse Public License 2.0 which is available at
http://www.eclipse.org/legal/epl-2.0.

This Source Code may also be made available under the following Secondary
Licenses when the conditions for such availability set forth in the Eclipse
Public License, v. 2.0 are satisfied: GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or (at your
option) any later version, with the GNU Classpath Exception which is available
at https://www.gnu.org/software/classpath/license.html.
