import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;

class MainScene extends Scene {
    public override function begin() {
        var map = TmxMap.loadFromFile("maps/test.tmx");
        var levelEntity = new TmxEntity(map);

        // load the ground and collision layers, create a collision mask named
        // "wall" from the collision layer
        levelEntity.loadGraphic("graphics/tileset.png", ["ground", "collision"]);
        levelEntity.loadMask("collision", "wall");

        add(levelEntity);
        
        for (object in levelEntity.map.getObjectGroup("arcade").objects) {
            var arcadeType:ArcadeType = Type.createEnum(ArcadeType, object.type);
            add(new Arcade(object.x, object.y, map.tileWidth, arcadeType));
        }

        add(new Player(map.tileWidth, map.tileHeight, map.tileWidth));
    }
}