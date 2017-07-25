# The Virtuoso DBA — Solved Exercises


# Table of Contents

<!-- toc -->

- [Introduction](#introduction)
- [Oracle Database](#oracle-database)
  * [First Steps](#first-steps)
    + [List foreign constraints associated to their reference columns.](#list-foreign-constraints-associated-to-their-reference-columns)
  * [String Manipulation](#string-manipulation)
  * [Data Analytics](#data-analytics)
  * [Graphs and Trees](#graphs-and-trees)
  * [Grouping & Reporting](#grouping--reporting)
  * [Drawing](#drawing)
  * [Time Functions](#time-functions)
  * [Row Generation](#row-generation)
  * [Numerical Recipes](#numerical-recipes)
  * [XML Database 101](#xml-database-101)
  * [Enter Imperative Thinking](#enter-imperative-thinking)
  * [The MODEL Clause](#the-model-clause)
  * [A Stochastic World](#a-stochastic-world)
  * [Internals](#internals)

<!-- tocstop -->

# Introduction


# Oracle Database


## First Steps

### List foreign constraints associated to their reference columns.

    SELECT
        c.owner              AS source_owner,
        c.constraint_name    AS source_constraint_name,
        cc1.table_name       AS source_table_name,
        cc1.column_name      AS source_column_name,
        cc2.owner            AS target_owner,
        cc2.table_name       AS target_table_name,
        cc2.column_name      AS target_column_name
    FROM
        all_constraints  c
    JOIN
        all_cons_columns cc1
    ON
        c.constraint_name = cc1.constraint_name
    JOIN
        all_cons_columns cc2
    ON
        c.r_constraint_name = cc2.constraint_name AND cc1.position = cc2.position
    ORDER BY
        c.owner, c.constraint_name;


## String Manipulation


## Data Analytics


## Graphs and Trees


## Grouping & Reporting


## Drawing


## Time Functions


## Row Generation


## Numerical Recipes


## XML Database 101


## Enter Imperative Thinking


## The MODEL Clause


## A Stochastic World


## Internals


