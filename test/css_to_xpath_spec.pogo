libxmljs = require "libxmljs"
css = require '../js/css_to_xpath.js'
cheerio = require 'cheerio'

describe 'css'

    select (expression, type, document) =
        selected = document.find(expression.to XPath(type))
        if (selected :: Array)
            (selected.map @(el)
                $ = cheerio(el.to string())
                $.name = el.name()
                $
            ) || []
        else
            selected

    (selector) should find (ids) in (html) =
        describe (selector)
            it "should find #(ids) #(html)"
                c = css.parse(selector)
                doc = libxmljs.parseXml("<top>" + html + "</top>")
                matching tags = select(c, nil, doc).map @(el) @{ el.name }
                matching tags.should.eql (ids)


    '*' should find ['a', 'b', 'c', 'd'] in '<a /><b /><c><d /></c>'

    'b' should find ['b', 'b', 'b', 'b'] in '<a><b><b /></b></a><b /><c><b /></c>'

    'a.b' should find ['a', 'a'] in '<b><a class="b"><a class="z b"></a></a></b>'

    '*.a.b' should find ['x', 'y', 'z'] in '<x class="a b" /><y class="b a c"><z class="a b" /></y><x />'

    "> a" should find ['a'] in '<a><b /><a><c /></a><a /></a>'

    "* > a" should find ['a', 'a'] in '<a><b /><a><c /></a><a /></a>'

    'b,c' should find ['b'] in '<a /><b />'

    'a, c' should find ['a', 'c'] in '<a /><b /><c />'

    '#foo' should find ['c'] in '<a><b><c id="foo" /></b></a>'

    '.foo' should find ['b', 'c'] in '<a><b class="foo"><c class="foo bar" /></b></a>'

    '.a.b' should find ['b'] in '<a class="a"><b class="a b" /></a>'

    "a[b]" should find ['a', 'a'] in '<a b="b" /><a b="c" /><b b="a" />'

    "a[b][c]" should find ['a'] in '<a b="b" /><a b="x" c="y" /><b b="a" />'

    "a > b" should find ['b', 'b'] in '<a><b /><a><b /><c><b /></c></a></a>'

    "a, > b" should find ['a', 'a', 'b'] in '<a><b /><a><b /><c><b /></c></a></a><b />'

    "a b > c" should find ['c', 'c'] in '<a><c /><b><c /></b><c><b><c /></b></c></a>'

    "a[b='c']" should find ['a', 'a'] in '<a b="c"><a b="c" /><a b="d" /><a /></a>'

    "a b" should find ['b', 'b', 'b'] in '<a><b /><a><b /><c><b /></c></a></a><b />'

    "a ~ b" should find ['b', 'b'] in '<a><b /><a><a /><b /></a><b /></a>'

    "a ~ b~c" should find ['c', 'c'] in '<a /><b /><c /><c />'

    "a ~ b.c" should find ['b'] in '<a class="c"><b /></a><a /><b class="d c" /><b />'

    "a ~ b > c" should find ['c'] in '<a /><b><c /></b><a><a /></a><b /><b />'

    "a ~ b c" should find ['c', 'c'] in '<a /><b><c /></b><a><a /></a><b><d><c /></d></b><b />'

    ".a ~ b" should find ['b'] in '<b /><x class="a" /><b /><x class="a" />'

    "a + b" should find ['b', 'b', 'b'] in '<z><a /><b /><a /><b /><b /><b /><a /><c><a /><b /></c></z>'

    "y > a + b" should find ['b'] in '<y><a /><b /></y><z><a /><b /></z>'

    "a + b + c" should find ['c'] in '<a /><b /><c /><c /><b /><c />'

    "a + b c" should find ['c', 'c', 'c'] in '<a /><b><c /></b><z><a /><b><x><c /><c /></x></b></z><c /><c /><c />'

    ".a b" should find ['b'] in '<c class="a"><b /></c><c><b /></c><b />'

    "c .a" should find ['b'] in '<c><b /></c><c><b class="a" /></c><b class="a" />'

    "a b, c > b" should find ['b', 'b'] in '<a><b /></a><c><c><b /></c></c>'

    "a b, #c > .b" should find ['b', 'z'] in '<a><b /></a><a id="c"><z class="b" /></a>'

    "a[b^='c']" should find ['a', 'a'] in '<a b="cx" /><a b="cy" /><a b="dz" />'

    "a[b^=c]"   should find ['a', 'a'] in '<a b="cx" /><a b="cy" /><a b="dz" />'

    "a[b$='c']" should find ['a', 'a'] in '<a b="xc" /><a b="yc" /><a b="zd" />'

    "a[b|='c']" should find ['a', 'a', 'a'] in '<a b="c-x" /><a b="c-y" /><a b="d-z"><a b="cz" /></a>'

    "*[a~='b']" should find ['x', 'y'] in '<x a="b" /><y a="c b" /><z b="c" />'

    "*:nth-child(2)" should find ['a', 'z'] in '<b><a /><a /><a /><c><a /><z /></c></b>'

    ":not(.a)" should find ['c', 'd', 'f'] in '<b class="a" /><c /><d /><e class="c a" /><f class="d" />'

    ":not(x, y)" should find ['a', 'c', 'b', 'a'] in '<a><x /></a><c><b><y><a /></y></b></c>'

    ":not(#a)" should find ['y', 'z'] in '<x id="a"><y /></x><z id="b" />'

    ":not(.a):not(.b)" should find ['x', 'y'] in '<w class="b" /><x /><y><z class="a" /></y><z class="c a" />'

    ":not(:not(.a))" should find ['x', 'y'] in '<x class="a"><y class="b a" /><z /></x><z class="b" />'

    ":not(:not(:not(a)))" should find ['x', 'y'] in '<x class="a"><y class="b a" /><a /></x><a class="b" />'

    ":has(.a)" should find ['b', 'c', 'd'] in '<b><x class="a" /></b><c><d><x class="a" /></d></c><e />'

    "a:has(b > c)" should find ['a', 'a'] in '<a><a><b><c /></b></a></a><a><c><b /></c></a>'

    ":not(:has(.a))" should find ['x', 'x', 'e'] in '<b><x class="a" /></b><c><d><x class="a" /></d></c><e />'

    "p.a:not(.b)" should find ['p', 'p'] in '<p class="a" /><p class="a b" /><p class="b" /><p class="d a" />'

    "a[b=c]:not(.d, .e)" should find ['a'] in '<a /><a b="c" /><b><a b="c d" /><a a="b" class="d" /></b>'

    "a:first-of-type()" should find ['a'] in "<a /><b><a /><a /></b><a /><a />"

    "a:first-of-type" should find ['a'] in "<a /><b><a /><a /></b><a /><a />"

    "a b.c:first-of-type" should find ['b'] in '<x><a><b class="d c" /><b class="d c" /></a></x>'

    "*:nth-of-type(2)" should find ['b'] in "<a><b><c /></b></a>"

    "x *.c:nth-of-type(3)" should find ['b'] in '<x><a><b class="d c" /><b class="d c" /><c class="c" /></a></x>'

    "*:nth-last-of-type(2)" should find ['y'] in '<x><y /></x><z />'

    "x a:nth-last-of-type(2) > .e" should find ['y'] in '<x><a><x class="e" /></a><a><y class="f e" /></a>><a><z class="e" /></a></x>'

    ".a:last-of-type()" should find ['z'] in '<a /><b class="a"><c><z class="a" /></c></b>'

    ".a:last-of-type" should find ['z'] in '<a /><b class="a"><c><z class="a" /></c></b>'

    "a:first-child" should find ['a', 'a'] in '<x><a /><a /><a /></x><y><a /></y>'

    "a:first-child()" should find ['a', 'a'] in '<x><a /><a /><a /></x><y><a /></y>'

    "*:last-child" should find ['y', 'z', 'x', 'x'] in '<x><y /></x><z><x><x /></x></z>'

    ":last-child" should find ['y', 'z', 'x', 'x'] in '<x><y /></x><z><x><x /></x></z>'

    ":last-child()" should find ['y', 'z', 'x', 'x'] in '<x><y /></x><z><x><x /></x></z>'

    "b:nth-child(2)" should find ['b', 'b'] in '<a><b /><b /></a><b /><b />'

    "a:nth-last-child(2)" should find ['a', 'a'] in '<a /><a><a /><a /></a><a />'

    "*:nth-last-child(2)" should find ['b', 'z'] in '<a><b /><y /></a><x /><z /><b />'

    ":nth-last-child(2)" should find ['b', 'z'] in '<a><b /><y /></a><x /><z /><b />'

    "a:only-child" should find ['a', 'a'] in '<a><a /><b><a><a /><a /></a></b></a>'

    "a:only-child()" should find ['a', 'a'] in '<a><a /><b><a><a /><a /></a></b></a>'

    ":only-child" should find ['b', 'c'] in '<a><b /></a><x><y /><z><c /></z></x>'

    "a:only-of-type" should find ['a'] in '<b><a /></b>'

    "a b:only-of-type()" should find ['b'] in '<a><c><b /></c></a><b /><a><b /><b /></a>'

    ":empty" should find ['a', 'c'] in '<x><a /><b><c /></b></x>'

    "a c:empty" should find ['c'] in '<a><c><a /><b><c /></b></c></a><c />'

    "*:nth-of-type(2n)" should find ['b', 'd'] in '<a /><b /><c /><d /><e />'

    "*:nth-of-type(2n+1)" should find ['a', 'c', 'e'] in '<a /><b /><c /><d /><e />'

    "*:nth-of-type(n+3)" should find ['c', 'd', 'e'] in '<a /><b /><c /><d /><e />'

    "*:nth-of-type(1n+3)" should find ['c', 'd', 'e'] in '<a /><b /><c /><d /><e />'

    "*:nth-of-type(-n+3)" should find ['a', 'b', 'c'] in '<a /><b /><c /><d /><e />'

    "*:nth-of-type(-1n+3)" should find ['a', 'b', 'c'] in '<a /><b /><c /><d /><e />'

    "*:nth-of-type(even)" should find ['b', 'd'] in '<a /><b /><c /><d /><e />'

    "*:nth-of-type(odd)" should find ['a', 'c', 'e'] in '<a /><b /><c /><d /><e />'

    "*:nth-last-of-type(2n)" should find ['b', 'd'] in '<a /><b /><c /><d /><e />'

    "*:nth-last-of-type(2n+1)" should find ['a', 'c', 'e'] in '<a /><b /><c /><d /><e />'

    "*:nth-last-of-type(n+3)" should find ['a', 'b', 'c'] in '<a /><b /><c /><d /><e />'

    "*:nth-last-of-type(1n+3)" should find ['a', 'b', 'c'] in '<a /><b /><c /><d /><e />'

    "*:nth-last-of-type(-n+3)" should find ['c', 'd', 'e'] in '<a /><b /><c /><d /><e />'

    "*:nth-last-of-type(-1n+3)" should find ['c', 'd', 'e'] in '<a /><b /><c /><d /><e />'

    "*:nth-last-of-type(even)" should find ['a', 'c', 'e'] in '<a /><b /><c /><d /><e /><f />'

    "*:nth-last-of-type(odd)" should find ['b', 'd', 'f'] in '<a /><b /><c /><d /><e /><f />'
