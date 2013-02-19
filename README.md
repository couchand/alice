alice
=====

_"...must a name mean something?" Alice asked doubtfully._

 * introduction
 * getting started
 * more information

introduction
------------

Alice provides simple code quality metrics.  Really simple.
Like so simple she doesn't build an AST, she's just running
regexes and a state machine.

That means she's fast, but she isn't very powerful.  Right
now Alice will warn you about:

 * File line counts in excess of her LINE_COUNT_LIMIT
   (which defaults to 300)
 * Line lengths in excess of her LINE_LENGTH_LIMIT
   (defaults to 65)
 * Inconsistent whitespace characters
 * Trailing whitespace characters
 * Class name/file name mismatch (for Apex files)

getting started
---------------

Alice has a CLI intended for use with Apex, just run

```bash
> ./script/alice path/to/class/files/*
```

more information
----------------

_nothing yet_
