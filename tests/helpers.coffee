# setup testing environment
assert = QUnit
test = QUnit.test
module = (name, fn) ->
    QUnit.module name
    fn()