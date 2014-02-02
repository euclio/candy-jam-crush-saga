import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Player extends Entity {
    private static inline var MOVE_DISTANCE:Int = 10;

    public function new(x: Int, y: Int) {
        super(x, y);

        graphic = new Image("graphics/block.png");
    }

    public override function update() {
        if (Input.check(Key.LEFT) && collide("wall", x-10, y)==null) {
            moveBy(-MOVE_DISTANCE, 0);
        } else if (Input.check(Key.RIGHT) && collide("wall", x+10, y)==null) {
            moveBy(MOVE_DISTANCE, 0);
        } else if (Input.check(Key.UP) && collide("wall", x, y-10)==null) {
            moveBy(0, -MOVE_DISTANCE);
        } else if (Input.check(Key.DOWN) && collide("wall", x, y+10)==null) {
            moveBy(0, MOVE_DISTANCE);
        }
    }
}
