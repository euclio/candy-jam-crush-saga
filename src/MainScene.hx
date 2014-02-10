import com.haxepunk.HXP;
import com.haxepunk.Scene;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Text;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;
import flash.geom.Rectangle;
import com.haxepunk.utils.Draw;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.graphics.Text;
import com.haxepunk.graphics.Image;
import com.haxepunk.Entity;
import com.haxepunk.Sfx;

enum GameState {
    Playing;
    Waiting;
    Over;
}

class MainScene extends Scene {
    private var rules: List<Rule>;
    private var availableRules: Array<Rule>;
    private var arcades: List<Arcade>;
    private var timer: Timer;
    private var ruleParser: RuleParser;
    private var king: Image;
    private var map: TmxMap;
    private var levelEntity: TmxEntity;
    private var player: Player;
    private var music: Sfx;
    private var musicOn: Bool;
    
    private var rulesText: Text;
    private var instructionText: Text;
    private var loseText: Text;
    
    public static var tileWidth: Int;
    public static var mapWidth: Int;
    public static var mapHeight: Int;
    public static var greenZone: GreenZone;

    private static inline var LEVEL_TIME: Float = 15;
    
    public static var state: GameState;

    public override function begin() {
        state = GameState.Waiting;
    
        map = TmxMap.loadFromFile("maps/map.tmx");
        levelEntity = new TmxEntity(map);

        // Create a collision mask named "wall" from the collision layer
        levelEntity.loadGraphic("graphics/tileset.png", ["ground", "collision"]);
        levelEntity.loadMask("collision", "wall");

        add(levelEntity);

        tileWidth = map.tileWidth;
        mapWidth = map.width;
        mapHeight = map.height;

        greenZone = new GreenZone(3);
        add(greenZone);

        addArcades();

        king = new Image("graphics/theking.png");
        
        player = new Player(map.tileWidth, map.tileHeight);

        add(player);
        add(new Entity((tileWidth * mapWidth) + 20, tileWidth * (mapHeight/4), king));
        
        instructionText = new Text("Press enter to start!", (mapWidth * tileWidth)+30, 10);
        rulesText = new Text("",  0, mapHeight * tileWidth, {size: 15, color: 0xFFFFFF});
        
        loseText = new Text("NO", 0, 200, {size: 500, color: 0xFF0000});
        loseText.alpha = 0;
        
        addGraphic(instructionText);
        addGraphic(rulesText);
        addGraphic(loseText);
        
        music = new Sfx("audio/mindcoupe.mp3");
        musicOn = false;
        
        rules = new List<Rule>();
        ruleParser = new RuleParser();
        
        availableRules = ruleParser.rules.copy();
        
        timer = new Timer((tileWidth * mapWidth) + 80, 40, LEVEL_TIME, 
            function() {
                if (verifyRules(rules)) {
                    startLevel();
                    state = GameState.Waiting;
                }
                else {
                    restartGame();
                }
            });
        add(timer);
        
        startLevel();
    }
    
    private function startLevel() {
        if (availableRules.length > 0) {
            var i = Std.random(availableRules.length);
            var rule = availableRules[i];
            var oppositeRule;
            
            if ((i % 2) != 0) {
                oppositeRule = availableRules[i-1];
            }
            else {
                oppositeRule = availableRules[i+1];
            }
        
            availableRules.remove(oppositeRule);
            availableRules.remove(rule);
                        
            rules.add(rule);
            
            var str = "";
            for (r in rules) {
                str += r.getDialogue() + "\n";
            }
            rulesText.text = str;
        }
        else {
            restartGame();
            instructionText.text = "You win! Press space to restart";
        }
    }

    public override function update() {
        switch (state) {
            case Waiting:
                if (Input.check(Key.ENTER)) {
                    timer.start();
                    instructionText.text = "Press space to stop";
                    state = GameState.Playing;
                    
                    if (!musicOn) {
                        music.loop();
                        musicOn = true;
                    }
                }
            case Playing:
                if (Input.check(Key.SPACE)) {
                    state = GameState.Waiting;
                    instructionText.alpha = 1;
                    instructionText.text = "Press enter to start";
                    timer.stop();
                }
            case Over:
                if (Input.check(Key.SPACE)) {
                    rules = new List<Rule>();
                    availableRules = ruleParser.rules.copy();
                    loseText.alpha = 0;
                    rulesText.text = "";
                    king.scaleX = 1;
                    king.scaleY = 1;
                    king.x = 0;
                    king.y = 0;
                    player.x = map.tileWidth;
                    player.y = map.tileHeight;
                    
                    instructionText.text = "Press enter to start";
                    
                    removeList(arcades);
                    addArcades();
                    
                    startLevel();
                    
                    state = GameState.Waiting;
                }
        }
    
        super.update();
    }
    
    private function restartGame() {
        state = GameState.Over;
        loseText.alpha = 1;
        king.scaleX = 2;
        king.scaleY = 2;
        king.x = -100;
        king.y = -100;
                    
        instructionText.text = "Press space to restart";
                    
        for (i in 0...100000000){}
    }
    
    private function addArcades() {
        arcades = new List<Arcade>();

        for (object in levelEntity.map.getObjectGroup("arcade").objects) {
            var arcadeType:ArcadeType = Type.createEnum(ArcadeType, object.type);

            var arcade = new Arcade(object.x, object.y, arcadeType);
            add(arcade);
            arcades.add(arcade);
        }
    }

    private function verifyRules(rules: List<Rule>) {
        for (rule in rules) {
            if (!rule.verify(arcades)) {
                return false;
            }
        }
        return true;
    }    
}