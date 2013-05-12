package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	[SWF(width="2048", height="2048")]
	
	public class Atf2png extends Sprite
	{
		public static var isDebug:Boolean = false;
		
		private var mStarling:Starling;
		
		public function Atf2png()
		{
			Starling.multitouchEnabled = false;
			
			var viewPort:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			mStarling = new Starling(Main, stage, viewPort);
			mStarling.simulateMultitouch = false;
			mStarling.enableErrorChecking = isDebug;
			mStarling.showStats = isDebug;
			mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}
		
		private function onContextCreated(e:Event):void
		{
			mStarling.start();
		}
	}
}