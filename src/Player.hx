import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

class Player extends Entity
{
    var speed = 10;
    
    public function new(x: Int, y: Int) {
        super(x, y);
        graphic = new Image("graphics/block.png");
	setHitboxTo(graphic);
    }

    public override function update() {
        if (Input.check(Key.LEFT) && collide("wall", x-speed, y)==null) {
            moveBy(-speed, 0);
        } else if (Input.check(Key.RIGHT) && collide("wall", x+speed, y)==null) {
            moveBy(speed, 0);
        } else if (Input.check(Key.UP) && collide("wall", x, y-speed)==null) {
            moveBy(0, -speed);
        } else if (Input.check(Key.DOWN) && collide("wall", x, y+speed)==null) {
            moveBy(0, speed);
        }
    }
}
