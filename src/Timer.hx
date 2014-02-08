import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;

class Timer extends Entity {
    private var text: Text;
    private var currentTime: Float;
    private var running: Bool;
    private var startTime: Float;


    public function new(x: Int, y: Int, time: Float) {
        super();

        this.type = "timer";
        this.text = new Text(Std.string(time), x, y);
        this.graphic = this.text;
        this.stop();
        this.startTime = time;
        this.running = false;
    }

    public override function update() {
        if (running) {
            currentTime -= HXP.elapsed;
            if (currentTime < 0) {
                this.stop();
            } else {
                text.text = Std.string(Std.int(currentTime));
            }
        }
    }

    public function stop() {
        running = false;
        text.alpha = 0;
    }

    public function start() {
        currentTime = startTime;
        running = true;
        text.alpha = 1;
    }
}
