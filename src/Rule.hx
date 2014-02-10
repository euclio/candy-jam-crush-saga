typedef Stipulation = {type: RuleType,
                       arguments: List<ArcadeType>};

enum RuleType {
    Adjacent;
    SameRow;
    SameCol;
    GreenZone;
    Bubble(radius: Int);
}

class Rule {
    private var forcedStipulations: List<Stipulation>;
    private var disallowedStipulations: List<Stipulation>;
    
    //debug function
    public function traceString() {
        trace ("forced:");
        for (s in forcedStipulations) {
            trace(s.type);
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
                        Bubble(Std.parseInt((stipulationXml.get("r"))));
                    default:
                        trace("Error: invalid stipulation type encountered");
                        throw "error";
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
    
    private function isSatisfied(colFunc: Arcade->Void, condition: Stipulation, arcades: List<Arcade>, disallowed: Bool) {
        for (arcade in arcades.filter(
                                    function(a) { 
                                        return Type.enumEq(a.arcadeType, condition.arguments.last()); 
                                    } )) {
            
            colFunc(arcade);
            
            var collides = new Array<Arcade>();
            arcade.collideInto("arcade", arcade.x, arcade.y, collides);
            arcade.resetHitbox();
            
            if (Type.enumEq(condition.arguments.first(), ArcadeType.any)) {
                if (collides.length == 0) {
                    return false;
                }
            } 
            else { 
                try{
                    for (a in collides) {
                        if (Type.enumEq(a.arcadeType, condition.arguments.first())) {
                            throw "found";
                        }
                    }
                    return false;
                }
                catch (e : Dynamic){}
            }
            if (disallowed) {
                return true;
            }
        }
        return true;
    }

    private function getColFunc(type: RuleType): Arcade -> Void {
        return switch(type) {
            case Adjacent:
                 function (arcade: Arcade) {
                    arcade.setHitbox(
                        MainScene.tileWidth * 3, MainScene.tileWidth * 3,
                        MainScene.tileWidth,  MainScene.tileWidth);
                 };
            case SameRow:
                function (arcade: Arcade) {
                    arcade.setHitbox(MainScene.tileWidth * MainScene.mapWidth, MainScene.tileWidth,
                        (MainScene.tileWidth * MainScene.mapWidth) - (MainScene.tileWidth * (MainScene.mapWidth-cast(arcade.x/MainScene.tileWidth, Int))),  0);
                };
            case SameCol:
                function (arcade: Arcade) {
                    arcade.setHitbox(MainScene.tileWidth, MainScene.tileWidth * MainScene.mapHeight,
                        0, (MainScene.tileWidth * MainScene.mapHeight) - (MainScene.tileWidth * (MainScene.mapHeight-cast(arcade.x/MainScene.tileWidth, Int))));
                };
            case GreenZone:
                 function (arcade: Arcade) {
                     // No need to change the hitbox
                 };
            case Bubble(radius):
                 function (arcade: Arcade) {
                     var bubbleRadius = MainScene.tileWidth * (2 + radius);
                     arcade.setHitbox(bubbleRadius, bubbleRadius,
                                      MainScene.tileWidth * radius,
                                      MainScene.tileWidth * radius);

                 };
        }
    }

    public function verify(arcades: List<Arcade>): Bool {
        for (stipulation in forcedStipulations) {
            if (!isSatisfied(getColFunc(stipulation.type), stipulation, arcades, false)) {
                return false;
            }
        }

        for (stipulation in disallowedStipulations) {
            if (isSatisfied(getColFunc(stipulation.type), stipulation, arcades, true)) {
                return false;
            }
        }

        return true;
    }
}
