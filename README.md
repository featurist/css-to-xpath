# css-to-xpath

Converts [CSS3 selectors](http://www.w3.org/TR/css3-selectors/#selectors) to their XPath equivalents.

[![Build Status](https://secure.travis-ci.org/featurist/css-to-xpath.png?branch=master)](http://travis-ci.org/featurist/css-to-xpath)

### Usage

```js
var cssToXPath = require('css-to-xpath');

cssToXPath('p:not(:has(a.x))');
```
...returns the string:
```
.//p[not(.//a[contains(concat(' ', normalize-space(./@class), ' '), ' x ')])]
```

### How?

css-to-xpath parses css selectors using [bo-selector](https://github.com/featurist/bo-selector) and turns them into xpaths using [xpath-builder](https://github.com/featurist/xpath-builder)

### Install

npm install css-to-xpath

### License

BSD