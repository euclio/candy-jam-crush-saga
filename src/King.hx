import com.haxepunk.Entity;

class King extends Entity {
    private var missions = new List();
    private var current_mission:String = null;

    // The number of pixels that the player can get within to hear the next
    // mission
    private inline static var TALKING_AREA = 10;

    public function new(x: Int, y: Int) {
        super(x, y);

        // Placeholder image
        var image = new Image("graphics/block.png");

        graphic = image;

        type = "king";

        setHitbox(image.width + TALKING_AREA, image.height + TALKING_AREA);
    }

    public function displayMission() {


    }
}
