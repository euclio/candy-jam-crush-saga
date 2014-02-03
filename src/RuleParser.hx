class RuleParser {
    public var rules: List<Rule>;

    public function new() {
        rules = new List<Rule>();
        var rulesString = openfl.Assets.getText("rules/rules.xml");
        for (rule in Xml.parse(rulesString)) {
            rules.add(parseRule(rule));
        }
    }

    public function parseRule(rule: Xml): Rule {
        return new Rule();
    }
}
