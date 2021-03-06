Title: Service Integration Guidelines

If you would like to have your service integration **maintained as a part of the Nuvola Player project
and distributed in the Nuvola Player repository**, following rules apply.

Rules
=====

1. Your work must have license approved by [the Open Source Initiative](http://opensource.org/licenses),
   preferably the same license as Nuvola Player (BSD 2-Clause "Simplified" or "FreeBSD" license).

2. The field ``maintainer_link`` of ``metadata.json`` must contain URL of your
   [Github profile][github]. (You will be subscribed to bug reports related to your service
   integrations).

3. You must provide contact e-mail.

4. You must use a consistent coding style of ``integrate.json``, preferably the coding style of
   Nuvola Player.

5. You must use [strict JavaScript mode][JS_STRICT] and [self-executing anonymous function][JS_SEAF].
   (See [tutorial]({filename}tutorial.md).)

6. You have to use Nuvola Player JavaScript API >= 3.0.

7. You have to [mark translatable strings]({filename}translations.md) in ``integrate.js``.

License
======= 

You should use the same license as Nuvola Player does (BSD 2-Clause "Simplified" or "FreeBSD"
license) unless you have severe reasons to choose different license. In that case you should stick
to the popular open-source licenses with strong communities:

  * [Apache License 2.0](http://opensource.org/licenses/Apache-2.0)
  * [BSD 3-Clause "New" or "Revised" license](http://opensource.org/licenses/BSD-3-Clause)
  * [BSD 2-Clause "Simplified" or "FreeBSD" license](http://opensource.org/licenses/BSD-2-Clause)
  * [GNU General Public License (GPL)](http://opensource.org/licenses/gpl-license)
  * [GNU Library or "Lesser" General Public License (LGPL)](http://opensource.org/licenses/lgpl-license)
  * [MIT license](/licenses/MIT)
  * [Mozilla Public License 2.0](/licenses/MPL-2.0)

Coding Style
============

Service integrations are maintained in separate repositories as more or less independent sub-projects.
Therefore, you can use different coding style that the main Nuvola Player project. However, your
coding style have to be consistent. You can get inspired by coding style of Nuvola Player:

Basics
------

 *  Source lines may be up to 100 characters long.
 *  Variables should be declared at the point where they are first needed rather than at the top of
    a block or function.

Naming
------

  * Prototype objects ("classes") are named in camel case: ``MediaPlayer``.
  * Constants (and values of enumerations) are all uppercase, with underscores between words: ``CONSTANT_NAME``
  * Other variables and method/function names are in camel case with the first letter lower-cased: ``methodName()``, ``myVariable``.
  * Usage of single-letter variables or abbreviations is discouraged except for temporary variables in loops (``i``, ``j``, etc.).

```js

// Prototype name
var ConfigStorage = Nuvola.$prototype(KeyValueStorage, SignalsMixin);

// Enumeration
var PlaybackState = {
    UNKNOWN: 0,
    PAUSED: 1,
    PLAYING: 2,
}

// Constant
var PI_VALUE = "3.14";

var myVariable = 5;
var myFunction = function(){};
```

Braces
------

  * Both opening and closing curly braces of code blocks appear on the new line. The code is more fluffy.
  * The opening curly brace of an object literal appears on the same line as a preceding assignment operator.
  * If body of ``if``, ``else``, ``while`` or ``for`` only one statement, it can be optionally surrounded by braces. However, it should always be on a new line with proper indentation.
  * If one branch of ``if-else`` block is braced, all should be braced.
  * To not put space between function name and opening brace.

```js

var foo = function()
{
    for (var i = 0 ; i < 10 ; ++i)
    {
        ...
    }
}

if (x == 4)
{
    ...
}
else
{
    ...
}

// Preferred
if (x >= 0)
    y = x;
else
    y = -x;

// Also possible
if (x >= 0)
{
    y = x;
}
else
{
    y = -x;
}

try
{
    ...
}
catch (e)
{
    ...
}

var person = {
    name: "Jiří",
    surname: "Janoušek",
}

```
Spaces
------

  * Indentation level is four spaces. Use a clever editor that can treat spaces as tabs, i.e. it
    inserts four spaces when you press TAB.
  * A blank line should be padded to the “natural” indentation level of the surrounding lines. 
  * Don't put spaces between function name and opening brace.
  * Don't put spaces between variable name and opening square brace.
  * Keywords like ``if``, ``for``, ``while`` and ``catch`` are followed by a space and opening bracket.
  * Don't use inner spaces of brackets.
  * Use spaces around binary operators.
  * Don't use spaces around unary and increment/decrement operators (e.g. ``++``, ``--``, ``!``, ``!!``, ``-``). 
  
```js

document.getElementById("foo");

myArray[1];

if (true)
    ...

var c = a + b;
var c = -b;
var c = --b;
var success = !failed;

```

  
[github]: https://github.com
[JS_STRICT]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions_and_function_scope/Strict_mode
[JS_SEAF]: http://markdalgleish.com/2011/03/self-executing-anonymous-functions/

[TOC]
