package 
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class Particula extends Sprite
	{
		public static const CO2:String = "co2";
		public static const H2O:String = "h2o";
		public static const H2:String = "o2";
		
		private var MOVE_DELAY:Number = 100;
		
		private var timer:Timer;
		private const L:Number = 0.00001;
		
		private var area:MovieClip;
		private var marked:Boolean;
		
		private var ANGULAR_SPREAD:Number = 30 * Math.PI / 180;
		private var angle:Number = 2 * Math.PI * Math.random();
		private var step:Number = 2;
		
		public function Particula(type:String, area:MovieClip, marked:Boolean = false) 
		{
			this.area = area;
			this.marked = marked;
			
			x = area.x + Math.random() * area.width;
			y = area.y + Math.random() * area.height;
			
			var cor:uint;
			switch(type) {
				case CO2:
					cor = 0x282828;
					break;
				case H2O:
					cor = 0x0000FF;
					ANGULAR_SPREAD = 180 * Math.PI / 180;
					step = 2;
					MOVE_DELAY = 50;
					break;
				case H2:
					cor = 0xFF8040
					break;
				default:
					cor = 0xFFFFFF;
					break;
			}
			
			drawParticula(cor);
		}
		
		private function drawParticula(cor:uint):void 
		{
			graphics.beginFill(cor);
			graphics.drawRect( 0, 0, 1.5, 1.5);
		}
		
		public function startMoving():void
		{
			timer = new Timer(MOVE_DELAY);
			timer.addEventListener(TimerEvent.TIMER, nextMove);
			timer.start();
		}
		
		private function move(event:TimerEvent) : void {
			var	angle:Number = 2 * Math.PI * Math.random();
			
			var xpos:Number = area.x + area.width*Math.random();
			var ypos:Number = area.y + area.height*Math.random();
			
			var tmp_x:Number = xpos + L * Math.cos(angle);
			var tmp_y:Number = ypos + L * Math.sin(angle);
			
			while (!area.hitTestPoint(tmp_x, tmp_y)) {
				
				angle += Math.PI / 2;
				
				tmp_x = xpos + L * Math.cos(angle);
				tmp_y = ypos + L * Math.sin(angle);
			}
			
			xpos = tmp_x;
			ypos = tmp_y;
				
			//graphics.lineTo(xpos, ypos);
			
			//ball.x = xpos;
			//ball.y = ypos;
			x = xpos;
			y = ypos;
		}
		
		private function nextMove (event:Event = null) : void {
				
			angle += ANGULAR_SPREAD * (Math.random() - 1/2);
				
			var xpos:Number = x + step * Math.cos(angle);
			var ypos:Number = y + step * Math.sin(angle);
			
			while (!area.hitTestPoint(xpos, ypos)) {
				
				angle += Math.PI / 2;
				
				xpos = x + step * Math.cos(angle);
				ypos = y + step * Math.sin(angle);
			}
			
			var tmp_x:Number = x;
			var tmp_y:Number = y;
			
			Actuate.tween(this, MOVE_DELAY / 1000, { x: xpos, y: ypos } ).ease(Linear.easeNone);
			
			//x = xpos;
			//y = ypos;
			
		}
	}

}