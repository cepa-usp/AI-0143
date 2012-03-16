package 
{
	import com.eclecticdesignstudio.motion.Actuate;
	import com.eclecticdesignstudio.motion.easing.Linear;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Alexandre
	 */
	public class ParticulaGrande extends Sprite
	{
		public static const CO2:String = "co2";
		public static const H2O:String = "h2o";
		public static const H2:String = "o2";
		
		public static const DIE:String = "die";
		
		private var ANGULAR_SPREAD:Number = 30 * Math.PI / 180;
		private var MOVE_DELAY:Number = 100;
		private var angle:Number = 2 * Math.PI * Math.random();
		private var step:Number = 2;
		
		private var rotStep:Number = Math.random() * 5 + 5;
		private var rotMult:Number;
		
		private var timer:Timer;
		
		private var area:MovieClip;
		private var marked:Boolean
		private var lifeTimer:Timer;
		
		public function ParticulaGrande(type:String, area:MovieClip, lifeTime:Number, marked:Boolean = false) 
		{
			this.area = area;
			this.marked = marked;
			
			lifeTimer = new Timer(lifeTime * 1000, 1);
			lifeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, startDie);
			
			x = area.x + Math.random() * area.width;
			y = area.y + Math.random() * area.height;
			
			if (Math.random() > 0.5) rotMult = 1;
			else rotMult = -1;
			
			var cor:uint;
			switch(type) {
				case CO2:
					if (marked) addChild(new Part_CO2_m());
					else addChild(new Part_CO2());
					break;
				case H2O:
					if (marked) addChild(new Part_H2O_m());
					else addChild(new Part_H2O());
					MOVE_DELAY = 80;
					step = 10;
					ANGULAR_SPREAD = 180 * Math.PI / 180;
					break;
				case H2:
					if (marked) addChild(new Part_H2_m());
					else addChild(new Part_H2());
					break;
				default:
					if (marked) addChild(new Part_CO2_m());
					else addChild(new Part_CO2());
					break;
			}
			
			//this.alpha = 0;
			scaleX = scaleY = 0;
			
			//drawParticula(cor);
		}
		
		private function startDie(e:TimerEvent):void 
		{
			//Actuate.tween(this, 1, { alpha: 0 } ).ease(Linear.easeNone).onComplete(die);
			Actuate.tween(this, 1, { scaleX: 0, scaleY: 0 } ).ease(Linear.easeNone).onComplete(die);
		}
		
		private function die():void 
		{
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, nextMove);
			dispatchEvent(new Event(DIE, true));
		}
		
		private function drawParticula(cor:uint):void 
		{
			graphics.beginFill(cor);
			graphics.drawCircle(0, 0, 10);
			
			if (marked) this.filters = [new GlowFilter(0xFF0000)];
		}
		
		public function startMoving():void
		{
			timer = new Timer(MOVE_DELAY);
			timer.addEventListener(TimerEvent.TIMER, nextMove);
			timer.start();
			
			lifeTimer.start();
			
			//Actuate.tween(this, 1, { alpha: 1 } ).ease(Linear.easeNone);
			Actuate.tween(this, 1, { scaleX: 1, scaleY: 1 } ).ease(Linear.easeNone);
			this.scaleX = this.scaleY = Math.min(Math.random() + 0.2, 1);
			
			startScaleTimer();
		}
		
		private var scaleTimer:Timer;
		private function startScaleTimer():void 
		{
			var timerTime:Number = Math.min(Math.random() * 5, 1);
			//scaleTimer = new Timer(timerTime * 1000, 1);
			//scaleTimer.addEventListener(TimerEvent.TIMER_COMPLETE, startScaleTimer, false, 0, true);
			
			var newScale:Number = Math.min(Math.random() + 0.2, 1);
			Actuate.tween(this, timerTime, { scaleX: newScale, scaleY: newScale } ).ease(Linear.easeNone).onComplete(startScaleTimer);
		}
		
		private function nextMove (event:Event = null) : void {
				
			angle += ANGULAR_SPREAD * (Math.random() - 1/2);
				
			var xpos:Number = x + step * Math.cos(angle);
			var ypos:Number = y + step * Math.sin(angle);
			
			while (!area.hitTestPoint(xpos, ypos)) {
				
				angle += Math.PI / 2;
				
				xpos = x + step * Math.cos(angle);
				ypos = y + step * Math.sin(angle);
				
				rotMult *= -1;
			}
			
			var newRotation:Number = rotation + rotMult * rotStep;
			
			var tmp_x:Number = x;
			var tmp_y:Number = y;
			
			Actuate.tween(this, MOVE_DELAY / 1000, { x: xpos, y: ypos, rotation: newRotation} ).ease(Linear.easeNone);
			
			//x = xpos;
			//y = ypos;
			
		}
	}

}