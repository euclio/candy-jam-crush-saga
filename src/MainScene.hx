import com.haxepunk.Scene;
import com.haxepunk.graphics.Image;
import com.haxepunk.tmx.TmxEntity;

class MainScene extends Scene 
{
    public override function begin() {
	var level = new TmxEntity("maps/test.tmx");
	
	// load the ground and collision layers, create a collision mask named "wall" from the collision layer
	level.loadGraphic("graphics/tileset.png", ["ground", "collision"]);
	level.loadMask("collision", "wall");
	
	add(level);
	
	add(new Player(level.map.tileWidth, level.map.tileHeight));
    }
}
