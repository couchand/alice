checks
======

 * Unable to locate class name
   id: 0
   method: checkClassName
   severity: info
   message: "incorrectly formatted.  Unable to locate class name."
   description: this is probably an issue with the class name
     finding regex and not the actual class.
 * Class name/file name mismatch
   id: 1
   method: checkClassName
   severity: warn
   message: "contains a class with a different name"
   description: there is a mismatch between the passed-in file name
     and the inferred class name.  might be due to an error in the
     class name finding regex.  if legitimate, the class will not
     compile.
 * Class name naming convention violation
   id: 2
   method: checkClassName
   severity: violation
   message: "class should be named with CamelCase"
   description: classes should be named with CamelCase.  classes
     should never have a number or underscore in the name, though
     those are legal characters according to Apex.  the first letter
     should be a capital.
 * Instance-level final variable
   id: 3
   method: checkFinalVarNames
   severity: warn
   message: "constants should be static"
   description: variables declared as final should always be static.
     using a final variable to prevent modification is inappropriate.
     use an access object pattern instead.
 * Final variable naming convention violation
   id: 4
   method: checkFinalVarNames
   severity: violation
   message: "constants should be named with ALL_CAPS"
   description: variables declared as final should be written in
     ALL_CAPS.
 * File line count violation
   id: 5
   method: checkFileLineCount
   severity: violation
   default: 300
   message: "has too many lines"
   description: long files are a smell for excessively complicated
     classes.  single classes over the limit are likely endowed with
     far too much responsibility.
 * Line character length violation
   id: 6
   method: checkLineLength
   severity: violation
   default: 65
   message: "is too long"
   description: long lines make code difficult to read, understand,
     and maintain.  they are also harder to display in many situations,
     such as during code review.
 * No whitespace
   id: 7
   method: checkConsistentWhitespace
   severity: info
   message: "has no whitespace."
   description: this may be an issue with the whitespace detection.
     this check ignores newlines, so while it is possible to write
     syntactically legal Apex and fail this check, it is highly
     unlikely.
 * Whitespace inconsistency
   id: 8
   method: checkConsistentWhitespace
   severity: violation
   message: "contains inconsistent whitespace"
   description: consistent whitespace ensures that code displays
     correctly in all situations.  this prevents team members from
     wasting time worrying about whitespace issues.
 * Trailing whitespace
   id: 9
   method: checkTrailingWhitespace
   severity: violation
   message: "contains trailing whitespace"
   description: trailing whitespace only serves to cause formatting
     issues in the future.  removing trailing whitespace automatically
     is quite straightforward.  certain tools (git, for instance) also
     complain about trailing whitespace.
 * Unmatched grouping character
   id: 10
   method: checkBlockLengthCounts
   severity: warn
   message: "unmatched EXPECTED_CHAR, found ACTUAL_CHAR"
   description: possibly an error with the group matching algorithm.
     if not, this class will not compile.
 * Block line count violations
   id: 11
   method: checkBlockLengthCounts
   severity: violation
   default: 300 lines (class level)
            100 lines (method level)
            40 lines (if, while, for block level)
            5 lines (nested block level)
   message: "'BLOCK_CHAR' block has too many lines for depth BLOCK_DEPTH"
   description: long methods, blocks, and nested blocks are a smell
     that there may be too much responsibility in a single class.
     refactor longer methods into shorter composable atoms, and complex
     conditionals and loops into additional methods and classes.
 * Grouping character length violations
   id: 12
   method: checkBlockLengthCounts
   severity: violation
   default: parenthesized groups:
              150 characters (conditionals)
              50 characters (enclosed parens)
            square brace groups:
              500 characters (queries)
              3 characters (nested list index)
   message: "'BLOCK_CHAR' block has too many chars for depth BLOCK_DEPTH"
   description: long conditionals are a smell that the conditional is
     too complex.  refactor to provide a well-composed semantic predicate.
