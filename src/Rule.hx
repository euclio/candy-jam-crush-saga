typedef Stipulation = {type: RuleType, arguments: List<ArcadeType>};

enum RuleType {
    Adjacent;
    SameRow;
    SameCol;
    GreenZone;
    Bubble;
}

class Rule {
    public var conditions: List<Stipulation>;

    public function new() {
        conditions = new List<Stipulation>();
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
