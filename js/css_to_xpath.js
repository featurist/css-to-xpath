(function() {
    var self = this;
    var parser, xpathBuilder, Expression, parse;
    parser = require("bo-selector").parser;
    xpathBuilder = require("xpath-builder").dsl();
    Expression = require("./expression");
    parser.yy.create = function(data) {
        var self = this;
        return new Expression(data);
    };
    parse = function(selector) {
        return parser.parse(selector).render(xpathBuilder, "descendant");
    };
    exports.parse = parse;
}).call(this);