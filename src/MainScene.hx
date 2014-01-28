import com.haxepunk.Scene;

class MainScene extends Scene {
    public override function begin() {
        add(new Player(30, 50));
    }
}
