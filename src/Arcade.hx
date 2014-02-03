import com.haxepunk.Entity;
import com.haxepunk.Graphic;
import com.haxepunk.graphics.Image;
import com.haxepunk.HXP;
import com.haxepunk.tweens.motion.LinearMotion;

class Arcade extends Entity {
    private var tileWidth: Int;
    private var tween:LinearMotion;
    private var topHalf:Entity;

    public function new(x: Int, y: Int, tileWidth: Int) {
        super(x, y);
        graphic = new Image("graphics/arcade32bottom.png");
        setHitboxTo(graphic);
        
        topHalf = new Entity(x, y - tileWidth, new Image("graphics/arcade32top.png"));

        type = "arcade";
        tween = new LinearMotion(tweenEnds);

        addTween(tween);
        this.tileWidth = tileWidth;
    }

    public function push(x: Int, y: Int) {
        tween.setMotion(this.x, this.y, this.x + x, this.y + y, .1);
        tween.start();
    }

    function tweenEnds(event:Dynamic) {
        moveTo(tween.x, tween.y);
        topHalf.moveTo(tween.x, tween.y - tileWidth);
    }

    public override function added() {
        this.scene.add(topHalf);
    }

    public override function update() {
        if (tween.active) {
            moveTo(tween.x, tween.y);
            topHalf.moveTo(tween.x, tween.y - tileWidth);
        }
    }
}
