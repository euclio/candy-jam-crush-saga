import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class GreenZone extends Entity {
    public function new(tileHeight: Int) {
        var yPos = (MainScene.mapHeight - tileHeight) * MainScene.tileWidth;
        super(0, yPos);

        var width = MainScene.mapWidth * MainScene.tileWidth;
        var height = tileHeight * MainScene.tileWidth;
        setHitbox(width, height);
    }
}
