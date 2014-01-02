parser = require 'bo-selector'.parser
xpath builder = require 'xpath-builder'.dsl()
Expression = require './expression'

parser.yy.create (data) = @new Expression (data)

parse (selector) =
    parser.parse (selector).render (xpath builder, 'descendant')

convert to xpath (selector) =
    parse (selector).to XPath()

convert to xpath.parse = parse

module.exports = convert to xpath
