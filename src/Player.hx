import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Player extends Entity {
    var speed = 32;

    public function new(x: Int, y: Int) {
        super(x, y);
        graphic = new Image("graphics/block.png");
        setHitboxTo(graphic);
    }

    public override function update() {
        var x_distance = 0;
        var y_distance = 0;

        if (Input.check(Key.LEFT) && collide("wall", x-10, y)==null) {
            x_distance = -speed;
            y_distance = 0;
        } else if (Input.check(Key.RIGHT) && collide("wall", x+10, y)==null) {
            x_distance = speed;
            y_distance = 0;
        } else if (Input.check(Key.UP) && collide("wall", x, y-10)==null) {
            x_distance = 0;
            y_distance = -speed;
        } else if (Input.check(Key.DOWN) && collide("wall", x, y+10)==null) {
            x_distance = 0;
            y_distance = speed;
        }

        moveBy(x_distance, y_distance, "arcade");
    }
}
