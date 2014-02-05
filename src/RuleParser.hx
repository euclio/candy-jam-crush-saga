class RuleParser {
    public var rules: List<Rule>;

    public function new() {
        rules = new List<Rule>();
        var rulesString = openfl.Assets.getText("rules/rules.xml");
        var xml: Xml = Xml.parse(rulesString).firstElement();
        for (rule in xml.elements()) {
            rules.add(new Rule(rule));
        }
    }
}
