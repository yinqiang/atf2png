package
{
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import polly.atf2png.FileUtil;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Main extends Sprite
	{
		private var img:Image;
		private var curFileName:String;
		private var files:Array;
		private var index:int;
		
		public function Main() 
		{
			files = File.applicationDirectory.resolvePath('atfs').getDirectoryListing();
			index = 0;
			loadFile(index);
		}
		
		private function loadFile(n:int):void {
			var file:File = files[n];
			curFileName = file.name.split('.')[0];
			trace('<', file.name);
			var atfData:ByteArray = FileUtil.readBinFile(file);
			var t:Texture = Texture.fromAtfData(atfData);
			if (img) {
				img.width = t.width;
				img.height = t.height;
				img.texture = t;
			} else {
				img = new Image(t);
				addChild(img);
			}
			Starling.juggler.delayCall(drawScreen, 2);
		}
		
		private function drawScreen():void
		{
			var bd:BitmapData = new BitmapData(img.width, img.height, true, 0);
			try {
				var support:RenderSupport = new RenderSupport();
				RenderSupport.clear(stage.color, 1.0);
				support.setOrthographicProjection(0, 0, stage.stageWidth, stage.stageHeight);
				Starling.current.root.render(support, 1.0);
				support.finishQuadBatch();
				
				Starling.context.drawToBitmapData(bd);
				Starling.context.present();
				var f:File = File.desktopDirectory.resolvePath('pngs/' + curFileName + '.png');
				FileUtil.savePNGFile(bd, f);
				trace('>', curFileName + '.png');
			} catch (e:Error) {
				trace('!', curFileName);
			}
			index ++;
			if (index == files.length) {
				trace('done');
				
			} else {
				loadFile(index);
			}
		}
	}
}