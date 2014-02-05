typedef Stipulation = {type: RuleType,
                       ruleArgument: Int,
                       arguments: List<ArcadeType>};

enum RuleType {
    Adjacent;
    SameRow;
    SameCol;
    GreenZone;
    Bubble;
}

class Rule {
    private var forcedStipulations: List<Stipulation>;
    private var disallowedStipulations: List<Stipulation>;

    public function new(ruleXml: Xml) {
        var forcedStipulations = new List<Stipulation>();
        var disallowedStipulations = new List<Stipulation>();

        for (stipulationGroup in ruleXml.elements()) {
            var stipulationType = stipulationGroup.nodeName;
            for (stipulationXml in stipulationGroup.elements()) {
                var type = switch(stipulationXml.nodeName) {
                    case "adjacent":
                        Adjacent;
                    case "same-row":
                        SameRow;
                    case "same-col":
                        SameCol;
                    case "green-zone":
                        GreenZone;
                    case "bubble":
                        Bubble;
                    default:
                        trace("Error: invalid stipulation type encountered");
                        throw "error";
                }

                var ruleArgument: Int = switch(type) {
                    case Bubble:
                        Std.parseInt(stipulationXml.get("r"));
                    default:
                        0;
                }

                var arcades = new List<ArcadeType>();

                for (arcade in stipulationXml.elements()) {
                    var arcadeType = switch(arcade.get("type")) {
                        case "candy":
                            ArcadeType.king;
                        case "edge":
                            ArcadeType.edge;
                        case "scroll":
                            ArcadeType.scroll;
                        case "apple":
                            ArcadeType.apple;
                        case "memory":
                            ArcadeType.memory;
                        case "any":
                            ArcadeType.any;
                        default:
                            trace("Error: invalid arcade type found");
                            throw "error";
                    }
                    arcades.add(arcadeType);
                }

                var stipulation: Stipulation = {
                    type : type,
                    ruleArgument : ruleArgument,
                    arguments : arcades,
                }

                switch(stipulationType) {
                    case "disallow":
                        disallowedStipulations.add(stipulation);
                    case "force":
                        forcedStipulations.add(stipulation);
                    default:
                        trace("Error: bad stipulation type encountered.");
                        throw "error";
                }
            }
        }
    }

    private function verifyAdjacent(condition: Stipulation) {
        return false;
    }

    private function verifySameRow(condition: Stipulation) {
        return false;
    }

    private function verifySameCol(condition: Stipulation) {
        return false;
    }

    private function verifyGreenZone(condition: Stipulation) {
        return false;
    }

    private function verifyBubble(condition: Stipulation) {
        return false;
    }

    public function verify(arcades: Dynamic): Bool {
        for (condition in conditions) {
            switch(condition.type) {
                case RuleType.Adjacent:
                    return verifyAdjacent(condition);
                case RuleType.SameRow:
                    return verifySameRow(condition);
                case RuleType.SameCol:
                    return verifySameCol(condition);
                case RuleType.GreenZone:
                    return verifyGreenZone(condition);
                case RuleType.Bubble:
                    return verifyBubble(condition);
            }
        }

        return false;
    }
}
