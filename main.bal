import ballerina/http;
type Foo record {|
    Bar? next;
    int index;
|};

type Bar record {|
    map<Baz> val;
|};

type BarZ record {|
    map<BazZ> val;
|};

type Baz record {|
    int x;
|};

type BazZ record {|
    byte x;
|};

isolated function foo() returns int {
    int n = 0;
    int N = 1000;
    foreach int i in 0 ... N {
        Bar bars = bar();
        foreach var value in bars.val {
            if value is BazZ {
                n += 1;
            }
        }
    }

    foreach int i in 0 ... N {
        BarZ bars = barZ();
        foreach var value in bars.val {
            if value is BazZ {
                n += 1;
            }
        }
    }
    return n;
}

isolated function bar() returns Bar {
    map<Baz> val = {};
    foreach int i in 0 ... 100 {
        val[string `key${i}`] = baz();
    }
    return {val};
}

isolated function barZ() returns BarZ {
    map<BazZ> val = {};
    foreach int i in 0 ... 100 {
        val[string `key${i}`] = bazZ();
    }
    return {val};
}

isolated function baz() returns Baz {
    return {x: 1};
}

isolated function bazZ() returns BazZ {
    return {x: 1};
}

service / on new http:Listener(9090) {

    resource function get test/[int id]() returns int {
        return foo();
    }
}
