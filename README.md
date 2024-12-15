# Boolean Satisfiability (SAT) Solver

## Overview:
An OCaml implementation of a Boolean satisfiability solver that processes Conjunctive Normal Form (CNF) formulas and finds satisfying variable assignments.

## Input Format:
- CNF formula as space-separated string
- Example: "( a OR b OR NOT c ) AND ( NOT a ) AND TRUE"

## Output Format:
- List of variable assignments as (string * bool) list
- Example: [("a", false); ("b", true)]
- Returns [("error", true)] if unsatisfiable

## Functions:
- buildCNF: Converts input to CNF data structure
- evaluateCNF: Evaluates assignments against CNF
- satisfy: Main solver function
- Various helper functions for processing formulas


## Usage:
Test using OCaml interpreter <br>
- #use "project2.ml";;
- #load "str.cma";;
- #use "project2_driver.ml";;
