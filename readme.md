# The PLAN Language Interpreter

A comprehensive interpreter implementation for the PLAN programming language, featuring a complete functional programming environment with expression evaluation and function capabilities.

## Overview

The PLAN Language Interpreter is a Scheme-based implementation that processes and executes programs written in the PLAN programming language. The interpreter provides:

1. **Expression Evaluation** - Supports arithmetic operations, conditionals, and variable bindings.
2. **Function Support** - Allows function definition and application.
3. **Testing Framework** - Comprehensive test suite for validation and verification.

## The PLAN Grammar

```
<Program> ::= (planProg <Expr>)
<Expr> ::= <Id>
| <Const>
| (planIf <Expr> <Expr> <Expr>)
| (planAdd <Expr> <Expr>)
| (planMul <Expr> <Expr>)
| (planSub <Expr> <Expr>)
| (planLet <Id> <Expr> <Expr>)
| (planLet <Id> <Function> <Expr>)
| (<Id> <Expr>)
<Function> ::= (planFunction <Id> <Expr>)
<Id> ::= a | b | ... | z
<Const> ::= integer constant
```

Please note that each __PLAN__ program and expression evaluates to an integer value.

## Usage

### Running the Interpreter

**Interactive mode with Scheme 48:**
```bash
scheme48
> (load "cases.scm")
> (test 1)
```

**Running all tests:**
```bash
./TestMyfns.scm
```

### Testing

The interpreter includes comprehensive test cases:

- `cases.scm` - Test case definitions and interactive testing functions.
- `TestMyfns.scm` - Automated test runner.
- `myfns.scm` - Core interpreter implementation.

### Example Programs

**Basic arithmetic:**
```scheme
(planProg (planAdd 5 5))
; Evaluates to: 10
```

**Conditional expressions:**
```scheme
(planProg (planIf 1 10 20))
; Evaluates to: 10
```

**Variable binding:**
```scheme
(planProg (planLet x 5 (planAdd x 5)))
; Evaluates to: 10
```
