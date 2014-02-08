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
    
    private function satisfyAdjacent(condition: Stipulation) {
        return false;
    }

    private function satisfySameRow(condition: Stipulation) {
        return false;
    }

    private function satisfySameCol(condition: Stipulation) {
        return false;
    }

    private function satisfyGreenZone(condition: Stipulation) {
        return false;
    }

    private function satisfyBubble(condition: Stipulation) {
        return false;
    }

    private function isStipulationSatisfied(stipulation: Stipulation,
                                            arcades: List<Arcade>) {
        return switch(stipulation.type) {
            case RuleType.Adjacent:
                satisfyAdjacent(stipulation);
            case RuleType.SameRow:
                satisfySameRow(stipulation);
            case RuleType.SameCol:
                satisfySameCol(stipulation);
            case RuleType.GreenZone:
                satisfyGreenZone(stipulation);
            case RuleType.Bubble:
                satisfyBubble(stipulation);
        }
    }

    public function verify(arcades: List<Arcade>): Bool {
        for (stipulation in forcedStipulations) {
            if (!isStipulationSatisfied(stipulation, arcades)) {
                return false;
            }
        }

        for (stipulation in disallowedStipulations) {
            if (isStipulationSatisfied(stipulation, arcades)) {
                return false;
            }
        }

        return true;
    }
}
