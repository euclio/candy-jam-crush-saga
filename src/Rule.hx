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
