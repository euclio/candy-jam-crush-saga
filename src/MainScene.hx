import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

class MainScene extends Scene {
    private var rules: List<Rule>;
    private var arcades: List<Arcade>;

    public override function begin() {
        var map = TmxMap.loadFromFile("maps/map.tmx");
        var levelEntity = new TmxEntity(map);

        // load the ground and collision layers, create a collision mask named
        // "wall" from the collision layer
        levelEntity.loadGraphic("graphics/tileset.png", ["ground", "collision"]);
        levelEntity.loadMask("collision", "wall");

        add(levelEntity);
        
        Arcade.tileWidth = map.tileWidth;
        Player.tileWidth = map.tileWidth;
        
        arcades = new List<Arcade>();
        
        for (object in levelEntity.map.getObjectGroup("arcade").objects) {
            var arcadeType:ArcadeType = Type.createEnum(ArcadeType, object.type);
            
            var arcade = new Arcade(object.x, object.y, arcadeType);
            add(arcade);
            arcades.add(arcade);
        }

        add(new Player(map.tileWidth, map.tileHeight));
        
        rules = new List<Rule>();
        var ruleParser = new RuleParser();
        var rule:Rule = ruleParser.rules.first();
        rules.add(rule);
        rule.toString();
}

public override function update() {
    trace(verifyRules(rules));
}

private function verifyRules(rules: List<Rule>) {
    for (rule in rules) {
        if (!rule.verify(arcades)) {
            return false;
        }
    }
        return true;
    }
}
