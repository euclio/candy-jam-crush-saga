import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.tweens.motion.LinearMotion;

class Player extends Entity {
    private var tween:LinearMotion;
    private var tileWidth: Int;

    public function new(x: Int, y: Int, tileWidth:Int) {
        super(x, y);
        graphic = new Image("graphics/block.png");
        setHitboxTo(graphic);
        
        this.tileWidth = tileWidth;
        
        tween = new LinearMotion(tweenEnds);
        addTween(tween);
    }

    function tweenEnds(event:Dynamic) {
        moveTo(tween.x, tween.y);
    }

    public override function update() {
        if (tween.active) {
            moveTo(tween.x, tween.y);
        } 
        else if (Input.lastKey !=0){
            var x_distance = 0;
            var y_distance = 0;
            var moved:Bool = false;
            
            if (Input.check(Key.LEFT)) {
                x_distance = -tileWidth;
                y_distance = 0;
                moved = true;
            } else if (Input.check(Key.RIGHT)) {
                x_distance = tileWidth;
                y_distance = 0;
                moved = true;
            } else if (Input.check(Key.UP)) {
                x_distance = 0;
                y_distance = -tileWidth;
                moved = true;
            } else if (Input.check(Key.DOWN)) {
                x_distance = 0;
                y_distance = tileWidth;
                moved = true;
            }
            
            if (moved) {
                var e = collide("arcade", x + x_distance, y + y_distance);
            
                if (e != null) {
                    if (!cast(e, Arcade).checkCollides(x_distance, y_distance)) {
                        cast(e, Arcade).push(x_distance, y_distance);
                        tween.setMotion(this.x, this.y, this.x + x_distance, this.y + y_distance, .1);
                        tween.start();
                    }
                }
                else if (collide("wall", x + x_distance, y + y_distance) == null) {
                    tween.setMotion(this.x, this.y, this.x + x_distance, this.y + y_distance, .1);
                    tween.start();
                }
            }
        }
    }
}