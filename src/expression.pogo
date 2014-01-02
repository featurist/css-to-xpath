Renderer = require './renderer'

Expression (data) =
    extend (this, data)
    this

Expression.prototype.render (xpath, combinator) =
    (@new Renderer).render (self, xpath, combinator)

extend (o, d) = for @(k) in (d) @{ o.(k) = d.(k) }

module.exports = Expression
