alice
=====

_"...must a name mean something?" Alice asked doubtfully._

 * introduction
 * getting started
 * more information

introduction
------------

Like a seven-and-a-half year old girl in a land she doesn't
know who's still willing to tell everyone she meets all
the mistakes they are making, Alice is simple and pedantic.

Alice provides simple code quality metrics.  Really simple.
Like so simple she doesn't build an AST, she's just running
regexes and a state machine.

That means she's fast, but she isn't very powerful.  Right
now Alice will warn you about:

 * File line counts in excess of her LINE_COUNT_LIMIT
   (which defaults to 300)
 * Line lengths in excess of her LINE_LENGTH_LIMIT
   (defaults to 65)
 * Curly-braced blocks in excess of 300, 100, 40 or 5 lines,
   given the nesting level
 * Parenthesized expressions in excess of 150 or 50
   characters based on nesting level
 * Inconsistent whitespace characters
 * Trailing whitespace characters
 * final variables named in any way other than ALL_CAPS
 * classes named in any way other than CamelCase
 * Class name/file name mismatch (for Apex files)

Don't run `coffeelint` against Alice, she won't like it.

getting started
---------------

Alice has a CLI intended for use with Apex, just run

```bash
> ./script/alice path/to/class/files
```

If you are just starting to use Alice on a project,
you can get a one-number metric on the code health
by running

```bash
> ./script/alice path/to/class/files/* | wc -l
```

Right now it's at about 20,000 for two of my clients.
Ouch.

more information
----------------

_nothing yet_
