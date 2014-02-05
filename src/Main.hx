import com.haxepunk.Engine;
import com.haxepunk.HXP;

class Main extends Engine 
{
    private static inline var framerate:Int = 30;
    private static inline var screenWidth:Int = 640;
    private static inline var screenHeight:Int =640;

    public override function init() {
        #if debug
            HXP.console.enable();
        #end

        HXP.scene = new MainScene();
    }

    public function new() {
        super(screenWidth, screenHeight, framerate, false);
    }

    static function main() {     
        new Main(); 
    }
}
