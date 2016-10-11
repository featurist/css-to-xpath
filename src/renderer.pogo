xpath builder = require('xpath-builder').dsl()

Renderer () = this

Renderer.prototype = {

    render (node, xpath, combinator) =
        fn = self.(node.type)
        if (!fn) @{ throw (@new Error "No renderer for '#(node.type)'") }
        fn.call(self, node, xpath, combinator)

    selector_list (node, xpath, combinator) =
        x = self.render(node.selectors.0, xpath, combinator)
        for (i = 1, i < node.selectors.length, ++i)
            x := x.union(self.render(node.selectors.(i), xpath, combinator))

        x

    constraint_list (node, xpath, combinator) =
        self.element (node, xpath, combinator)

    element (node, xpath, combinator) =
        self.apply constraints (node, xpath.(combinator).call(xpath, node.name || '*'))

    combinator_selector (node, xpath, combinator) =
        left = self.render(node.left, xpath, combinator)
        self.render(node.right, left, node.combinator)

    immediate_child (node, xpath) =
        self.render(node.child, xpath, 'child')

    pseudo_func (node, xpath) =
        fn = self.(node.func.name.replace(r/-/g, '_'))
        if (fn)
            fn.call (self, node, xpath)
        else
            throw (@new Error "Unsupported pseudo function :#(node.func.name)()")

    pseudo_class (node, xpath) =
        fn = self.(node.name.replace(r/-/g, '_'))
        if (fn)
            fn.call (self, node, xpath)
        else
            throw (@new Error "Unsupported pseudo class :#(node.name)")

    has (node, xpath) =
        self.render(node.func.args, xpath builder, 'descendant')

    not (node, xpath) =
        first child = node.func.args.selectors.0
        child type = first child.type
        if (child type == 'constraint_list')
            self.combine constraints(first child, xpath).inverse()
        else
            self.matches selector list (node.func.args, xpath).inverse()

    nth_child (node, xpath) =
        xpath.nth child(Number(node.func.args))

    first_child (node, xpath) =
        xpath.first child()

    last_child (node, xpath) =
        xpath.last child()

    nth_last_child (node, xpath) =
        xpath.nth last child(Number(node.func.args))

    only_child (node, xpath) =
        xpath.only child()

    only_of_type (node, xpath) =
        xpath.only of type()

    nth_of_type (node, xpath) =
        type = node.func.args.type
        if (type == 'odd')
            xpath.nth of type odd ()
        else if (type == 'even')
            xpath.nth of type even ()
        else if (type == 'an')
            xpath.nth of type mod (Number(node.func.args.a))
        else if (type == 'n_plus_b')
            xpath.nth of type mod (1, Number(node.func.args.b))
        else if (type == 'an_plus_b')
            xpath.nth of type mod (Number(node.func.args.a), Number(node.func.args.b))
        else
            xpath.nth of type (Number(node.func.args))

    nth_last_of_type (node, xpath) =
        type = node.func.args.type
        if (type == 'odd')
            xpath.nth last of type odd ()
        else if (type == 'even')
            xpath.nth last of type even ()
        else if (type == 'an')
            xpath.nth last of type mod (Number(node.func.args.a))
        else if (type == 'n_plus_b')
            xpath.nth last of type mod (1, Number(node.func.args.b))
        else if (type == 'an_plus_b')
            xpath.nth last of type mod (Number(node.func.args.a), Number(node.func.args.b))
        else
            xpath.nth last of type (Number(node.func.args))

    last_of_type (node, xpath) =
        xpath.last of type()

    empty (node, xpath) =
        xpath.empty()

    has_attribute (node, xpath) =
        xpath builder.attr(node.name)

    attribute_equals (node, xpath) =
        xpath builder.attr(node.name).equals(node.value)

    attribute_contains (node, xpath) =
        xpath builder.attr(node.name).contains(node.value)

    attribute_contains_word (node, xpath) =
        xpath.concat(' ', xpath builder.attr(node.name).normalize(), ' ').contains(" #(node.value) ")

    attribute_contains_prefix (node) =
        xpath builder.attr(node.name).starts with (node.value).or(
            xpath builder.attr(node.name).starts with (node.value + '-')
        )

    attribute_starts_with (node, xpath) =
        xpath builder.attr(node.name).starts with(node.value)

    attribute_ends_with (node) =
        xpath builder.attr(node.name).ends with(node.value)

    class (node) =
        self.attribute_contains_word ({ name = 'class', value = node.name }, xpath builder)

    id (node) =
        xpath builder.attr('id').equals(node.name)

    previous_sibling (node, xpath, combinator) =
        left = self.render(node.left, xpath, combinator)
        self.apply constraints (node.right, left.axis("following-sibling", node.right.name))

    adjacent_sibling (node, xpath, combinator) =
        left = self.render(node.left, xpath, combinator)
        self.apply constraints (node.right, left.axis("following-sibling::*[1]/self", node.right.name))

    first_of_type (node, xpath) =
        xpath.first of type ()

    contains (node, xpath) =
        xpath builder.contains(node.func.args.selectors.0.name)

    matches selector list (node, xpath) =
        if (node.selectors.length > 0)
            condition = self.matches selector(node.selectors.0, xpath builder)
            for (i = 1, i < node.selectors.length, ++i)
                condition := condition.or(self.matches selector(node.selectors.(i), xpath builder))

            condition
        else
            xpath

    matches selector (node, xpath) =
        xpath.name().equals(node.name)

    combine constraints (node, xpath) =
        condition = self.render(node.constraints.0, xpath)
        for (i = 1, i < node.constraints.length, ++i)
            condition := condition.and(self.render(node.constraints.(i), condition))

        condition

    apply constraints (node, xpath) =
        if (node.constraints.length > 0)
            xpath.where(self.combine constraints (node, xpath))
        else
            xpath

}

module.exports = Renderer
