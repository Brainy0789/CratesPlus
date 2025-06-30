package backend.objects;

import flixel.FlxG;

class Player extends MovingTile {
	public var tileMap:TileMap;

	public function new(tileMap:TileMap, gx:Int, gy:Int)
	{
		super(gx, gy, 0, 5);
		this.tileMap = tileMap;
    }

	override public function update(elapsed:Float):Void
	{
        super.update(elapsed);

		if (FlxG.keys.justPressed.LEFT)
			tryMove(-1, 0);
		if (FlxG.keys.justPressed.RIGHT)
			tryMove(1, 0);
		if (FlxG.keys.justPressed.UP)
			tryMove(0, -1);
		if (FlxG.keys.justPressed.DOWN)
			tryMove(0, 1);
	}

	private function tryMove(dx:Int, dy:Int):Void
	{
		var tx = gx + dx, ty = gy + dy;
		if (tileMap.crateAt(tx, ty))
		{
			var nx = tx + dx, ny = ty + dy;
			if (!tileMap.isOccupied(nx, ny))
			{
				for (c in tileMap.crates)
					if (c.gx == tx && c.gy == ty)
					{
						c.moveTiles(dx, dy);
						break;
					}
				moveTiles(dx, dy);
			}
			return;
		}
		if (!tileMap.isBlocked(tx, ty))
		{
			moveTiles(dx, dy);
		}
	}

}
