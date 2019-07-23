# ats-go

[![CircleCI](https://circleci.com/gh/sazl/ats-go.svg?style=svg)](https://circleci.com/gh/sazl/ats-go)
[![Build status](https://ci.appveyor.com/api/projects/status/ukooyffmy5o79x5l?svg=true)](https://ci.appveyor.com/project/sazl/ats-go)

ATS to Go Transpiler (**WIP**)

## Credits

Based on [ATS-Python3](https://github.com/steinwaywhw/ATS-Python3)

## CATS-parsemit

ATS GO relies on the CATS-parsemit library that ships with ATS' contrib package.

CATS-parsemit tokenizes and parses ATS code, exporting ATS syntax trees as ATS datatypes.

[CATS-parsemit Data Types](./docs/syntax.md)

## Build

```
make all
```

## Test

```
make test
```

Test a fixture

```
make test fixture=test/fixtures/test.dats
```
