
<h1 align="center">Randori</h1>
<p align="center">
 <img src="https://raw.githubusercontent.com/etriphany/randori/master/docs/img/randori.png" width="400"/>
</p>
<h3 align="center">IoT Integration Test Toolkit</h3>

<p align="center">
 <img src="https://raw.githubusercontent.com/etriphany/randori/master/docs/img/runner.gif" width="738" height="252"/>
</p>

Randori was created to support integration tests on IoT projects.

It is shipped as a lightweight [Docker](www.docker.com) image and includes the following tools:
- [libcoap](https://libcoap.net): Provides a client for __CoAP__ based APIs
- [mosquitto-clients](https://mosquitto.org/): __MQTT__ clients from Eclipse Mosquitto
- [jq](https://stedolan.github.io/jq): Command line __JSON__ processor
- [bashunit](https://github.com/djui/bashunit): Test utils based on __bash__


## Requirements
- [Docker](www.docker.com)

## Install
```bash
  $ docker pull docker.pkg.github.com/etriphany/randori/randori:1.1.0
```

## Setup your tests

Create a folder `it` into your project structure and create 2 files inside.

> `tests.sh`
> ### See Implementing Tests
```bash
 #!/bin/bash

test_example() {
  # test steps and asserts
}

source $(dirname $(dirname $0))/randori.bash
```

> `randori.sh`
```bash
 #!/bin/bash

docker run --rm -ti --network host -v "$(dirname `pwd`)"/it:/home/randori/it docker.pkg.github.com/etriphany/randori/randori:1.1.0 $@

```
Run your test:

```bash
$ ./randori.sh
```
> ### Available options
>  -v, --verbose:   Print expected and provided values \
>  -s, --summary:   Only print summary omitting individual test results \
>  -q, --quiet:     Do not print anything to standard output \
>  -l, --lineshow:  Show failing or skipped line after line number \
>  -f, --failed:    Print only individual failed test results \
>  -h, --help:      Show usage screen

## Implementing Tests

### Test functions

You define your tests by creating functions that start with **test_**.

Inside each test you can define all operations and asserts you need to accoplish that test.
```bash
 #!/bin/bash

test_one() {
  assertEqualExp "path/level/a" "path/level/a"
  assertAtLeast 10 10
}

test_two() {
  skip assertReturn "$(ping 192.168.10.1 -c 1)" 0
  assertStartsExp "path/level/a" "path"
}

source $(dirname $(dirname $0))/randori.bash
```

### Setup
You can define a special function **setup** to perform any required initialization.

This function is called only once, before any test have been executed.
```bash
 #!/bin/bash

setup() {
  # define global variables and other setups procedures
  coap_host = "coap://host.local"
}

source $(dirname $(dirname $0))/randori.bash
```

### Teardown
You can define a special function **teardown** to perform any required cleanup.

This function is called only once, after all test have been executed.
```bash
 #!/bin/bash

teadown() {
  # run clean-up procedures
}

source $(dirname $(dirname $0))/randori.bash
```

### Asserts

- __assert__: param evaluates to true
```bash
 #!/bin/bash

test_example() {
  assert true
  assert false
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertEqualExp__: string is equal to an expected string
```bash
 #!/bin/bash

test_example() {
  assertEqualExp "path/level/a" "path/level/a"
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertNotEqualExp__: string is not equal to an expected string
```bash
 #!/bin/bash

test_example() {
  assertNotEqualExp "path/level/a" "path/level/b"
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertStartsExp__: string starts with an expected string
```bash
 #!/bin/bash

test_example() {
  assertStartsExp "path/level/a" "path"
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertContainsExp__: string contains an expected string
```bash
 #!/bin/bash

test_example() {
  assertContainsExp "path/level/a" "level"
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertEqualStr__: string is equal to an expected string
```bash
 #!/bin/bash

test_example() {
  assertEqualStr "Randori" "Randori"
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertNotEqualStr__: string is not equal to an expected string
```bash
 #!/bin/bash

test_example() {
  assertNotEqualStr "Randori" "Ninja"
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertReturn__: last command's return code is equal to an expected integer
```bash
 #!/bin/bash

test_example() {
  assertReturn "$(ping 192.168.10.1 -c 1)" 0
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertNotReturn__: last command's return code is not equal to an expected integer
```bash
 #!/bin/bash

test_example() {
  assertNotReturn "$(ping 192.168.10.1 -c 1)" 1
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertEqual__: integer is equal to an expected integer
```bash
 #!/bin/bash

test_example() {
  assertEqual 10 10
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertNotEqual__: integer is not equal to an expected integer
```bash
 #!/bin/bash

test_example() {
  assertNotEqual 10 11
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertGreaterThan__: integer is greater than an expected integer
```bash
 #!/bin/bash

test_example() {
  assertGreaterThan 10 5
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertAtLeast__: integer is greater than or equal to an expected integer
```bash
 #!/bin/bash

test_example() {
  assertAtLeast 10 10
  assertAtLeast 10 9
}

source $(dirname $(dirname $0))/randori.bash
```
- __assertLessThan__: integer is less than an expected integer
```bash
 #!/bin/bash

test_example() {
  assertLessThan 5 10
}
```
- __assertAtMost__: integer is less than or equal to an expected integer
```bash
 #!/bin/bash

test_example() {
  assertAtMost 10 10
  assertAtMost 9 10
}

source $(dirname $(dirname $0))/randori.bash
```

### Other
- __skip__: skip an assert
```bash
 #!/bin/bash

test_example() {
  skip assert false
}

source $(dirname $(dirname $0))/randori.bash
```
- __rnd__: random number generator
```bash
 #!/bin/bash

test_example() {
  local num=$(rnd 10)
}

source $(dirname $(dirname $0))/randori.bash
```

## Testing COAP REST APIs

The __coap-client__ can be used to perform CoAP requests, like:
```bash
$ coap-client -m get coap://192.168.10.10:8118/d/config
```

The __jq__ can be used to parse the JSON documents, like:
```bash
$ jq '.name' <<< "{\"name\": \"Randori\"}"
```

So we can combine both to make assertions about a REST API that uses _COAP_ with _JSON_ payloads:
```bash
 #!/bin/bash

test_coap_endpoint() {
  build_payload "temperature" "sensor-b"

  # using 'sed' to remove COAP headers and keep just the JSON response body
  local response=$(coap-client -m post -f payload.json coap://192.168.10.10:8118/sensor | sed -Ee '/v:1 t:CON/d')
  # assert response attribute
  assertEqualStr $(jq '.type' <<< "$response") "\"temperature\""
  # or even simpler by using jq built in features:
  assert $(jq '.type == "temperature"' <<< "$response")
}

build_payload() {
cat <<EOF > payload.json
  {
    "type":"$1",
    "name":"$2"
  }
EOF
}

source $(dirname $(dirname $0))/randori.bash
```

## Testing MQTT Messaging

The __mosquitto_sub__ can be used to subscribe MQTT topics, like:
```bash
  $  mosquitto_sub --C 1 -W 10 -L mqtt://user:pass@host:1234/topic-name
```

The __mosquitto_pub__ can be used to publish into MQTT topics, like:
```bash
  $  mosquitto_pub -m "my message" -L mqtt://user:pass@host:1234/topic-name
```

The __jq__ can be used to parse the JSON documents, like:
```bash
  $ jq '.name' <<< "{\"name\": \"Randori\"}"
```

So we can combine them to make assertions about _MQTT_ messages with _JSON_ payloads:
```bash
 #!/bin/bash

test_mqtt_message() {
  build_payload "1" "on"

  # publish relay change command
  assert $(mosquitto_pub -f payload.json mqtt://user:pass@host:1234/command/relay)
  # wait for relay change status (1st message or timeout in 10 seconds)
  local response=$(mosquitto_sub -C 1 -W 10 -L mqtt://user:pass@host:1234/event/relay/1)
  # or even simpler by using jq built in features:
  assert $(jq '.state == "on"' <<< "$response")
}

build_payload() {
cat <<EOF > payload.json
  {
    "id":"$1",
    "state":"$2"
  }
EOF
}

source $(dirname $(dirname $0))/randori.bash
```