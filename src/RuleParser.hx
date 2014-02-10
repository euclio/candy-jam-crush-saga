class RuleParser {
    public var rules: Array<Rule>;

    public function new() {
        rules = new Array<Rule>();
        var rulesString = openfl.Assets.getText("rules/rules.xml");
        var xml: Xml = Xml.parse(rulesString).firstElement();
        var i = 0;
        for (rule in xml.elements()) {
            rules[i++] = new Rule(rule);
        }
    }
}