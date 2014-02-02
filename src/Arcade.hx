import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.tweens.motion.LinearMotion;

class Arcade extends Entity {
    private var tileWidth: Int;
    private var tween:LinearMotion;

    public function new(x: Int, y: Int, tileWidth: Int) {
        super(x, y);
        graphic = new Image("graphics/block.png");
        setHitboxTo(graphic);

        type = "arcade";
        tween = new LinearMotion();

        this.tileWidth = tileWidth;
    }

    private function push(x: Int, y: Int) {
        tween.setMotion(this.x, this.y, this.x + x, this.y + y, .2);
        addTween(tween);
        tween.start();
    }

    public function pushX(x: Int) {
        push(x, 0);
    }

    public function pushY(y: Int) {
        push(0, y);
    }

    public override function update() {
        if (hasTween) {
            moveTo(tween.x, tween.y);
        }
    }
}
