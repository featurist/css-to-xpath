parser = require 'bo-selector'.parser
xpath builder = require 'xpath-builder'.dsl()
Expression = require './expression'

parser.yy.create (data) = @new Expression (data)

parse (selector) =
    parser.parse (selector).render (xpath builder, 'descendant')

exports.parse = parse
