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
    
    public function toString() {
        trace ("forced:");
        for (s in forcedStipulations) {
            trace(s.type + " " + s.ruleArgument);
        }
        trace ("disallowed:");
        for (s in disallowedStipulations) {
            trace(s.type);
            for (a in s.arguments) {
                trace(a);
            }
        }
    }

    public function new(ruleXml: Xml) {
        forcedStipulations = new List<Stipulation>();
        disallowedStipulations = new List<Stipulation>();
        
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
    
    private function satisfyAdjacent(condition: Stipulation, arcades: List<Arcade>) {
        for (arcade in arcades.filter(
                                    function(a) { 
                                        return Type.enumEq(a.arcadeType, condition.arguments.last()); 
                                    } )) {
            arcade.setHitbox(Arcade.tileWidth * 3, Arcade.tileWidth * 3, 
                                    cast(arcade.x, Int) - Arcade.tileWidth, cast(arcade.y, Int) + Arcade.tileWidth);
            var adjacent = new Array<Arcade>();
            arcade.collideInto("arcade", arcade.x, arcade.y, adjacent);
            
            if (Type.enumEq(condition.arguments.first(), ArcadeType.any)) {
                if (adjacent.length == 0) {
                    return false;
                }
            } 
            else {
                var found = false;
            
                for (a in adjacent) {
                    if (Type.enumEq(a.arcadeType, condition.arguments.last())) {
                        found = true;
                    }
                }
                
                if (!found) {
                    return false;
                }
            }
        }
    
        return true;
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
                satisfyAdjacent(stipulation, arcades);
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
