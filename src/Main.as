package
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import polly.atf2png.FileUtil;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class Main extends Sprite
	{
		private var img:Image;
		private var curFileName:String;
		private var files:Array;
		private var index:int;
		private var inportDir:File;
		private var exportDir:File;
		
		public function Main() 
		{
			inportDir = new File();
			inportDir.addEventListener(Event.SELECT, onInportDirSelected);
			inportDir.browseForDirectory("导入");
		}
		
		private function onInportDirSelected(e:Event):void {
			exportDir = new File();
			exportDir.addEventListener(Event.SELECT, onExportDirSelected);
			exportDir.browseForDirectory("导出");
		}
		
		private function onExportDirSelected(e:Event):void {
			files = inportDir.getDirectoryListing();
			for (var i:int=0; i<files.length; i++) {
				if (String(files[i].type).toLowerCase() != '.atf') {
					files.splice(i, 1);
					i--;
				}
			}
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
				var file:File = exportDir.resolvePath(curFileName + '.png');
				FileUtil.savePNGFile(bd, file);
				trace('>', file.name);
			} catch (e:Error) {
				trace('!', e);
			}
			index ++;
			if (index == files.length) {
				trace('done');
				removeChildren();
				var tx:TextField = new TextField(300, 50, "全部完成", "微软雅黑", 30, 0, true);
				addChild(tx);
			} else {
				loadFile(index);
			}
		}
	}
}