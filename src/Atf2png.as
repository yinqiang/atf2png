package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import starling.core.Starling;
	
	[SWF(width="2048", height="2048")]
	
	public class Atf2png extends Sprite
	{
		public static var isDebug:Boolean = false;
		
		private var txLog:TextField;
		private var mStarling:Starling;
		
		public function Atf2png()
		{
			if (stage) {
				init(null);
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Starling.multitouchEnabled = false;
			
			var viewPort:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			mStarling = new Starling(Main, stage, viewPort);
			mStarling.simulateMultitouch = false;
			mStarling.enableErrorChecking = isDebug;
			mStarling.showStats = isDebug;
			mStarling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}
		
		private function onContextCreated(e:flash.events.Event):void
		{
			mStarling.start();
		}
	}
}