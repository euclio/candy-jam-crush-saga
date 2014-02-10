import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.tweens.motion.LinearMotion;

class Player extends Entity {
    private var tween:LinearMotion;
    
    private var images: Array<Image>;
    private var direction:Int;

    public function new(x: Int, y: Int) {
        super(x, y);
        
        images = new Array<Image>();
        
        images[Direction.UP] = new Image("graphics/playerup.png");
        images[Direction.DOWN] = new Image("graphics/playerdown.png");
        images[Direction.LEFT] = new Image("graphics/playerleft.png");
        
        var right = new Image("graphics/playerleft.png");
        right.flipped = true;
        
        images[Direction.RIGHT] = right;
        
        direction = Direction.RIGHT;
        graphic = images[direction];

        setHitboxTo(graphic);
                
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
                x_distance = -MainScene.tileWidth;
                y_distance = 0;
                moved = true;
                if (direction != Direction.LEFT) {
                    direction = Direction.LEFT;
                    graphic = images[direction];
                }
            } else if (Input.check(Key.RIGHT)) {
                x_distance = MainScene.tileWidth;
                y_distance = 0;
                moved = true;
                if (direction != Direction.RIGHT) {
                    direction = Direction.RIGHT;
                    graphic = images[direction];
                }
            } else if (Input.check(Key.UP)) {
                x_distance = 0;
                y_distance = -MainScene.tileWidth;
                moved = true;
                if (direction != Direction.UP) {
                    direction = Direction.UP;
                    graphic = images[direction];
                }
            } else if (Input.check(Key.DOWN)) {
                x_distance = 0;
                y_distance = MainScene.tileWidth;
                moved = true;
                if (direction != Direction.DOWN) {
                    direction = Direction.DOWN;
                    graphic = images[direction];
                }
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