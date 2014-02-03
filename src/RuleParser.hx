

class RuleParser {
    public var rules: List<Rule>;

    public function new() {
        rules = new List<Rule>();
        var rulesString = openfl.Assets.getText("rules/rules.xml");
        trace(Xml.parse(rulesString));
    }
}
