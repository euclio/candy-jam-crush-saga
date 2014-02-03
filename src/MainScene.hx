import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.tmx.TmxEntity;

class MainScene extends Scene {
    private var rules: List<Rule>;

    public override function begin() {
        var ruleParser = new RuleParser();
        rules = ruleParser.rules;

        var level = new TmxEntity("maps/test.tmx");

        // load the ground and collision layers, create a collision mask named
        // "wall" from the collision layer
        level.loadGraphic("graphics/tileset.png", ["ground", "collision"]);
        level.loadMask("collision", "wall");

        add(level);

        add(new Player(level.map.tileWidth, level.map.tileHeight, level.map.tileWidth));
        add(new Arcade(level.map.tileWidth * 5, level.map.tileHeight * 5, level.map.tileWidth));
    }
}
