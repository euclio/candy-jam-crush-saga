import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Player extends Entity {
    public function new(x: Int, y: Int) {
        super(x, y);

        graphic = new Image("graphics/block.png");
    }

    public override function update() {
        if (Input.check(Key.LEFT) && collide("wall", x-10, y)==null) {
            moveBy(-10, 0);
        } else if (Input.check(Key.RIGHT) && collide("wall", x+10, y)==null) {
            moveBy(10, 0);
        } else if (Input.check(Key.UP) && collide("wall", x, y-10)==null) {
            moveBy(0, -10);
        } else if (Input.check(Key.DOWN) && collide("wall", x, y+10)==null) {
            moveBy(0, 10);
        }
    }
}
