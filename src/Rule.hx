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

                trace(type, ruleArgument);

                var arcades = new List<ArcadeType>();

                for (arcade in stipulationXml.elements()) {
                    trace(arcade);
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

    private function verifyAdjacent(condition: Stipulation, arcades: List<Arcade>) {
        for (arcade in arcades) {
            if (Type.enumEq(arcade.arcadeType, condition.arguments.first())) {
                arcade.setHitbox(Arcade.tileWidth * 3, Arcade.tileWidth * 3, cast(arcade.x, Int) - Arcade.tileWidth, cast(arcade.y, Int) + Arcade.tileWidth);
                var adjacent = new Array<Arcade>();
                arcade.collideInto("arcade", arcade.x, arcade.y, adjacent);
                
                for (a in adjacent) {
                    if (Type.enumEq(a.arcadeType, condition.arguments.last())) {
                        break;
                    }
                }
                
                return false;
            }
        }
    
        return true;
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

    public function verify(arcades: List<Arcade>): Bool {
        for (condition in conditions) {
            switch(condition.type) {
                case RuleType.Adjacent:
                    return verifyAdjacent(condition, arcades);
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
