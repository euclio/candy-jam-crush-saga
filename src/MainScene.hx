import com.haxepunk.Scene;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.graphics.Image;


class MainScene extends Scene {
    public override function begin() {
        // create the map
	var e = new TmxEntity("maps/test.tmx");
	// load layers named bottom, main, top with the appropriate tileset
	e.loadGraphic("graphics/tileset.png", ["ground", "collision"]);
	// loads a grid layer named collision and sets the entity type to walls
	//e.loadMask("collision", "walls");
	add(e);
	add(new Player(30, 50));
    }
}
